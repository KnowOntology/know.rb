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

  ##
  # @return [Boolean]
  def datatype?
    self.fetch_objects(RDF[:type]).include?(OWL[:DatatypeProperty])
  end

  ##
  # @return [Boolean]
  def functional?
    self.fetch_objects(RDF[:type]).include?(OWL[:FunctionalProperty])
  end

  ##
  # @return [Range]
  def cardinality
    min = 0
    max = self.functional? ? 1 : nil
    (min..max)
  end

  ##
  # @return [Class]
  attr_reader :domain
  def domain() self.domains.first end

  ##
  # @return [Array<Class>]
  attr_reader :domains
  def domains
    self.fetch_concepts(RDFS[:domain])
  end

  ##
  # @return [Concept, RDF::URI]
  attr_reader :range
  def range() self.ranges.first end

  ##
  # @return [Array<Concept, RDF::URI>]
  attr_reader :ranges
  def ranges
    self.fetch_objects(RDFS[:range]).map do |object|
      self.ontology.lookup_by_uri(object) || object
    end
  end
end # Know::Ontology::Property
