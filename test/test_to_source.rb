
require 'dm-is-reflective/test'

describe 'DataMapper::Resource#to_source' do
  DataMapper.setup(:default, :adapter => 'in_memory')
  Comment.create # enforce Comment#user_id generated

  should 'match Abstract::User' do
    Abstract::User.to_source.should.eq <<-RUBY
class ::Abstract::User < Object
  include DataMapper::Resource
  property :id, DataMapper::Property::Serial, {:primitive=>Integer, :min=>1, :serial=>true}
property :login, DataMapper::Property::String, {:primitive=>String, :length=>70}
property :sig, DataMapper::Property::Text, {:primitive=>String, :lazy=>true, :length=>65535}
property :created_at, DataMapper::Property::DateTime, {:primitive=>DateTime}
end
    RUBY
  end

  should 'match Abstract::Comment' do
    Abstract::Comment.to_source.should.eq <<-RUBY
class ::Abstract::Comment < Object
  include DataMapper::Resource
  property :id, DataMapper::Property::Serial, {:primitive=>Integer, :min=>1, :serial=>true}
property :title, DataMapper::Property::String, {:primitive=>String, :length=>50, :default=>"default title", :allow_nil=>false}
property :body, DataMapper::Property::Text, {:primitive=>String, :lazy=>true, :length=>65535}
property :user_id, DataMapper::Property::Integer, {:primitive=>Integer, :index=>:user, :required=>false, :key=>false, :unique=>false, :min=>1, :max=>2147483647}
end
    RUBY
  end

  should 'match Abstract::Comment::Abstract::Comment' do
    Abstract::Comment.to_source(Abstract::Comment).should.eq <<-RUBY
class Abstract::Comment::Abstract::Comment < Object
  include DataMapper::Resource
  property :id, DataMapper::Property::Serial, {:primitive=>Integer, :min=>1, :serial=>true}
property :title, DataMapper::Property::String, {:primitive=>String, :length=>50, :default=>"default title", :allow_nil=>false}
property :body, DataMapper::Property::Text, {:primitive=>String, :lazy=>true, :length=>65535}
property :user_id, DataMapper::Property::Integer, {:primitive=>Integer, :index=>:user, :required=>false, :key=>false, :unique=>false, :min=>1, :max=>2147483647}
end
    RUBY
  end

  should 'match Abstract::Comment::Abstract::User' do
    Abstract::User.to_source('Abstract::Comment').should.eq <<-RUBY
class Abstract::Comment::Abstract::User < Object
  include DataMapper::Resource
  property :id, DataMapper::Property::Serial, {:primitive=>Integer, :min=>1, :serial=>true}
property :login, DataMapper::Property::String, {:primitive=>String, :length=>70}
property :sig, DataMapper::Property::Text, {:primitive=>String, :lazy=>true, :length=>65535}
property :created_at, DataMapper::Property::DateTime, {:primitive=>DateTime}
end
    RUBY
  end
end
