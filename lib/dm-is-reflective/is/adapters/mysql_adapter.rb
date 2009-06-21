
require 'dm-is-reflective/is/adapters/abstract_adapter'

module DataMapper
  module Is::Reflective
    module MysqlAdapter
      def storages
        query 'SHOW TABLES'
      end

      private
      # construct needed table metadata
      def dmm_query_storage storage
        sql = <<-SQL.compress_lines
          SELECT column_name, column_default, is_nullable, data_type,
                 character_maximum_length, column_key, extra
          FROM `information_schema`.`columns`
          WHERE `table_schema` = ? AND `table_name` = ?
        SQL

        query(sql, db_name, storage)
      end

      def dmm_field_name field
        field.column_name
      end

      def dmm_primitive field
        field.data_type
      end

      def dmm_attributes field, attrs = {}
          attrs[:serial] = true if field.extra      == 'auto_increment'
          attrs[:key] = true    if field.column_key == 'PRI'
          attrs[:nullable] = field.is_nullable == 'YES'

          attrs[:default]  = field.column_default           if
            field.column_default

          attrs[:length]   = field.character_maximum_length if
            field.character_maximum_length

          attrs
      end

      def dmm_lookup_primitive primitive
        p = primitive.upcase

        return Integer    if p == 'YEAR'
        return Integer    if p =~          /\w*INT(EGER)?( SIGNED| UNSIGNED)?( ZEROFILL)?/
        return BigDecimal if p =~ /(DOUBLE|FLOAT|DECIMAL)( SIGNED| UNSIGNED)?( ZEROFILL)?/
        return String     if p =~ /\w*BLOB|\w*BINARY|ENUM|SET|CHAR/
        return Time       if p == 'TIME'
        return DateTime   if p == 'DATETIME'
        return DataMapper::Types::Boolean if %w[BOOL BOOLEAN].member?(p)
        return DataMapper::Types::Text    if p =~ /\w*TEXT/

        super(primitive)
      end
    end
  end
end

module DataMapper
  module Adapters
    MysqlAdapter.send(:include, Is::Reflective::MysqlAdapter)
  end
end
