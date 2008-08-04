
module DataMapper
  module Model
    # it simply calls Migration#fields(self.storage_name)
    #  e.g.
    #       DataMapper.repository.adapter.fields storage_name
    def fields
      DataMapper.ensure_required_dm_mapping_adapter
      DataMapper.repository.adapter.fields storage_name
    end

    protected
    # missing doc
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
