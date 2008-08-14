
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

  def user_fields
    [['created_at', DateTime, AttrCommon],
     ['id',         Integer,  AttrCommonPK],
     ['login',      String,   {:size => 70}.merge(AttrCommon)],
     ['sig',        DM::Text, AttrCommon]]
  end

  def comment_fields
    [['body',    DM::Text, AttrCommon],
     ['id',      Integer,  AttrCommonPK],
     ['title',   String,   {:size => 50, :default => 'default title'}.
                            merge(AttrCommon)],
     ['user_id', Integer,  AttrCommon]]
  end
end

class MysqlTest < Test::Unit::TestCase
  include Abstract

  def setup_data_mapper
    DataMapper.setup(:default, 'mysql://dm-mapping:godfat@localhost/dm-mapping')
  end

  AttrText = {:size => 65535}.merge AttrCommon

  def user_fields
    [['created_at', DateTime, AttrCommon],
     ['id',         Integer,  AttrCommonPK],
     ['login',      String,   {:size => 70}.merge(AttrCommon)],
     ['sig',        DM::Text, AttrText]]
  end

  def comment_fields
    [['body',    DM::Text, AttrText],
     ['id',      Integer,  AttrCommonPK],
     ['title',   String,   {:size => 50, :default => 'default title'}.
                            merge(AttrCommon)],
     ['user_id', Integer,  AttrCommon]]
  end
end
