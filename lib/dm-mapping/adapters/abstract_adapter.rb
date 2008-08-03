
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
      end
    end
  end
end
