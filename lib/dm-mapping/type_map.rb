
module DataMapper
  class TypeMap
    # reversed lookup for primitive type to ruby type.
    #  e.g.
    #       lookup_primitive('DATETIME')
    #       # => [DateTime, #<DataMapper::TypeMap::TypeChain:0x830b8>]
    def lookup_primitive primitive, type_map = self
      return nil unless type_map

      type_map.chains.find{ |type, chain|
        primitive.upcase == chain.primitive &&
        [Integer, Float, BigDecimal,
         String, TrueClass, FalseClass,
         DateTime, Date, Time,
         DM::Text, DM::Boolean].member?(type) &&
        # TINYINT size 1 shouldn't map to TrueClass
        chain.attributes[:size] != 1
      } or lookup_primitive(primitive, type_map.parent)
    end
  end
end
