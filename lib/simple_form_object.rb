require_relative "simple_form_object/attribute"
require_relative "simple_form_object/version"
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

    def _attributes
      @_attributes ||= []
    end

    def _attribute(attribute_name)
      _attributes.select{|a| a.name == attribute_name}.first
    end

    def model_name
      ActiveModel::Name.new(self, nil, self.to_s.gsub(/Form$/, ''))
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
end
