
require 'test/unit'
require 'test/abstract'

%w[sqlite3 mysql postgres].each{ |adapter|
  begin
    require "dm-core/adapters/#{adapter}_adapter"
  rescue LoadError
  end
}

# cost 1 second to run
class Sqlite3Test < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite3:tmp.sqlite3')
  end
end if defined?(DataObjects::Sqlite3)


# cost 2 seconds to run
class MysqlTest < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'mysql://dm-mapping:godfat@localhost/dm-mapping')
  end
end if defined?(DataObjects::Mysql)


# cost 3 seconds to run
class PostgresTest < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'postgres://dm-mapping:godfat@localhost/dm-mapping')
  end
end if defined?(DataObjects::Postgres)
