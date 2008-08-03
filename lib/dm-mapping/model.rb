
require 'dm-mapping'

module DataMapper
  module Model
    def mapping target = Mapping::All
      DataMapper.ensure_required_dm_mapping_adapter

      if target.kind_of?(Regexp)
        mapping_regexp target
      else
        mapping_type target
      end
    end

    # returing all fields, with format [[name, type, attrs]]
    def fields
      DataMapper.ensure_required_dm_mapping_adapter
      DataMapper.repository.adapter.fields storage_name
    end

    # convient way to map through fields
    def map_fields
      fields.map{ |field|
        yield(*field)
      }
    end

    protected
    def mapping_regexp regexp
      map_fields{ |name, type| #, attrs|
        # property name.to_sym, type, attrs if name =~ regexp
        property name.to_sym, type if name =~ regexp
      }
    end

    def mapping_type type_target
      map_fields{ |name, type| #, attrs|
        # property name.to_sym, type, attrs if name == type_target
        property name.to_sym, type if name == type_target
      }
    end

  end
end
