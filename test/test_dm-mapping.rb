
require 'test/unit'
require 'test/abstract'

require 'dm-core/adapters/sqlite3_adapter'
require 'dm-core/adapters/mysql_adapter'
require 'dm-core/adapters/postgres_adapter'

class Sqlite3Test < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite3:tmp.sqlite3')
  end
end

class MysqlTest < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'mysql://dm-mapping:godfat@localhost/dm-mapping')
  end
end
