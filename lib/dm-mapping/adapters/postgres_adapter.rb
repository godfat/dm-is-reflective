
require 'dm-mapping/adapters/abstract_adapter'

module DataMapper
  module Mapping
    module PostgresAdapter
      def storages
        sql = <<-SQL.compress_lines
          SELECT table_name FROM "information_schema"."tables"
          WHERE table_schema = current_schema()
        SQL

        query(sql)
      end

      private
      def dmm_query_storage storage
        sql = <<-SQL.compress_lines
          SELECT column_name FROM "information_schema"."key_column_usage"
          WHERE table_schema = current_schema() AND table_name = ?
        SQL

        keys = query(sql, storage).to_set

        sql = <<-SQL.compress_lines
          SELECT column_name, column_default, is_nullable,
                 character_maximum_length, udt_name
          FROM "information_schema"."columns"
          WHERE table_schema = current_schema() AND table_name = ?
        SQL

        query(sql, storage).map{ |struct|
          struct.instance_eval <<-END_EVAL
            def key?
              #{keys.member?(struct.column_name)}
            end
          END_EVAL
          struct
        }
      end

      def dmm_field_name field
        field.column_name
      end

      def dmm_primitive field
        field.udt_name
      end

      def dmm_attributes field, attrs = {}
        # strip data type
        field.column_default.gsub!(/(.*?)::[\w\s]*/, '\1') if field.column_default

        attrs[:serial] = true if field.column_default =~ /nextval\('\w+_seq'\)/
        attrs[:key] = true if field.key?
        attrs[:nullable] = field.is_nullable == 'YES'
        # strip string quotation
        attrs[:default] = field.column_default.gsub(/^'(.*?)'$/, '\1') if
          field.column_default && !attrs[:serial]

        if field.character_maximum_length
          attrs[:size] = field.character_maximum_length
        elsif field.udt_name.upcase == 'TEXT'
          attrs[:length] = DataMapper::Types::Text.size
        end

        attrs
      end

      def dmm_lookup_primitive primitive
        p = primitive.upcase

        return TrueClass if p == 'BOOL'

        super(primitive)
      end

    end
  end
end

module DataMapper
  module Adapters
    PostgresAdapter.send(:include, Mapping::PostgresAdapter)
  end
end
