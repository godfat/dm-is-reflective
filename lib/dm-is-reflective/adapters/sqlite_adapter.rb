
module DmIsReflective::SqliteAdapter
  include DataMapper

  def storages
    sql = <<-SQL
      SELECT name FROM sqlite_master
      WHERE type = 'table' AND NOT name = 'sqlite_sequence'
    SQL

    select(Ext::String.compress_lines(sql))
  end

  def indices storage
    sql = <<-SQL
      SELECT name, sql FROM sqlite_master
      WHERE type = 'index' AND tbl_name = ?
    SQL

    select(Ext::String.compress_lines(sql), storage).inject({}){ |r, idx|
      columns    = idx.sql[/\(.+\)/].scan(/\w+/)
      uniqueness = !!idx.sql[/CREATE UNIQUE INDEX/]

      columns.each{ |c|
        type = if uniqueness then :unique_index else :index end
        r[c] ||= {:unique_index => [], :index => []}
        r[c][type] << idx.name.to_sym
      }

      r
    }.inject({}){ |r, (column, idxs)|
      idx_uni, idx_com = [:unique_index, :index].map{ |type|
        i = idxs[type]
        if i.empty?
          nil
        elsif i.size == 1
          i.first.to_sym
        else
          i.map(&:to_sym)
        end
      }
      r[column.to_sym] = reflective_indices_hash(false, idx_uni, idx_com)
      r
    }
  end

  private
  def reflective_query_storage storage
    idxs = indices(storage)
    select('PRAGMA table_info(?)', storage).map{ |f|
      f.define_singleton_method(:storage){ storage             }
      f.define_singleton_method(:indices){ idxs[f.name.to_sym] }
      f
    }
  end

  def reflective_field_name field
    field.name
  end

  def reflective_primitive field
    field.type.gsub(/\(\d+\)/, '')
  end

  def reflective_attributes field, attrs={}
    attrs.merge!(field.indices) if field.indices

    if field.pk != 0
      attrs[:key]          = true
      attrs[:serial]       = true
      attrs[:unique_index] = :"#{field.storage}_pkey"
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
