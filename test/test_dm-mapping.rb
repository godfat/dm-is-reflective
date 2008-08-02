
require 'test/unit'

require 'rubygems'
require 'data_mapper'

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

    property :id,         Integer, :serial => true

    property :title,  String
    property :body,       Text
  end

  class Tmp; end

  def test_storages
    @dm = DataMapper.setup :default, 'sqlite3:test.db'
    require 'dm-mapping'
    DataMapper.auto_migrate!

    assert_equal ['dmm_test_comments', 'dmm_test_users'], @dm.storages.sort
    comment_fields = [["body", DataMapper::Types::Text, {}],
                      ["id", Integer, {}],
                      ["title", String, {}],
                      ["user_id", Integer, {}]]

    assert_equal comment_fields, @dm.fields('dmm_test_comments').sort

    Comment.create(:title => 'XD')
    assert_equal 1, Comment.first.id
    assert_equal 'XD', Comment.first.title

    #

    Tmp.send :include, DataMapper::Resource
    @dm = DataMapper.setup :default, 'sqlite3:tmp.db'
    assert_equal ['dmm_test_comments', 'dmm_test_users'], @dm.storages.sort

    Tmp.storage_names[:default] = 'dmm_test_comments'
    assert_equal 'dmm_test_comments', Tmp.storage_name

    assert_equal 1, Tmp.count
    assert_equal comment_fields, Tmp.fields.sort

    Tmp.mapping
    assert_equal 'XD', Tmp.first.title
    assert_equal 1, Tmp.first.id
  end
end
