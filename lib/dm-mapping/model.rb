
module DataMapper
  module Model
    def mapping regexp = /.*/
      fields.map{ |field|
        name, type, attrs = field
        property name.to_sym, type, attrs if name =~ regexp
      }
    end
    def fields
      DataMapper.repository.adapter.fields storage_name
    end
  end
end
