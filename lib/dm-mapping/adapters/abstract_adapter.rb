
module DataMapper
  module Adapters
    class AbstractAdapter
      module Migration
        # returns all tables' name in the repository.
        #  e.g.
        #       ['comments', 'users']
        def storages
          raise NotImplementedError
        end

        # returns all fields, with format [[name, type, attrs]]
        #  e.g.
        #       [['created_at',  DateTime, {}],
        #        ['email',       String,   {:default => 'nospam@nospam.tw'}],
        #        ['id',          Integer,  {:serial => true}],
        #        ['salt_first',  String,   {}],
        #        ['salt_second', String,   {}]]
        def fields storage
          dmm_query_storage(storage).map{ |field|
            type, chain = self.class.type_map.
              lookup_primitive(dmm_primitive(field))

            [dmm_field_name(field), type, dmm_attributes(field)]
          }
        end

        # returns a hash with storage names in keys and
        # corresponded fields in values. e.g.
        #   {'users' => [['id',          Integer,  {:serial => true}],
        #                ['email',       String,   {:default => 'nospam@nospam.tw'}],
        #                ['created_at',  DateTime, {}],
        #                ['salt_first',  String,   {}],
        #                ['salt_second', String,   {}]]}
        # see Migration#storages and Migration#fields for detail
        def storages_and_fields
          storages.inject({}){ |result, storage|
            result[storage] = fields(storage)
            result
          }
        end

        # automaticly generate all model classes and mapping
        # all fields with mapping /.*/ for you.
        #  e.g.
        #       dm.auto_genclass!
        #       # => [DataMapper::Mapping::User,
        #       #     DataMapper::Mapping::SchemaInfo,
        #       #     DataMapper::Mapping::Session]
        #
        # you can change the scope of generated models:
        #  e.g.
        #       dm.auto_genclass! Object
        #       # => [User, SchemaInfo, Session]
        def auto_genclass! scope = DataMapper::Mapping
          require 'extlib'
          storages_and_fields.map{ |storage, fields|
            model = Class.new
            model.__send__ :include, DataMapper::Resource
            model.storage_names[:default] = storage
            model.__send__ :mapping, /.*/
            scope.const_set(Extlib::Inflection.classify(storage), model)
          }
        end

        private
        def dmm_query_storage
          raise NotImplementError.new("#{self.class}#fields is not implemented.")
        end
      end
    end
  end
end
