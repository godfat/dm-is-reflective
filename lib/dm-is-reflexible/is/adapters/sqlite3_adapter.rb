
require 'dm-is-reflexible/is/adapters/abstract'

module DataMapper
  module Is::Reflexible
    module Sqlite3Adapter
      def storages
# activerecord-2.1.0/lib/active_record/connection_adapters/sqlite_adapter.rb: 177
        sql = <<-SQL.compress_lines
          SELECT name
          FROM sqlite_master
          WHERE type = 'table' AND NOT name = 'sqlite_sequence'
        SQL
# activerecord-2.1.0/lib/active_record/connection_adapters/sqlite_adapter.rb: 181

        query sql
      end

      private
      # alias_method :dmm_query_storages, :query_table
      def dmm_query_storage *args, &block
        query_table(*args, &block)
      end

      def dmm_field_name field
        field.name
      end

      def dmm_primitive field
        field.type.gsub(/\(\d+\)/, '')
      end

      def dmm_attributes field, attrs = {}
        if field.pk != 0
          attrs[:key] = true
          attrs[:serial] = true if supports_serial?
        end
        attrs[:nullable] = field.notnull != 1
        attrs[:default] = field.dflt_value[1..-2] if field.dflt_value

        if field.type.upcase == 'TEXT'
          attrs[:length] = DataMapper::Types::Text.size
        else
          ergo = field.type.match(/\((\d+)\)/)
          size = ergo && ergo[1].to_i
          attrs[:length] = size if size
        end

        attrs
      end
    end
  end
end

module DataMapper
  module Adapters
    Sqlite3Adapter.send(:include, Is::Reflexible::Sqlite3Adapter)
  end
end
