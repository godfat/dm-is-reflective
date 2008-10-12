
require 'test/abstract'
require 'minitest/unit'

MiniTest::Unit.autorun

%w[sqlite3 mysql postgres].each{ |adapter|
  begin
    require "dm-core/adapters/#{adapter}_adapter"
  rescue LoadError
  end
}

# cost 1 second to run
class Sqlite3Test < MiniTest::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite3::memory:')
  end
end if defined?(DataObjects::Sqlite3)


# cost 2 seconds to run
class MysqlTest < MiniTest::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'mysql://dm-mapping:godfat@localhost/dm-mapping')
  end
end if defined?(DataObjects::Mysql)


# cost 3 seconds to run
class PostgresTest < MiniTest::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'postgres://dm-mapping:godfat@localhost/dm-mapping')
  end
end if defined?(DataObjects::Postgres)
