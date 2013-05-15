
module DmIsReflective::MysqlAdapter
  include DataMapper

  def storages
    select('SHOW TABLES')
  end

  private
  # construct needed table metadata
  def reflective_query_storage storage
    sql = <<-SQL
      SELECT c.column_name, c.column_key, c.column_default, c.is_nullable,
             c.data_type, c.character_maximum_length, c.extra, c.table_name,
             s.index_name
      FROM      `information_schema`.`columns` c
      LEFT JOIN `information_schema`.`statistics` s
      ON       c.column_name = s.column_name
      WHERE    c.table_schema = ? AND c.table_name = ?
      GROUP BY c.column_name;
    SQL

    # TODO: can we fix this shit in dm-mysql-adapter?
    path = (options[:path]     || options['path'] ||
            options[:database] || options['database']).sub('/', '')

    select(Ext::String.compress_lines(sql), path, storage)
  end

  def reflective_field_name field
    field.column_name
  end

  def reflective_primitive field
    field.data_type
  end

  def reflective_attributes field, attrs = {}
    attrs[:serial] = true if field.extra      == 'auto_increment'

    case field.column_key
    when 'PRI'
      attrs[:key] = true
      attrs[:unique_index] = :"#{field.table_name}_pkey"
    when 'UNI'
      attrs[:unique_index] = :"#{field.index_name}"
    when 'MUL'
      attrs[:index]        = :"#{field.index_name}"
    end

    attrs[:allow_nil] = field.is_nullable == 'YES'
    attrs[:default]  = field.column_default           if
      field.column_default

    attrs[:length]   = field.character_maximum_length if
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
