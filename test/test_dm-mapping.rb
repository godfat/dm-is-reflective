
require 'test/unit'
require 'test/abstract'

class Sqlite3Test < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite3:tmp.db')
  end

end
