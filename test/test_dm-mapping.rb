
require 'test/unit'
require 'test/abstract'

%w[sqlite3 mysql postgres].each{ |adapter|
  begin
    require "dm-core/adapters/#{adapter}_adapter"
  rescue LoadError
  end
}

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
