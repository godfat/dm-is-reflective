
module DmIsReflective::MysqlAdapter
  include DataMapper

  def storages
    select('SHOW TABLES')
  end

  def indices storage
    sql = <<-SQL
      SELECT column_name, index_name, non_unique
      FROM   `information_schema`.`statistics`
      WHERE  table_schema = ? AND table_name = ?
    SQL

    select(Ext::String.compress_lines(sql),
      reflective_table_schema, storage).group_by(&:column_name).
        inject({}) do |r, (column, idxs)|
          primary = idxs.find{ |i| i.index_name == 'PRIMARY' }
          primary.index_name = :"#{storage}_pkey" if primary
          key                = !!primary
          idx_uni, idx_com = idxs.partition{ |i| i.non_unique == 0 }.map{ |i|
            if i.empty?
              nil
            elsif i.size == 1
              i.first.index_name.to_sym
            else
              i.map{ |ii| ii.index_name.to_sym }
            end
          }

          r[column.to_sym] = reflective_indices_hash(key, idx_uni, idx_com)
          r
        end
  end

  private
  # construct needed table metadata
  def reflective_query_storage storage
    sql = <<-SQL
      SELECT column_name, column_key, column_default, is_nullable,
             data_type, character_maximum_length, extra, table_name
      FROM      `information_schema`.`columns`
      WHERE  table_schema = ? AND table_name = ?
    SQL

    idxs = indices(storage)

    select(Ext::String.compress_lines(sql),
      reflective_table_schema, storage).map do |f|
        f.define_singleton_method(:indices){ idxs[f.column_name.to_sym] }
        f
      end
  end

  def reflective_field_name field
    field.column_name
  end

  def reflective_primitive field
    field.data_type
  end

  def reflective_attributes field, attrs={}
    attrs.merge!(field.indices) if field.indices

    attrs[:serial] = true if field.extra == 'auto_increment'

    if field.column_key == 'PRI'
      attrs[:key] = true
      attrs[:unique_index] = :"#{field.table_name}_pkey"
    end

    attrs[:allow_nil] = field.is_nullable == 'YES'
    attrs[:default]   = field.column_default           if
      field.column_default

    attrs[:length]    = field.character_maximum_length if
      field.character_maximum_length

    attrs
  end

  def reflective_lookup_primitive primitive
    case primitive.upcase
    when 'YEAR'                           ; Integer
    when /\w*INT(EGER)?( SIGNED| UNSIGNED)?( ZEROFILL)?/
                                          ; Integer
    when /(DOUBLE|FLOAT|DECIMAL)( SIGNED| UNSIGNED)?( ZEROFILL)?/
                                          ; Property::Decimal
    when /\w*BLOB|\w*BINARY|ENUM|SET|CHAR/; String
    when 'TIME'                           ; Time
    when 'DATE'                           ; Date
    when 'DATETIME', 'TIMESTAMP'          ; DateTime
    when 'BOOL', 'BOOLEAN'                ; Property::Boolean
    when /\w*TEXT/                        ; Property::Text
    end || super(primitive)
  end

  def reflective_table_schema
    # TODO: can we fix this shit in dm-mysql-adapter?
    (options[:path]     || options['path'] ||
     options[:database] || options['database']).sub('/', '')
  end
end
