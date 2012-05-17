
require 'dm-core'
require 'dm-migrations'
require 'dm-is-reflective'

module Abstract
  def self.next_id
    @id ||= 0
    @id += 1
  end

  AttrCommon   = {:allow_nil => true}
  AttrCommonPK = {:serial => true, :key => true, :allow_nil => false}
  AttrText     = {:length => 65535}.merge(AttrCommon)

  def user_fields
    [[:created_at, DateTime, AttrCommon],
     [:id,         DataMapper::Property::Serial,  AttrCommonPK],
     [:login,      String,   {:length => 70}.merge(AttrCommon)],
     [:sig,        DataMapper::Property::Text, AttrText]]
  end

  def comment_fields
    [[:body,    DataMapper::Property::Text,    AttrText],
     [:id,      DataMapper::Property::Serial,  AttrCommonPK],
     [:title,   String,   {:length => 50, :default => 'default title',
                           :allow_nil => false}],
     [:user_id, Integer,  AttrCommon]]
  end

  # there's differences between adapters
  def super_user_fields
    Object.const_set(:MysqlTest, Class.new) unless defined?(MysqlTest) # dummy
    case self
      when MysqlTest # Mysql couldn't tell it's boolean or tinyint
        [[:bool, Integer, AttrCommon],
         [:id,   DataMapper::Property::Serial, AttrCommonPK]]

      else
        [[:bool, DataMapper::Property::Boolean, AttrCommon],
         [:id,   DataMapper::Property::Serial,  AttrCommonPK]]

    end
  end

  class User
    include DataMapper::Resource
    has n, :comments

    property :id,         Serial
    property :login,      String, :length => 70
    property :sig,        Text
    property :created_at, DateTime

    is :reflective
  end

  class SuperUser
    include DataMapper::Resource
    property :id, Serial
    property :bool, Boolean

    is :reflective
  end

  class Comment
    include DataMapper::Resource
    belongs_to :user, :required => false

    property :id,    Serial
    property :title, String,  :length => 50, :default => 'default title',
                              :allow_nil => false
    property :body,  Text

    is :reflective
  end

  Tables = ['abstract_comments', 'abstract_super_users', 'abstract_users']

  def sort_fields fields
    fields.sort_by{ |field|
      field.first.to_s
    }
  end

  def create_fake_model
    model = Class.new
    model.module_eval do
      include DataMapper::Resource
      property :id, DataMapper::Property::Serial
      is :reflective
    end
    Abstract.const_set("Model#{Abstract.next_id}", model)
    [model, self.class.setup_data_mapper]
  end

  attr_reader :dm
  def setup
    @dm = self.class.setup_data_mapper
    # this is significant faster than DataMapper.auto_migrate!
    User.auto_migrate!
    Comment.auto_migrate!
    SuperUser.auto_migrate!
  end

  def new_scope
    self.class.const_set("Scope#{object_id.object_id}", Module.new)
  end

  def test_storages
    assert_equal Tables, dm.storages.sort
    assert_equal comment_fields, sort_fields(dm.fields('abstract_comments'))
  end

  def test_create_comment
    Comment.create(:title => 'XD')
    assert_equal 'XD', Comment.first.title
  end

  def test_create_user
    now = Time.now
    User.create(:created_at => now)
    assert_equal now.asctime, User.first.created_at.asctime

    return now
  end

  def test_reflect_all
    test_create_comment # for fixtures
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'

    assert_equal Tables, local_dm.storages.sort
    assert_equal 'abstract_comments', model.storage_name

    model.send :reflect
    assert_equal 1, model.all.size
    assert_equal comment_fields, sort_fields(model.fields)

    assert_equal 'XD', model.first.title
  end

  def test_reflect_and_create
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'
    model.send :reflect

    model.create(:title => 'orz')
    assert_equal 'orz', model.first.title

    model.create
    assert_equal 'default title', model.last.title
  end

  def test_storages_and_fields
    assert_equal user_fields, sort_fields(dm.fields('abstract_users'))
    assert_equal( {'abstract_users' => user_fields,
                   'abstract_comments' => comment_fields,
                   'abstract_super_users' => super_user_fields},
                  dm.storages_and_fields.inject({}){ |r, i|
                    key, value = i
                    r[key] = value.sort_by{ |v| v.first.to_s }
                    r
                  } )
  end

  def test_reflect_type
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'

    model.send :reflect, DataMapper::Property::Serial
    assert_equal ['id'], model.properties.map(&:name).map(&:to_s).sort

    model.send :reflect, Integer
    assert_equal ['id', 'user_id'], model.properties.map(&:name).map(&:to_s).sort
  end

  def test_reflect_multiple
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_users'
    model.send :reflect, :login, DataMapper::Property::Serial

    assert_equal ['id', 'login'], model.properties.map(&:name).map(&:to_s).sort
  end

  def test_reflect_regexp
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'
    model.send :reflect, /id$/

    assert_equal ['id', 'user_id'], model.properties.map(&:name).map(&:to_s).sort
  end

  def test_invalid_argument
    assert_raises(ArgumentError){
      User.send :reflect, 29
    }
  end

  def test_allow_empty_string
    assert Comment.new(:title => '').save
  end

  def test_auto_genclasses
    scope = new_scope
    assert_equal ["#{scope == Object ? '' : "#{scope}::"}AbstractComment",
                  "#{scope}::AbstractSuperUser",
                  "#{scope}::AbstractUser"],
                 dm.auto_genclass!(:scope => scope).map(&:to_s).sort

    comment = scope.const_get('AbstractComment')

    assert_equal comment_fields, sort_fields(comment.fields)

    test_create_comment

    assert_equal 'XD', comment.first.title
    comment.create(:title => 'orz', :body => 'dm-reflect')
    assert_equal 'dm-reflect', comment.last.body
  end

  def test_auto_genclass
    scope = new_scope
    assert_equal ["#{scope}::AbstractUser"],
                 dm.auto_genclass!(:scope => scope,
                                   :storages => 'abstract_users').map(&:to_s)

    user = scope.const_get('AbstractUser')
    assert_equal user_fields, sort_fields(user.fields)

    now = test_create_user

    assert_equal now.asctime, user.first.created_at.asctime
    user.create(:login => 'godfat')
    assert_equal 'godfat', user.last.login
  end

  def test_auto_genclass_with_regexp
    scope = new_scope
    assert_equal ["#{scope}::AbstractSuperUser", "#{scope}::AbstractUser"],
                 dm.auto_genclass!(:scope => scope,
                                   :storages => /_users$/).map(&:to_s).sort

    user = scope.const_get('AbstractSuperUser')
    assert_equal sort_fields(SuperUser.fields), sort_fields(user.fields)
  end

  def test_reflect_return_value
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'
    mapped = model.send :reflect, /.*/

    assert_equal model.properties.map(&:object_id).sort, mapped.map(&:object_id).sort
  end
end
