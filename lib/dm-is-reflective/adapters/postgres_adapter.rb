
module DmIsReflective::PostgresAdapter
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
    sql_indices = <<-SQL
      SELECT
            a.attname, i.relname, ix.indisprimary, ix.indisunique
      FROM
            pg_class t, pg_class i, pg_index ix, pg_attribute a
      WHERE
            t.oid      = ix.indrelid
        AND i.oid      = ix.indexrelid
        AND a.attrelid = t.oid
        AND a.attnum   = ANY(ix.indkey)
        AND t.relkind  = 'r'
        AND t.relname  = ?
    SQL

    sql_columns = <<-SQL
      SELECT column_name, column_default, is_nullable,
             character_maximum_length, udt_name
      FROM "information_schema"."columns"
      WHERE table_schema = current_schema() AND table_name = ?
    SQL

    indices =
    select(Ext::String.compress_lines(sql_indices), storage).
      group_by(&:attname)

    select(Ext::String.compress_lines(sql_columns), storage).map do |column|
      if idx = indices[column.column_name]
        is_key = !!idx.find{ |i| i.indisprimary }
        idx_uni, idx_com = idx.partition{ |i| i.indisunique }.map{ |i|
          if i.empty?
            nil
          elsif i.size == 1
            i.first.relname.to_sym
          else
            i.map{ |ii| ii.relname.to_sym }
          end
        }
      else
        is_key = false
        idx_uni, idx_com = nil
      end

      column.instance_eval <<-RUBY
        def key?        ; #{is_key}         ; end
        def index       ; #{idx_com.inspect}; end
        def unique_index; #{idx_uni.inspect}; end
      RUBY

      column
    end
  end

  def reflective_field_name field
    field.column_name
  end

  def reflective_primitive field
    field.udt_name
  end

  def reflective_attributes field, attrs = {}
    # strip data type
    if field.column_default
      field.column_default.gsub!(/(.*?)::[\w\s]*/, '\1')
    end

    attrs[:serial] = true if field.column_default =~ /nextval\('\w+'\)/
    attrs[:key]    = true if field.key?

    attrs[:unique_index] = field.unique_index if field.unique_index
    attrs[       :index] = field.       index if field.       index

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
    when 'NUMERIC'          ; Property::Decimal
    end || super(primitive)
  end
end
