
gem 'dm-core', '>=0.9.3'
require 'dm-core'

require 'extlib/hook'
require 'extlib/inflection'

module DataMapper
  include Extlib::Hook
  after_class_method :setup do
    adapter_name = repository.adapter.class.to_s.split('::').last
    require "dm-mapping/adapters/#{Extlib::Inflection.underscore(adapter_name)}"
  end

  # default scope for Migration#auto_genclasses! series.
  module Mapping # namespace
  end

end

require 'dm-mapping/model'
