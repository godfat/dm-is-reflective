
module DataMapper
module Is
module Reflective

  def is_reflective
    extend ClassMethod
  end

  module ClassMethod
    # it simply calls Migration#fields(self.storage_name)
    #  e.g.
    #       DataMapper.repository.adapter.fields storage_name
    def fields repo = default_repository_name
      DataMapper.repository(repo).adapter.fields(storage_name(repo))
    end

    # it automatically creates reflection from storage fields to properties.
    # i.e. you don't have to specify any property if you are connecting
    # to an existing database.
    # you can pass it Regexp to map any field it matched, or just
    # the field name in Symbol or String, or a Class telling it
    # map any field which type equals to the Class.
    # returned value is an array of properties indicating fields it mapped
    #  e.g.
    #       class User
    #         include DataMapper::Resource
    #         # reflect all
    #         reflect /.*/  # e.g. => [#<Property:#<Class:0x18f89b8>:id>,
    #                       #          #<Property:#<Class:0x18f89b8>:title>,
    #                       #          #<Property:#<Class:0x18f89b8>:body>,
    #                       #          #<Property:#<Class:0x18f89b8>:user_id>]
    #
    #         # reflect all (with no argument at all)
    #         reflect
    #
    #         # reflect for field name ended with _at, and started with salt_
    #         reflect /_at$/, /^salt_/
    #
    #         # reflect id and email
    #         reflect :id, :email
    #
    #         # reflect all fields with type String, and id
    #         reflect String, :id
    #
    #         # reflect login, and all fields with type Integer
    #         reflect :login, Integer
    #       end
    def reflect *targets
      targets << /.*/ if targets.empty?

      result = fields.map{ |field|
        name, type, attrs = field

        reflected = targets.each{ |target|
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

        property(reflected, type, attrs) if reflected.kind_of?(Symbol)
      }.compact

      finalize if respond_to?(:finalize)
      result
    end

    def to_source scope=nil
<<-RUBY
class #{scope}::#{name} < #{superclass}
  include DataMapper::Resource
  #{
    properties.map do |prop|
      "property :#{prop.name}, #{prop.class.name}, #{prop.options}"
    end.join("\n")
  }
end
RUBY
    end
  end # of ClassMethod

end # of Reflective
end # of Is
end # of DataMapper
