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
