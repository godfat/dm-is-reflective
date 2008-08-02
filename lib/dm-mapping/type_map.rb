
module DataMapper
  class TypeMap
    def find_primitive primitive, type_map = self
      type_map.chains.find{ |type, chain|
        primitive == chain.primitive
      } or find_primitive(primitive, type_map.parent)
    end
  end
end
