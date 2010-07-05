
gem 'dm-core', '>=1.0.0'
require 'dm-core'
require 'dm-do-adapter'

require 'dm-is-reflective/is/reflective'
require 'dm-is-reflective/is/adapters/data_objects_adapter'

DataMapper::Model.append_extensions(DataMapper::Is::Reflective)

DataMapper::Adapters::DataObjectsAdapter.__send__(:include,
  DataMapper::Is::Reflective::DataObjectsAdapter)
