
require 'dm-mapping'

module DataMapper
  module Model
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
    def mapping *targets
      DataMapper.ensure_required_dm_mapping_adapter
      targets << Mapping::All if targets.empty?

      targets.each{ |target|
        case target
          when Regexp;
            mapping_regexp target

          when Symbol, String;
            mapping_symbol target.to_sym

          when Class;
            mapping_class target

          else
            raise ArgumentError.new("invalid argument: #{target.inspect}")
        end
      }
    end

    private
    def mapping_regexp regexp
      map_fields{ |name, type, attrs|
        property name.to_sym, type, attrs if name =~ regexp
      }
    end

    def mapping_symbol symbol
      map_fields{ |name, type, attrs|
        if name.to_sym == symbol
          property symbol, type, attrs
          break
        end
      }
    end

    def mapping_class klass
      map_fields{ |name, type, attrs|
        property name.to_sym, type, attrs if type == klass
      }
    end

  end
end
