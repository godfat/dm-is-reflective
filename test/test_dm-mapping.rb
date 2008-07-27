
require 'test/unit'

require 'rubygems'
require 'dm-core'

class DMMTest < Test::Unit::TestCase
  class Post
    include DataMapper::Resource
    has n, :comments

    property :id,         Integer, :serial => true
    property :title,      String
    property :body,       Text
    property :created_at, DateTime
  end

  class Comment
    include DataMapper::Resource
    belongs_to :post

    property :id,         Integer, :serial => true

    property :posted_by,  String
    property :email,      String
    property :url,        String
    property :body,       Text
  end

  def setup
    @dm = DataMapper.setup :default, 'sqlite3://memory'
    require 'dm-mapping'
    DataMapper.auto_migrate!
  end

  def test_storages
    assert_equal ['dmm_test_comments', 'dmm_test_posts'], @dm.storages.sort
  end
end
