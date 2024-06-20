# This is free and unencumbered software released into the public domain.

require_relative 'concept'

##
# A Know ontology class.
class Know::Ontology::Class < Know::Ontology::Concept
  ##
  # @param ontology [Ontology]
  # @param symbol [Symbol]
  def initialize(ontology, symbol)
    super(ontology, symbol)
  end

  ##
  # @return [Property]
  def [](symbol)
    raise NotImplementedError # TODO
  end

  ##
  # @return [Array<Property>]
  def properties
    self.each_property.to_a.sort
  end

  ##
  # @example Enumerating class properties
  #   klass.each_property do |property|
  #     p property
  #   end
  #
  # @return [Enumerator]
  def each_property(&block)
    return enum_for(:each_property) unless block_given?
    raise NotImplementedError # TODO
  end
end # Know::Ontology::Class
