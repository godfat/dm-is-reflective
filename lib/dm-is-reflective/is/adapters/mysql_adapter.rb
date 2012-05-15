
module DataMapper
  module Is::Reflective
    module MysqlAdapter
      include DataMapper

      def storages
        select('SHOW TABLES')
      end

      private
      # construct needed table metadata
      def reflective_query_storage storage
        sql = <<-SQL
          SELECT column_name, column_default, is_nullable, data_type,
                 character_maximum_length, column_key, extra
          FROM `information_schema`.`columns`
          WHERE `table_schema` = ? AND `table_name` = ?
        SQL

        select(Ext::String.compress_lines(sql),
          options[:path].sub('/', ''), storage)
      end

      def reflective_field_name field
        field.column_name
      end

      def reflective_primitive field
        field.data_type
      end

      def reflective_attributes field, attrs = {}
          attrs[:serial] = true if field.extra      == 'auto_increment'
          attrs[:key]    = true if field.column_key == 'PRI'

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
                                              ; BigDecimal
        when /\w*BLOB|\w*BINARY|ENUM|SET|CHAR/; String
        when 'TIME'                           ; Time
        when 'DATE'                           ; Date
        when 'DATETIME', 'TIMESTAMP'          ; DateTime
        when 'BOOL', 'BOOLEAN'                ; Property::Boolean
        when /\w*TEXT/                        ; Property::Text
        end || super(primitive)
      end
    end
  end
end
