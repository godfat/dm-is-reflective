
require 'dm-is-reflective/test'
require_adapter 'postgres'

describe 'postgres' do
  if ENV['TRAVIS']
    def setup_data_mapper
      DataMapper.setup(:default, :adapter  => 'postgres'  ,
                                 :username => 'postgres'  ,
                                 :host     => 'localhost' ,
                                 :database => 'myapp_test')
    end
  else
    def setup_data_mapper
      DataMapper.setup(:default, :adapter  => 'postgres'        ,
                                 :username => 'dm_is_reflective',
                                 :password => 'godfat'          ,
                                 :host     => 'localhost'       ,
                                 :database => 'dm_is_reflective')
    end
  end
  behaves_like :reflective
end if defined?(DataMapper::Adapters::PostgresAdapter)
