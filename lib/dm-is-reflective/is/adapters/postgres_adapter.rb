
module DataMapper
  module Is::Reflective
    module PostgresAdapter
      include DataMapper

      def storages
        sql = <<-SQL
          SELECT table_name FROM "information_schema"."tables"
          WHERE table_schema = current_schema()
        SQL

        select(Ext::String.compress_lines(sql))
      end

      private
      def reflective_query_storage storage
        sql = <<-SQL
          SELECT column_name FROM "information_schema"."key_column_usage"
          WHERE table_schema = current_schema() AND table_name = ?
        SQL

        keys = select(Ext::String.compress_lines(sql), storage).to_set

        sql = <<-SQL
          SELECT column_name, column_default, is_nullable,
                 character_maximum_length, udt_name
          FROM "information_schema"."columns"
          WHERE table_schema = current_schema() AND table_name = ?
        SQL

        select(Ext::String.compress_lines(sql), storage).map{ |struct|
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
        attrs[:allow_nil] = field.is_nullable == 'YES'
        # strip string quotation
        attrs[:default] = field.column_default.gsub(/^'(.*?)'$/, '\1') if
          field.column_default && !attrs[:serial]

        if field.character_maximum_length
          attrs[:length] = field.character_maximum_length
        elsif field.udt_name.upcase == 'TEXT'
          attrs[:length] = Property::Text.length
        end

        attrs
      end

      def reflective_lookup_primitive primitive
        case primitive.upcase
        when /^INT\d+$/         ; Integer
        when /^FLOAT\d+$/       ; Float
        when 'VARCHAR', 'BPCHAR'; String
        when 'TIMESTAMP', 'DATE'; DateTime
        when 'TEXT'             ; Property::Text
        when 'BOOL'             ; Property::Boolean
        when 'NUMERIC'          ; Decimal
        end || super(primitive)
      end
    end
  end
end
