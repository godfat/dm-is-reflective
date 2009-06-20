
gem 'dm-core', '>=0.10.0'
require 'dm-core'

require 'extlib/hook'
require 'extlib/inflection'

module DataMapper
  include Extlib::Hook
  after_class_method :setup do
    adapter_name = repository.adapter.class.to_s.split('::').last
    require "dm-is-reflexible/is/adapters/#{Extlib::Inflection.underscore(adapter_name)}"
  end

end

require 'dm-is-reflexible/is/reflexible'
DataMapper::Model.append_extensions DataMapper::Is::Reflexible
