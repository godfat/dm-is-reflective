
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
      end
    end
  end
end
