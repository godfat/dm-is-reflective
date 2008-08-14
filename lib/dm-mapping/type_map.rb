
module DataMapper
  class TypeMap
    # reversed lookup for primitive type to ruby type.
    #  e.g.
    #       lookup_primitive('DATETIME')
    #       # => { DateTime => {:auto_validation => true} }
    def lookup_primitive primitive, type_map = self
      type_map.chains.find{ |type, chain|
        primitive.upcase == chain.primitive &&
        [Integer, Float, BigDecimal,
         String, TrueClass, FalseClass,
         DateTime, Date, Time,
         DM::Text, DM::Boolean].member?(type)
      } or lookup_primitive(primitive, type_map.parent)
    end
  end
end
