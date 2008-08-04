
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


  # override it to test with another adapter
  # NOTE:
  #   please provide an clean database because it is a destructive test!!
  def setup_data_mapper
    DataMapper.setup(:default, 'sqlite3:tmp.db')
  end


  class Model; end

  def create_fake_model
    [ Model.dup.__send__(:include, DataMapper::Resource),
      setup_data_mapper ]
  end

  attr_reader :dm
  def setup
    @dm = setup_data_mapper
    # this is significant faster than DataMapper.auto_migrate!
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
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'dmm_test_comments'

    assert_equal ['dmm_test_comments', 'dmm_test_users'], local_dm.storages.sort
    assert_equal 'dmm_test_comments', model.storage_name

    assert_equal 1, model.count
    assert_equal comment_fields, model.fields.sort

    model.send :mapping
    assert_equal 'XD', model.first.title
    assert_equal 1, model.first.id
  end

  def test_mapping_and_create
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'dmm_test_comments'
    model.send :mapping

    model.create(:title => 'orz')
    assert_equal 'orz', model.first.title
    assert_equal 1, model.first.id

    model.create
    assert_equal 'default title', model.get(2).title
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

  def test_mapping_type
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'dmm_test_comments'
    model.send :mapping, Integer

    assert_equal ['id', 'user_id'], model.properties.map(&:name).map(&:to_s).sort
  end

  def test_mapping_multiple
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'dmm_test_users'
    model.send :mapping, :login, Integer

    assert_equal ['id', 'login'], model.properties.map(&:name).map(&:to_s).sort
  end

  def test_mapping_regexp
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'dmm_test_comments'
    model.send :mapping, /id$/

    assert_equal ['id', 'user_id'], model.properties.map(&:name).map(&:to_s).sort
  end

  def test_invalid_argument
    assert_raise(ArgumentError){
      User.send :mapping, 29
    }
  end

  def test_auto_genclass
    for_test_auto_genclass
    for_test_auto_genclass Object
  end

  def for_test_auto_genclass scope = DataMapper::Mapping
    assert_equal ["#{scope == Object ? '' : "#{scope}::"}DmmTestComment",
                  "#{scope == Object ? '' : "#{scope}::"}DmmTestUser"],
                 dm.auto_genclass!(scope).map(&:to_s).sort

    comment = scope.const_get('DmmTestComment')

    assert_equal comment_fields, comment.fields.sort

    test_create_comment

    assert_equal 'XD', comment.first.title
    comment.create(:title => 'orz', :body => 'dm-mapping')
    assert_equal 'dm-mapping', comment.get(2).body
  end

end
