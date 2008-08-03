
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

      map_fields{ |name, type, attrs|
        targets.each{ |target|
          case target
            when Regexp;
              property name.to_sym, type, attrs if name =~ target

            when Symbol, String;
              property name.to_sym, type, attrs if name == target.to_s

            when Class;
              property name.to_sym, type, attrs if type == target

            else
              raise ArgumentError.new("invalid argument: #{target.inspect}")
          end
        }
      }
    end
  end
end
