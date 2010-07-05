
module DataMapper
  module Is::Reflective
    module PostgresAdapter
      def storages
        sql = <<-SQL.compress_lines
          SELECT table_name FROM "information_schema"."tables"
          WHERE table_schema = current_schema()
        SQL

        select(sql)
      end

      private
      def reflective_query_storage storage
        sql = <<-SQL.compress_lines
          SELECT column_name FROM "information_schema"."key_column_usage"
          WHERE table_schema = current_schema() AND table_name = ?
        SQL

        keys = select(sql, storage).to_set

        sql = <<-SQL.compress_lines
          SELECT column_name, column_default, is_nullable,
                 character_maximum_length, udt_name
          FROM "information_schema"."columns"
          WHERE table_schema = current_schema() AND table_name = ?
        SQL

        select(sql, storage).map{ |struct|
          struct.instance_eval <<-END_EVAL
            def key?
              #{keys.member?(struct.column_name)}
            end
          END_EVAL
          struct
        }
      end

      def reflective_field_name field
        field.column_name
      end

      def reflective_primitive field
        field.udt_name
      end

      def reflective_attributes field, attrs = {}
        # strip data type
        field.column_default.gsub!(/(.*?)::[\w\s]*/, '\1') if field.column_default

        attrs[:serial] = true if field.column_default =~ /nextval\('\w+'\)/
        attrs[:key] = true if field.key?
        attrs[:required] = field.is_nullable != 'YES'
        # strip string quotation
        attrs[:default] = field.column_default.gsub(/^'(.*?)'$/, '\1') if
          field.column_default && !attrs[:serial]

        if field.character_maximum_length
          attrs[:length] = field.character_maximum_length
        elsif field.udt_name.upcase == 'TEXT'
          attrs[:length] = DataMapper::Property::Text.length
        end

        attrs
      end

      def reflective_lookup_primitive primitive
        p = primitive.upcase

        return Integer  if p =~ /^INT\d+$/
        return String   if p == 'VARCHAR'
        return DateTime if p == 'TIMESTAMP'
        return DataMapper::Property::Text    if p == 'TEXT'
        return DataMapper::Property::Boolean if p == 'BOOL'

        super(primitive)
      end

    end
  end
end
