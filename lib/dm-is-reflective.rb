
require 'dm-core'
require 'dm-do-adapter'

require 'dm-is-reflective/reflective'
require 'dm-is-reflective/adapters/data_objects_adapter'

DataMapper::Model.append_extensions(DmIsReflective)

DataMapper::Adapters::DataObjectsAdapter.__send__(:include,
  DmIsReflective::DataObjectsAdapter)
