
gem 'dm-core', '=0.9.3'
require 'dm-core'

module DataMapper

  # default scope for Migration#auto_genclasses! series.
  module Mapping # namespace
  end

  class << self
    # ensure the using adapter is extended by dm-mapping
    def ensure_required_dm_mapping_adapter
      require 'extlib'
      adapter_name = repository.adapter.class.to_s.split('::').last
      require "dm-mapping/adapters/#{Extlib::Inflection.underscore(adapter_name)}"
    end

    # dirty hack that hook requirement after setup.
    alias_method :__setup_alias_by_dm_mapping__, :setup
    private :__setup_alias_by_dm_mapping__
    # dirty hack that hook requirement after setup.
    # usage is the same as original setup.
    def setup name, uri_or_options
      adapter = __setup_alias_by_dm_mapping__ name, uri_or_options
      ensure_required_dm_mapping_adapter
      adapter
    end
  end

end

require 'dm-mapping/model'
