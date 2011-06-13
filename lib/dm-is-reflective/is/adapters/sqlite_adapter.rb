
module DataMapper
  module Is::Reflective
    module SqliteAdapter
      include DataMapper::Ext

      def storages
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE type = 'table' AND NOT name = 'sqlite_sequence'
        SQL

        select(String.compress_lines(sql))
      end

      private
      def reflective_query_storage storage
        select('PRAGMA table_info(?)', storage)
      end

      def reflective_field_name field
        field.name
      end

      def reflective_primitive field
        field.type.gsub(/\(\d+\)/, '')
      end

      def reflective_attributes field, attrs = {}
        if field.pk != 0
          attrs[:key] = true
          attrs[:serial] = true if supports_serial?
        end
        attrs[:required] = field.notnull == 1
        attrs[:default] = field.dflt_value[1..-2] if field.dflt_value

        if field.type.upcase == 'TEXT'
          attrs[:length] = DataMapper::Property::Text.length
        else
          ergo = field.type.match(/\((\d+)\)/)
          size = ergo && ergo[1].to_i
          attrs[:length] = size if size
        end

        attrs
      end

      def reflective_lookup_primitive primitive
        p = primitive.upcase

        return Integer  if p == 'INTEGER'
        return Float    if p == 'REAL' || p == 'NUMERIC'
        return DataMapper::Property::Text if p == 'TEXT'

        super(primitive)
      end
    end
  end
end
