
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
    property :title, String
    property :body,  Text
  end

  class Tmp; end

  @@dm = DataMapper.setup :default, 'sqlite3:tmp.db'
  def dm; @@dm; end

  def setup
    User.auto_migrate!
    Comment.auto_migrate!
  end

  def comment_fields
    [["body",    DataMapper::Types::Text],
     ["id",      Integer                ],
     ["title",   String                 ],
     ["user_id", Integer                ]]
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

    Tmp.send :include, DataMapper::Resource
    local_dm = DataMapper.setup :default, 'sqlite3:tmp.db'
    assert_equal ['dmm_test_comments', 'dmm_test_users'], local_dm.storages.sort

    Tmp.storage_names[:default] = 'dmm_test_comments'
    assert_equal 'dmm_test_comments', Tmp.storage_name

    assert_equal 1, Tmp.count
    assert_equal comment_fields, Tmp.fields.sort

    Tmp.send :mapping
    assert_equal 'XD', Tmp.first.title
    assert_equal 1, Tmp.first.id
  end

end
