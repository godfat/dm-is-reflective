
require 'dm-is-reflective/test'
require_adapter 'mysql'

describe 'mysql' do
  if ENV['TRAVIS']
    def setup_data_mapper
      DataMapper.setup(:default, 'mysql://root@localhost/myapp_test')
    end
  else
    def setup_data_mapper
      DataMapper.setup(:default,
        'mysql://dm_is_reflective:godfat@localhost/dm_is_reflective')
    end
  end
  behaves_like :reflective
end if defined?(DataMapper::Adapters::MysqlAdapter)
