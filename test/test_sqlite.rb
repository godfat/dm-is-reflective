
require 'dm-is-reflective/test'
require_adapter 'sqlite'

describe 'sqlite' do
  def setup_data_mapper
    DataMapper.setup(:default, :adapter => 'sqlite', :database => ':memory:')
  end

  def user_fields
    @user_fields ||=
    [[:created_at, DateTime, AttrCommon],
     [:id,         DataMapper::Property::Serial, AttrCommonPK],
     [:login,      String,   {:length => 70}.merge(AttrCommon)],
     [:sig,        DataMapper::Property::Text, AttrText]]
  end

  def comment_fields
    @comment_fields ||=
    [[:body,    DataMapper::Property::Text,    AttrText],
     [:id,      DataMapper::Property::Serial, AttrCommonPK],
     [:title,   String,   {:length => 50, :default => 'default title',
                           :allow_nil => false}],
     [:user_id, Integer,
        {:index => :index_abstract_comments_user}.merge(AttrCommon)]]
  end

  # there's differences between adapters
  def super_user_fields
    @super_user_fields ||=
    [[:bool, DataMapper::Property::Boolean, AttrCommon],
     [:id,   DataMapper::Property::Serial, AttrCommonPK]]
  end

  behaves_like :reflective
end if defined?(DataMapper::Adapters::SqliteAdapter)
