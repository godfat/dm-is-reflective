
gem 'dm-core', '>=1.0.0'
require 'dm-core'

require 'dm-is-reflective/is/reflective'
DataMapper::Model.append_extensions(DataMapper::Is::Reflective)

require 'dm-is-reflective/is/adapters/abstract_adapter'
DataMapper::Adapters::AbstractAdapter.__send__(:include,
  DataMapper::Is::Reflective::AbstractAdapter)
