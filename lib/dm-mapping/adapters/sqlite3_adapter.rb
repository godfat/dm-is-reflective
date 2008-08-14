
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

        def fields table
          query_table(table).map{ |field|
            type, chain = self.class.type_map.
              lookup_primitive(field.type.gsub(/\(\d+\)/, '').upcase)

            attrs = {}
            attrs[:serial] = true if field.pk != 0
            attrs[:nullable] = true if field.notnull != 0 && !attrs[:serial]
            attrs[:default] = field.dflt_value[1..-2] if field.dflt_value

            ergo = field.type.match(/\((\d+)\)/)
            size = ergo && ergo[1].to_i
            attrs[:size] = size if size

            [field.name, type, chain.attributes.merge(attrs)]
          }
        end
      end
    end
  end
end
