
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
    sql_key = <<-SQL
      SELECT column_name FROM "information_schema"."key_column_usage"
      WHERE table_schema = current_schema() AND table_name = ?
    SQL

    sql_index = <<-SQL
      SELECT
            (i.relname, ix.indisunique)
      FROM
            pg_class t, pg_class i, pg_index ix, pg_attribute a
      WHERE
            t.oid      = ix.indrelid
        AND i.oid      = ix.indexrelid
        AND a.attrelid = t.oid
        AND a.attnum   = ANY(ix.indkey)
        AND a.attname  = column_name
        AND t.relkind  = 'r'
        AND t.relname  = ?
    SQL

    sql = <<-SQL
      SELECT column_name, column_default, is_nullable,
             character_maximum_length, udt_name,
             (#{sql_key}) AS key, (#{sql_index}) AS indexname_uniqueness
      FROM "information_schema"."columns"
      WHERE table_schema = current_schema() AND table_name = ?
    SQL

    select(Ext::String.compress_lines(sql), storage, storage, storage)
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

    # find out index and unique index
    if field.indexname_uniqueness
      index_name, uniqueness = field.indexname_uniqueness[1..-2].split(',')
    end

    attrs[:serial] = true if field.column_default =~ /nextval\('\w+'\)/
    attrs[:key]    = true if field.column_name == field.key

    if index_name
      if uniqueness
        attrs[:unique_index] = index_name.to_sym
      else
        attrs[:index]        = index_name.to_sym
      end
    end

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
