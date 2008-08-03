
require 'dm-mapping/adapters/abstract_adapter'
require 'dm-mapping/type_map'

module DataMapper
  module Adapters
    class Sqlite3Adapter < DataObjectsAdapter
      module Migration
        def storages
# activerecord-2.1.0/lib/active_record/connection_adapters/sqlite_adapter.rb: 177
          sql = <<-SQL
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

            # stupid hack
            type = String if type == Class

            [field.name, type] #, chain.attributes]
          }
        end
      end
    end
  end
end
