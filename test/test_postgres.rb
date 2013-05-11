
require 'dm-is-reflective/test'
require_adapter 'postgres'

describe 'postgres' do
  if ENV['TRAVIS']
    def setup_data_mapper
      DataMapper.setup(:default, 'postgres://postgres@localhost/myapp_test')
    end
  else
    def setup_data_mapper
      DataMapper.setup(:default,
        'postgres://dm_is_reflective:godfat@localhost/dm_is_reflective')
    end
  end
  behaves_like :reflective
end if defined?(DataMapper::Adapters::PostgresAdapter)
