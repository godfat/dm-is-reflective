
require 'dm-mapping'

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
      end
    end
  end
end
