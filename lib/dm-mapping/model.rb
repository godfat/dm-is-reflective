
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
    # it automaticly creates mappings from storage fields to properties.
    # i.e. you don't have to specify any property if you are connecting
    # to an existing database.
    # you can pass it Regexp to map any field it matched, or just
    # the field name in Symbol or String, or a Class telling it
    # map any field which type equals to the Class.
    #  e.g.
    #       class User
    #         include DataMapper::Resource
    #         # maping all
    #         mapping /.*/
    #
    #         # mapping for ended with _at, and started with salt_
    #         mapping /_at$/, /^salt_/
    #
    #         # mapping id and email
    #         mapping :id, :email
    #
    #         # mapping all fields with type String, and id
    #         mapping String, :id
    #
    #         # mapping login, and all fields with type Integer
    #         mapping :login, Integer
    #       end
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
