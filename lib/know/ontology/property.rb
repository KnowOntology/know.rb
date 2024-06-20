# This is free and unencumbered software released into the public domain.

require_relative 'concept'

##
# A Know ontology property.
class Know::Ontology::Property < Know::Ontology::Concept
  ##
  # @param ontology [Ontology]
  # @param symbol [Symbol]
  def initialize(ontology, symbol)
    super(ontology, symbol)
  end
end # Know::Ontology::Property
