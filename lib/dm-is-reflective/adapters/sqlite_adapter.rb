
module DmIsReflective::SqliteAdapter
  include DataMapper

  def storages
    sql = <<-SQL
      SELECT name FROM sqlite_master
      WHERE type = 'table' AND NOT name = 'sqlite_sequence'
    SQL

    select(Ext::String.compress_lines(sql))
  end

  private
  def reflective_query_storage storage
    sql_indices = <<-SQL
      SELECT name, sql FROM sqlite_master
      WHERE type = 'index' AND tbl_name = ?
    SQL
    indices = select(sql_indices, storage).inject({}){ |r, field|
      columns    =   field.sql[/\(.+\)/].scan(/\w+/)
      uniqueness = !!field.sql[/CREATE UNIQUE INDEX/]

      columns.each{ |c|
        type = if uniqueness then :unique_index else :index end
        r[c] ||= {:unique_index => [], :index => []}
        r[c][type] << field.name
      }

      r
    }

    select('PRAGMA table_info(?)', storage).map{ |field|
      if idx = indices[field.name]
        idx_uni, idx_com = [:unique_index, :index].map{ |type|
          i = idx[type]
          if i.empty?
            nil
          elsif i.size == 1
            i.first.to_sym
          else
            i.map(&:to_sym)
          end
        }
      else
        idx_uni, idx_com = nil
      end

      field.instance_eval <<-RUBY
        def table_name  ; '#{storage}'      ; end
        def index       ; #{idx_com.inspect}; end
        def unique_index; #{idx_uni.inspect}; end
      RUBY

      field
    }
  end

  def reflective_field_name field
    field.name
  end

  def reflective_primitive field
    field.type.gsub(/\(\d+\)/, '')
  end

  def reflective_attributes field, attrs = {}
    if field.pk != 0
      attrs[:key]          = true
      attrs[:serial]       = true
      attrs[:unique_index] = :"#{field.table_name}_pkey"
    end

    attrs[:unique_index]   = field.unique_index if field.unique_index
    attrs[       :index]   = field.       index if field.       index

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
