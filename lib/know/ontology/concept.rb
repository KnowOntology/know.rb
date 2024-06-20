# This is free and unencumbered software released into the public domain.

require 'rdf'

module Know; class Ontology; end; end

##
# A Know ontology concept.
class Know::Ontology::Concept
  include ::Comparable
  include ::RDF

  ##
  # @param ontology [Ontology]
  # @param symbol [Symbol]
  def initialize(ontology, symbol)
    @ontology = ontology
    @symbol = symbol.to_sym
  end

  # @return [Ontology]
  attr_reader :ontology

  # @return [Symbol]
  attr_reader :symbol

  # @return [String]
  attr_reader :glyph
  def glyph
    self.fetch_value(KNOW[:glyph])
  end

  # @return [String]
  attr_reader :label
  def label(language = :en)
    self.fetch_value(RDFS[:label], language)
  end

  ##
  # @return [-1, 0, 1]
  def <=>(other)
    self.symbol <=> other.symbol
  end

  ##
  # @return [Symbol]
  def to_sym() self.symbol end

  ##
  # @return [RDF::URI]
  def to_uri
    KNOW[self.symbol]
  end

  ##
  # @param property [RDF::URI]
  # @param language [#to_sym]
  # @return [Object]
  def fetch_value(property, language = nil)
    literals = self.fetch_literals(property)
    if language
      language = language.to_sym
      literals.reject! do |literal|
        literal.language != language
      end
    end
    literals&.first&.value
  end

  ##
  # @param property [RDF::URI]
  # @return [Enumerable<RDF::Literal>]
  def fetch_literals(property)
    self.fetch_objects(property).select do |object|
      object.is_a?(RDF::Literal)
    end
  end

  ##
  # @return [Array<Concept, RDF::URI>]
  def fetch_concepts(property)
    self.fetch_objects(property).map do |object|
      next unless object.is_a?(RDF::URI)
      self.ontology.lookup_by_uri(object)
    end.compact
  end

  ##
  # @param property [RDF::URI]
  # @return [Enumerable<RDF::Term>]
  def fetch_objects(property)
    graph = self.ontology.graph
    graph.query([self.to_uri, property]).objects
  end
end # Know::Ontology::Concept
