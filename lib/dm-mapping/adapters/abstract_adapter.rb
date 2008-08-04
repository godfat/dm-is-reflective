
module DataMapper
  module Adapters
    class AbstractAdapter
      module Migration
        # returns all tables in the repository.
        # e.g. ['comments', 'posts']
        def storages
          raise NotImplementedError
        end

        def fields storage
          raise NotImplementedError
        end

        def storages_and_fields
          storages.inject({}){ |result, storage|
            result[storage] = fields(storage)
            result
          }
        end

        def auto_genclass scope = DataMapper::Mapping
          require 'extlib'
          storages_and_fields.map{ |storage, fields|
            model = Class.new
            model.__send__ :include, DataMapper::Resource
            model.storage_names[:default] = storage
            model.__send__ :mapping, /.*/
            scope.const_set(Extlib::Inflection.classify(storage), model)
          }
        end
      end
    end
  end
end
