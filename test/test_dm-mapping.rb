
require 'test/unit'

require 'rubygems'
require 'data_mapper'
require 'dm-mapping'

class DMMTest < Test::Unit::TestCase
  class User
    include DataMapper::Resource
    has n, :comments

    property :id,         Integer, :serial => true
    property :login,      String
    property :sig,        Text
    property :created_at, DateTime
  end

  class Comment
    include DataMapper::Resource
    belongs_to :user

    property :id,    Integer, :serial => true
    property :title, String,  :default => 'default title'
    property :body,  Text
  end

  class Model
    include DataMapper::Resource
  end

  @@dm = DataMapper.setup :default, 'sqlite3:tmp.db'
  def dm; @@dm; end

  def setup
    User.auto_migrate!
    Comment.auto_migrate!
  end

  def user_fields
    [['created_at', DateTime,                {}],
     ['id',         Integer,                 {:serial => true}],
     ['login',      String,                  {}],
     ['sig',        DataMapper::Types::Text, {}]]
  end

  def comment_fields
    [['body',    DataMapper::Types::Text, {}],
     ['id',      Integer                , {:serial => true}],
     ['title',   String                 , {:default => 'default title'}],
     ['user_id', Integer                , {}]]
  end

  def test_storages
    assert_equal ['dmm_test_comments', 'dmm_test_users'], dm.storages.sort
    assert_equal comment_fields, dm.fields('dmm_test_comments').sort
  end

  def test_create_comment
    Comment.create(:title => 'XD')
    assert_equal 1, Comment.first.id
    assert_equal 'XD', Comment.first.title
  end

  def test_mapping_all
    test_create_comment # for fixtures

    model = Model.dup
    local_dm = DataMapper.setup :default, 'sqlite3:tmp.db'
    assert_equal ['dmm_test_comments', 'dmm_test_users'], local_dm.storages.sort

    model.storage_names[:default] = 'dmm_test_comments'
    assert_equal 'dmm_test_comments', model.storage_name

    assert_equal 1, model.count
    assert_equal comment_fields, model.fields.sort

    model.send :mapping
    assert_equal 'XD', model.first.title
    assert_equal 1, model.first.id
  end

  def test_mapping_and_create
    model = Model.dup
    local_dm = DataMapper.setup :default, 'sqlite3:tmp.db'
    model.storage_names[:default] = 'dmm_test_comments'
    model.send :mapping

    model.create(:title => 'orz')
    assert_equal 'orz', model.first.title
    assert_equal 1, model.first.id
  end

  def test_storages_and_fields
    assert_equal user_fields, dm.fields('dmm_test_users').sort
    assert_equal( {'dmm_test_users' => user_fields, 'dmm_test_comments' => comment_fields},
                  dm.storages_and_fields.inject({}){ |r, i|
                    key, value = i
                    r[key] = value.sort
                    r
                  } )
  end

end
