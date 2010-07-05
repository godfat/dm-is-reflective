
require 'test/abstract'

TestCase = begin
             require 'minitest/unit'
             MiniTest::Unit.autorun
             MiniTest::Unit::TestCase
           rescue LoadError
             require 'test/unit'
             Test::Unit::TestCase
           end

%w[sqlite mysql postgres].each{ |adapter|
  begin
    require "dm-#{adapter}-adapter"
  rescue LoadError
    puts "skip #{adapter} test since it's not installed"
  end
}

# cost 1 second to run
class Sqlite3Test < TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite3::memory:')
  end
end if defined?(DataObjects::Sqlite3)


# cost 2 seconds to run
class MysqlTest < TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'mysql://dm_is_reflective:godfat@localhost/dm_is_reflective')
  end
end if defined?(DataObjects::Mysql)


# cost 3 seconds to run
class PostgresTest < TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'postgres://dm_is_reflective:godfat@localhost/dm_is_reflective')
  end
end if defined?(DataObjects::Postgres)
