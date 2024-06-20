# This is free and unencumbered software released into the public domain.

require_relative 'ontology/class'
require_relative 'ontology/property'

require 'rdf'

KNOW = RDF::Vocabulary.new('https://know.dev/')

PREFIXES = {
  dcterms: 'http://purl.org/dc/terms/',
  foaf:    'http://xmlns.com/foaf/0.1/',
  know:    KNOW.to_s,
  owl:     'http://www.w3.org/2002/07/owl#',
  rdf:     'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
  rdfs:    'http://www.w3.org/2000/01/rdf-schema#',
  schema:  'https://schema.org/',
  xsd:     'http://www.w3.org/2001/XMLSchema#',
}

##
# The Know Ontology.
class Know::Ontology
  include ::RDF

  ##
  # @example Loading the ontology in Turtle format
  #   require 'rdf/turtle'
  #   Know::Ontology.load('/path/to/know.ttl')
  #
  # @param path_or_url [String]
  def self.load(path_or_url)
    self.new(RDF::Graph.load(path_or_url))
  end

  ##
  # @param graph [RDF::Queryable]
  def initialize(graph)
    unless graph.is_a?(RDF::Queryable)
      raise ArgumentError, "expected an RDF::Queryable, but got #{graph.inspect}"
    end
    @graph = graph
  end

  ##
  # @return [RDF::Graph]
  attr_reader :graph

  ##
  # @example Looking up a concept
  #   ontology[:Person]  #=> #<Know::Ontology::Class :Person>
  #   ontology[:name]    #=> #<Know::Ontology::Property :name>
  #   ontology[:random]  #=> nil
  #
  # @param concept [Symbol, RDF::URI]
  # @return [Concept]
  def [](concept)
    case concept
      when Symbol then self.lookup_by_name(concept)
      when RDF::URI then self.lookup_by_uri(concept)
      else nil
    end
  end

  ##
  # @param concept_name [Symbol, #to_sym]
  # @return [Concept]
  def lookup_by_name(concept_name)
    concept_name = concept_name.to_sym
    self.concepts.find { |concept| concept.symbol == concept_name }
  end

  ##
  # @param concept_uri [RDF::URI]
  # @return [Concept]
  def lookup_by_uri(concept_uri)
    concept_curie = concept_uri.qname(prefixes: PREFIXES)
    case concept_curie.first
      when :know
        concept_name = concept_curie.last
        concept_class = case concept_name[0]
          when /\A[A-Z]\z/ then ::Know::Ontology::Class
          else ::Know::Ontology::Property
        end
        concept_class.new(self, concept_name)
      else nil
    end
  end

  ##
  # @return [Array<Symbol>]
  def symbols
    self.concepts.map(&:to_sym)
  end

  ##
  # @return [Array<Concept>]
  def concepts
    self.each_concept.to_a.sort
  end

  ##
  # @return [Array<Class>]
  def classes
    self.each_class.to_a.sort
  end

  ##
  # @return [Array<Property>]
  def properties
    self.each_property.to_a.sort
  end

  ##
  # @example Enumerating ontology symbols
  #   ontology.each_symbol do |symbol|
  #     p symbol
  #   end
  #
  # @return [Enumerator]
  def each_symbol(&block)
    return enum_for(:each_symbol) unless block_given?
    each_concept do |concept|
      block.call(concept.symbol)
    end
  end

  ##
  # @example Enumerating ontology concepts
  #   ontology.each_concept do |concept|
  #     p concept
  #   end
  #
  # @return [Enumerator]
  def each_concept(&block)
    return enum_for(:each_concept) unless block_given?
    (self.each_class + self.each_property).each(&block)
  end
  alias_method :each, :each_concept

  ##
  # @example Enumerating ontology classes
  #   ontology.each_class do |klass|
  #     p klass
  #   end
  #
  # @return [Enumerator]
  def each_class(&block)
    return enum_for(:each_class) unless block_given?
    query = RDF::Query.new({ klass: { RDF.type => OWL.Class } })
    query.execute(self.graph).each do |solution|
      klass_symbol = solution.klass.qname(prefixes: PREFIXES).last
      klass = Class::new(self, klass_symbol)
      block.call(klass)
    end
  end

  ##
  # @example Enumerating ontology properties
  #   ontology.each_property do |property|
  #     p property
  #   end
  #
  # @return [Enumerator]
  def each_property(&block)
    return enum_for(:each_property) unless block_given?
    queries = [
      RDF::Query.new({ property: { RDF.type => OWL.DatatypeProperty } }),
      RDF::Query.new({ property: { RDF.type => OWL.ObjectProperty } }),
    ]
    queries.each do |query|
      query.execute(self.graph).each do |solution|
        property_symbol = solution.property.qname(prefixes: PREFIXES).last
        property = Property::new(self, property_symbol)
        block.call(property)
      end
    end
  end
end # Know::Ontology
