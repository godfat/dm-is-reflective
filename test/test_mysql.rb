
require 'dm-is-reflective/test'
require_adapter 'mysql'

describe 'mysql' do
  if ENV['TRAVIS']
    def setup_data_mapper
      DataMapper.setup(:default, :adapter  => 'mysql'     ,
                                 :username => 'root'      ,
                                 :host     => 'localhost' ,
                                 :database => 'myapp_test')
    end
  else
    def setup_data_mapper
      DataMapper.setup(:default, :adapter  => 'mysql'           ,
                                 :username => 'dm_is_reflective',
                                 :password => 'godfat'          ,
                                 :host     => 'localhost'       ,
                                 :database => 'dm_is_reflective')
    end
  end

  def user_fields
    @user_fields ||=
    [[:created_at, DateTime, AttrCommon],
     [:id,         DataMapper::Property::Serial,
        {:unique_index => :abstract_users_pkey}.merge(AttrCommonPK)],
     [:login,      String,   {:length => 70}.merge(AttrCommon)],
     [:sig,        DataMapper::Property::Text, AttrText]]
  end

  def comment_fields
    @comment_fields ||=
    [[:body,    DataMapper::Property::Text,    AttrText],
     [:id,      DataMapper::Property::Serial,
        {:unique_index => :abstract_comments_pkey}.merge(AttrCommonPK)],
     [:title,   String,   {:length => 50, :default => 'default title',
                           :allow_nil => false}],
     [:user_id, Integer,
        {:unique_index => :index_abstract_comments_user}.merge(AttrCommon)]]
  end

  # there's differences between adapters
  def super_user_fields
    @super_user_fields ||=
    [[:bool, Integer, AttrCommon],
     [:id,   DataMapper::Property::Serial,
      {:unique_index => :abstract_super_users_pkey}.merge(AttrCommonPK)]]
  end

  behaves_like :reflective
end if defined?(DataMapper::Adapters::MysqlAdapter)
