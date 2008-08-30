
require 'dm-mapping/adapters/abstract_adapter'

module DataMapper
  module Adapters
    class MysqlAdapter < DataObjectsAdapter #:nodoc: all
      module Migration
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
            attrs[:serial] = true if field.extra == 'auto_increment'
            attrs[:key] = true if field.column_key == 'PRI'
            attrs[:nullable] = field.is_nullable == 'YES'
            attrs[:default] = field.column_default if field.column_default
            attrs[:size] = field.character_maximum_length if
              field.character_maximum_length

            attrs
        end

        def dmm_lookup_primitive primitive
          case primitive.upcase
            when 'TINYINT', 'SMALLINT', 'MEDIUMINT', 'BIGINT', 'YEAR'; Integer
            when 'DOUBLE'; BigDecimal
            when 'BOOL'; TrueClass
            when 'CHAR', 'ENUM', 'SET', 'TINYBLOB', 'MEDIUMBLOB',
                 'BLOB', 'LONGBLOB', 'BINARY', 'VARBINARY'; String
            when 'TINYTEXT', 'MEDIUMTEXT', 'LONGTEXT'; DM::Text
            else super(primitive)
          end
        end
      end
    end
  end
end
