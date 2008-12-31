
module DataMapper
  module Model
    # it simply calls Migration#fields(self.storage_name)
    #  e.g.
    #       DataMapper.repository.adapter.fields storage_name
    def fields repo = default_repository_name
      DataMapper.repository(repo).adapter.fields(storage_name(repo))
    end

    protected
    # it automaticly creates mappings from storage fields to properties.
    # i.e. you don't have to specify any property if you are connecting
    # to an existing database.
    # you can pass it Regexp to map any field it matched, or just
    # the field name in Symbol or String, or a Class telling it
    # map any field which type equals to the Class.
    # returned value is an array of properties indicating fields it mapped
    #  e.g.
    #       class User
    #         include DataMapper::Resource
    #         # mapping all
    #         mapping /.*/  # e.g. => [#<Property:#<Class:0x18f89b8>:id>,
    #                       #          #<Property:#<Class:0x18f89b8>:title>,
    #                       #          #<Property:#<Class:0x18f89b8>:body>,
    #                       #          #<Property:#<Class:0x18f89b8>:user_id>]
    #
    #         # mapping all (with no argument at all)
    #         mapping
    #
    #         # mapping for field name ended with _at, and started with salt_
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
      targets << /.*/ if targets.empty?

      fields.map{ |field|
        name, type, attrs = field

        mapped = targets.each{ |target|
          case target
            when Regexp;
              break name if name.to_s =~ target

            when Symbol, String;
              break name if name == target.to_sym

            when Class;
              break name if type == target

            else
              raise ArgumentError.new("invalid argument: #{target.inspect}")
          end
        }

        property mapped, type, attrs if mapped.kind_of?(Symbol)
      }.compact
    end
  end
end
