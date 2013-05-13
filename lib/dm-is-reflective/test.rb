
require 'bacon'
Bacon.summary_on_exit

require 'dm-core'
require 'dm-migrations'
require 'dm-is-reflective'

module Abstract
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

  AttrCommon   = {:allow_nil => true}
  AttrCommonPK = {:serial => true, :key => true, :allow_nil => false}
  AttrText     = {:length => 65535}.merge(AttrCommon)

  def self.next_id
    @id ||= 0
    @id += 1
  end
end

include Abstract

shared :reflective do
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
    mysql = defined?(DataMapper::Adapters::MysqlAdapter) &&
                     DataMapper::Adapters::MysqlAdapter
    case DataMapper.repository.adapter
    when mysql
      # Mysql couldn't tell it's boolean or tinyint
      [[:bool, Integer, AttrCommon],
       [:id,   DataMapper::Property::Serial, AttrCommonPK]]

    else
      [[:bool, DataMapper::Property::Boolean, AttrCommon],
       [:id,   DataMapper::Property::Serial,  AttrCommonPK]]
    end
  end

  before do
    @dm = setup_data_mapper
    [User, Comment, SuperUser].each(&:auto_migrate!)
  end

  def sort_fields fields
    fields.sort_by{ |f| f.first.to_s }
  end

  def create_fake_model
    model = Class.new
    model.module_eval do
      include DataMapper::Resource
      property :id, DataMapper::Property::Serial
      is :reflective
    end
    Abstract.const_set("Model#{Abstract.next_id}", model)
    [model, setup_data_mapper]
  end

  def new_scope
    Abstract.const_set("Scope#{Abstract.next_id}", Module.new)
  end

  def test_create_comment
    Comment.create(:title => 'XD')
    Comment.first.title.should.eq 'XD'
  end

  def test_create_user
    now = Time.now
    User.create(:created_at => now)
    User.first.created_at.asctime.should.eq now.asctime
    now
  end

  should 'create comment' do
    test_create_comment
  end

  should 'create user' do
    test_create_user
  end

  should 'storages' do
    @dm.storages.sort.should.eq Tables
    sort_fields(@dm.fields('abstract_comments')).should.eq comment_fields
  end

  should 'reflect all' do
    test_create_comment # for fixtures
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'

    local_dm.storages.sort.should.eq Tables
    model.storage_name.should.eq 'abstract_comments'

    model.send :reflect
    model.all.size           .should.eq 1
    sort_fields(model.fields).should.eq comment_fields
    model.first.title        .should.eq 'XD'
  end

  should 'reflect and create' do
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'
    model.send :reflect

    model.create(:title => 'orz')
    model.first.title.should.eq 'orz'

    model.create
    model.last.title.should.eq 'default title'
  end

  should 'storages and fields' do
    sort_fields(@dm.fields('abstract_users')).should.eq user_fields

    @dm.storages_and_fields.inject({}){ |r, i|
      key, value = i
      r[key] = value.sort_by{ |v| v.first.to_s }
      r
    }.should.eq('abstract_users'       => user_fields      ,
                'abstract_comments'    => comment_fields   ,
                'abstract_super_users' => super_user_fields)
  end

  should 'reflect type' do
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'

    model.send :reflect, DataMapper::Property::Serial
    model.properties.map(&:name).map(&:to_s).sort.should.eq ['id']

    model.send :reflect, Integer
    model.properties.map(&:name).map(&:to_s).sort.should.eq \
      ['id', 'user_id']
  end

  should 'reflect multiple' do
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_users'
    model.send :reflect, :login, DataMapper::Property::Serial

    model.properties.map(&:name).map(&:to_s).sort.should.eq \
      ['id', 'login']
  end

  should 'reflect regexp' do
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'
    model.send :reflect, /id$/

    model.properties.map(&:name).map(&:to_s).sort.should.eq \
      ['id', 'user_id']
  end

  should 'raise ArgumentError when giving invalid argument' do
    lambda{
      User.send :reflect, 29
    }.should.raise ArgumentError
  end

  should 'allow empty string' do
    Comment.new(:title => '').save.should.eq true
  end

  should 'auto_genclasses' do
    scope = new_scope
    @dm.auto_genclass!(:scope => scope).map(&:to_s).sort.should.eq \
      ["#{scope}::AbstractComment",
       "#{scope}::AbstractSuperUser",
       "#{scope}::AbstractUser"]

    comment = scope.const_get('AbstractComment')

    sort_fields(comment.fields).should.eq comment_fields

    test_create_comment

    comment.first.title.should.eq 'XD'
    comment.create(:title => 'orz', :body => 'dm-reflect')
    comment.last.body.should.eq 'dm-reflect'
  end

  should 'auto_genclass' do
    scope = new_scope
    @dm.auto_genclass!(:scope => scope,
                       :storages => 'abstract_users').map(&:to_s).should.eq \
      ["#{scope}::AbstractUser"]

    user = scope.const_get('AbstractUser')
    sort_fields(user.fields).should.eq user_fields

    now = test_create_user

    user.first.created_at.asctime.should.eq now.asctime
    user.create(:login => 'godfat')
    user.last.login.should.eq 'godfat'
  end

  should 'auto_genclass with regexp' do
    scope = new_scope
    @dm.auto_genclass!(:scope => scope,
                       :storages => /_users$/).map(&:to_s).sort.should.eq \
      ["#{scope}::AbstractSuperUser", "#{scope}::AbstractUser"]

    user = scope.const_get('AbstractSuperUser')
    sort_fields(user.fields).should.eq sort_fields(SuperUser.fields)
  end

  should 'reflect return value' do
    model, local_dm = create_fake_model
    model.storage_names[:default] = 'abstract_comments'
    mapped = model.send :reflect, /.*/

    mapped.map(&:object_id).sort.should.eq \
      model.properties.map(&:object_id).sort
  end
end

module Kernel
  def eq? rhs
    self == rhs
  end

  def require_adapter adapter
    require "dm-#{adapter}-adapter"
  rescue LoadError
    puts "skip #{adapter} test since it's not installed"
  end
end
