
require 'dm-is-reflective/test'
require_adapter 'sqlite'

describe 'sqlite' do
  def setup_data_mapper
    DataMapper.setup(:default, :adapter => 'sqlite', :database => ':memory:')
  end

  behaves_like :reflective
end if defined?(DataMapper::Adapters::SqliteAdapter)
