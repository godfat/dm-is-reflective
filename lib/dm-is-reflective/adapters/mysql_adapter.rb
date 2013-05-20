
module DmIsReflective::MysqlAdapter
  include DataMapper

  def storages
    select('SHOW TABLES')
  end

  private
  # construct needed table metadata
  def reflective_query_storage storage
    sql_indices = <<-SQL
      SELECT column_name, index_name, non_unique
      FROM   `information_schema`.`statistics`
      WHERE  table_schema = ? AND table_name = ?
    SQL

    sql_columns = <<-SQL
      SELECT column_name, column_key, column_default, is_nullable,
             data_type, character_maximum_length, extra, table_name
      FROM      `information_schema`.`columns`
      WHERE  table_schema = ? AND table_name = ?
    SQL

    # TODO: can we fix this shit in dm-mysql-adapter?
    path = (options[:path]     || options['path'] ||
            options[:database] || options['database']).sub('/', '')

    indices =
    select(Ext::String.compress_lines(sql_indices), path, storage).
      group_by(&:column_name)

    select(Ext::String.compress_lines(sql_columns), path, storage).
    map do |column|
      if idx = indices[column.column_name]
        idx_uni, idx_com = idx.partition{ |i| i.non_unique == 0 }.map{ |i|
          if i.empty?
            nil
          elsif i.size == 1
            i.first.index_name.to_sym
          else
            i.map{ |ii| ii.index_name.to_sym }
          end
        }
      else
        idx_uni, idx_com = nil
      end

      column.instance_eval <<-RUBY
        def unique_index; #{idx_uni.inspect}; end
        def index       ; #{idx_com.inspect}; end
      RUBY

      column
    end
  end

  def reflective_field_name field
    field.column_name
  end

  def reflective_primitive field
    field.data_type
  end

  def reflective_attributes field, attrs = {}
    attrs[:serial] = true if field.extra == 'auto_increment'

    if field.column_key == 'PRI'
      attrs[:key] = true
      attrs[:unique_index] = :"#{field.table_name}_pkey"
    else
      attrs[:unique_index] = field.unique_index if field.unique_index
      attrs[       :index] = field.       index if field.       index
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
end
