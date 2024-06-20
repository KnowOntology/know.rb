# This is free and unencumbered software released into the public domain.

module Know; class Ontology; end; end

##
# A Know ontology concept.
class Know::Ontology::Concept
  include ::Comparable

  # @return [Ontology]
  attr_reader :ontology

  # @return [Symbol]
  attr_reader :symbol

  ##
  # @param ontology [Ontology]
  # @param symbol [Symbol]
  def initialize(ontology, symbol)
    @symbol = symbol.to_sym
  end

  ##
  # @return [-1, 0, 1]
  def <=>(other)
    self.symbol <=> other.symbol
  end

  ##
  # @return [Symbol]
  def to_sym() @symbol end
end # Know::Ontology::Concept
