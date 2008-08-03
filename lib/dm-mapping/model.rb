
module DataMapper
  module Model
    # returing all fields, with format [[name, type, attrs]]
    def fields
      DataMapper.ensure_required_dm_mapping_adapter
      DataMapper.repository.adapter.fields storage_name
    end

    protected
    def mapping *targets
      DataMapper.ensure_required_dm_mapping_adapter
      targets << /.*/ if targets.empty?

      fields.map{ |field|
        name, type, attrs = field

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
