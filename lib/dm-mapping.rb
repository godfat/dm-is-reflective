
gem 'dm-core', '=0.9.3'
require 'dm-core'

module DataMapper
  module Mapping
    All = /*/
  end
end

module DataMapper
  module Adapters
    class AbstractAdapter
      module Migration
        # returns all tables in the repository.
        # e.g. ['comments', 'posts']
        def storages
          raise NotImplementedError
        end
      end
    end
  end
end

require "dm-mapping/#{DataMapper.repository.adapter.class.to_s.split('::').last.downcase}"
