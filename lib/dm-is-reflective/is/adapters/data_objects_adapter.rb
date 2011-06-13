
module DataMapper
  module Is::Reflective
    module DataObjectsAdapter
      include DataMapper

      # returns all tables' name in the repository.
      #  e.g.
      #       ['comments', 'users']
      def storages
        reflective_auto_load_adapter_extension
        storages # call the overrided method
      end

      # returns all fields, with format [[name, type, attrs]]
      #  e.g.
      #       [[:created_at,  DateTime, {:required => false}],
      #        [:email,       String,   {:required => false, :size => 255,
      #                                  :default => 'nospam@nospam.tw'}],
      #        [:id, DataMapper::Property::Serial,  {:required => true, :serial => true,
      #                                  :key => true}],
      #        [:salt_first,  String,   {:required => false, :size => 50}],
      #        [:salt_second, String,   {:required => false, :size => 50}]]
      def fields storage
        reflective_query_storage(storage).map{ |field|
          primitive = reflective_primitive(field)

          type = self.class.type_map.sort{ |(k1, v1), (k2, v2)|
                   # search from the most derived class
                   if    k1 < k2 || k2 == Class then -1
                   elsif k1 > k2 || k1 == Class then  1
                   else                               0
                   end
                 }.find{ |(klass, attrs)|
                   next false if [Object, Class, Time].include?(klass)
                   attrs[:primitive] == primitive
                 }
          type = type ? type.first : reflective_lookup_primitive(primitive)

          attrs = reflective_attributes(field)

          type = if attrs[:serial] && type == Integer
                   Property::Serial

                 elsif type == TrueClass
                   Property::Boolean

                 else
                    type
                 end

          [reflective_field_name(field).to_sym, type, attrs]
        }
      end

      # returns a hash with storage names in keys and
      # corresponded fields in values. e.g.
      #   {'users' => [[:id,          Integer,  {:required => true,
      #                                          :serial => true,
      #                                          :key => true}],
      #                [:email,       String,   {:required => false,
      #                                          :default => 'nospam@nospam.tw'}],
      #                [:created_at,  DateTime, {:required => false}],
      #                [:salt_first,  String,   {:required => false, :size => 50}],
      #                [:salt_second, String,   {:required => false, :size => 50}]]}
      # see AbstractAdapter#storages and AbstractAdapter#fields for detail
      def storages_and_fields
        storages.inject({}){ |result, storage|
          result[storage] = fields(storage)
          result
        }
      end

      # automaticly generate model class(es) and reflect
      # all fields with reflect /.*/ for you.
      #  e.g.
      #       dm.auto_genclass!
      #       # => [DataMapper::Is::Reflective::User,
      #       #     DataMapper::Is::Reflective::SchemaInfo,
      #       #     DataMapper::Is::Reflective::Session]
      #
      # you can change the scope of generated models:
      #  e.g.
      #       dm.auto_genclass! :scope => Object
      #       # => [User, SchemaInfo, Session]
      #
      # you can generate classes for tables you specified only:
      #  e.g.
      #       dm.auto_genclass! :scope => Object, :storages => /^phpbb_/
      #       # => [PhpbbUser, PhpbbPost, PhpbbConfig]
      #
      # you can generate classes with String too:
      #  e.g.
      #       dm.auto_genclass! :storages => ['users', 'config'], :scope => Object
      #       # => [User, Config]
      #
      # you can generate a class only:
      #  e.g.
      #       dm.auto_genclass! :storages => 'users'
      #       # => [DataMapper::Is::Reflective::User]
      def auto_genclass! opts = {}
        opts[:scope] ||= Is::Reflective
        opts[:storages] ||= /.*/
        opts[:storages] = [opts[:storages]].flatten

        storages.map{ |storage|

          mapped = opts[:storages].each{ |target|
            case target
              when Regexp;
                break storage if storage =~ target

              when Symbol, String;
                break storage if storage == target.to_s

              else
                raise ArgumentError.new("invalid argument: #{target.inspect}")
            end
          }

          reflective_genclass(mapped, opts[:scope]) if mapped.kind_of?(String)
        }.compact
      end

      private
      def reflective_query_storage storage
        reflective_auto_load_adapter_extension
        reflective_query_storage(storage) # call the overrided method
      end

      def reflective_genclass storage, scope
        model = Class.new
        model.__send__(:include, Resource)
        model.is(:reflective)
        model.storage_names[:default] = storage
        model.__send__(:reflect, /.*/)
        scope.const_set(Inflector.classify(storage), model)
      end

      def reflective_lookup_primitive primitive
        raise TypeError.new("#{primitive} not found for #{self.class}")
      end

      def reflective_auto_load_adapter_extension
        require "dm-is-reflective/is/adapters/#{options['scheme']}_adapter"
        class_name = "#{Inflector.camelize(options['scheme'])}Adapter"
        Adapters.const_get(class_name).__send__(:include,
          Is::Reflective.const_get(class_name))
      end
    end
  end
end
