
module DataMapper
  class TypeMap
    def lookup_primitive primitive, type_map = self
      type_map.chains.find{ |type, chain|
        primitive == chain.primitive
      } or lookup_primitive(primitive, type_map.parent)
    end
  end
end
