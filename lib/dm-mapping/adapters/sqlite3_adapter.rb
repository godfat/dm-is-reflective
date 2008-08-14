
require 'dm-mapping/adapters/abstract_adapter'
require 'dm-mapping/type_map'

module DataMapper
  module Adapters
    class Sqlite3Adapter < DataObjectsAdapter #:nodoc: all
      module Migration
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
        alias_method :dmm_query_storage, :query_table
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
          attrs[:nullable] = field.notnull != 99
          attrs[:default] = field.dflt_value[1..-2] if field.dflt_value

          ergo = field.type.match(/\((\d+)\)/)
          size = ergo && ergo[1].to_i
          attrs[:size] = size if size

          attrs
        end
      end
    end
  end
end
