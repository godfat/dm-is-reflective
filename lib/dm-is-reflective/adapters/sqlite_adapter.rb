
module DmIsReflective::SqliteAdapter
  include DataMapper

  def storages
    sql = <<-SQL
      SELECT name
      FROM sqlite_master
      WHERE type = 'table' AND NOT name = 'sqlite_sequence'
    SQL

    select(Ext::String.compress_lines(sql))
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
      attrs[:serial] = true
    end
    attrs[:allow_nil] = field.notnull == 0
    attrs[:default] = field.dflt_value[1..-2] if field.dflt_value

    if field.type.upcase == 'TEXT'
      attrs[:length] = Property::Text.length
    else
      ergo = field.type.match(/\((\d+)\)/)
      size = ergo && ergo[1].to_i
      attrs[:length] = size if size
    end

    attrs
  end

  def reflective_lookup_primitive primitive
    case primitive.upcase
    when 'INTEGER'        ; Integer
    when 'REAL', 'NUMERIC'; Float
    when 'VARCHAR'        ; String
    when 'TIMESTAMP'      ; DateTime
    when 'BOOLEAN'        ; Property::Boolean
    when 'TEXT'           ; Property::Text
    end || super(primitive)
  end
end
