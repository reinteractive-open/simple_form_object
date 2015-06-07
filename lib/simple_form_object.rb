require "simple_form_object/version"
require "simple_form_object/attribute"
require "active_model"
require "active_support"

module SimpleFormObject
  extend ActiveSupport::Concern

  include ActiveModel::Model

  module ClassMethods
    def attribute(name, type = :string, options = {})
      self.send(:attr_accessor, name)

      _attributes << Attribute.new(name, type, options)
    end

    def route_as(model_name)
      @model_name = model_name.to_s.camelize
    end

    def _attributes
      inherited_attributes = []

      ancestors.drop(1).each do |ancestor|
        if ancestor.respond_to?(:_attributes)
          inherited_attributes.concat(ancestor._attributes)
        end
      end

      @_attributes ||= inherited_attributes
    end

    def _attribute(attribute_name)
      _attributes.select{|a| a.name == attribute_name}.first
    end

    def model_name
      ActiveModel::Name.new(self, nil, model_name_for_routing)
    end

    private

    def model_name_for_routing
      @model_name || to_s.gsub(/Form$/, "")
    end
  end

  def column_for_attribute(attribute)
    self.class._attribute(attribute).fake_column
  end

  def initialize(attributes={})
    super
    self.class._attributes.each do |attribute|
      attribute.apply_default_to(self)
    end
  end

  def attributes
    attribs = {}
    self.class._attributes.each do |a|
      attribs[a.name] = self.send(a.name)
    end
    attribs
  end

  def has_attribute?(attribute)
    attributes.key?(attribute)
  end
end
