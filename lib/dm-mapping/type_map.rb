
module DataMapper
  class TypeMap
    # reversed lookup for primitive type to ruby type.
    #  e.g.
    #       lookup_primitive('DATETIME')
    #       # => { DateTime => {:auto_validation => true} }
    def lookup_primitive primitive, type_map = self
      type_map.chains.find{ |type, chain|
        primitive == chain.primitive
      } or lookup_primitive(primitive, type_map.parent)
    end
  end
end
