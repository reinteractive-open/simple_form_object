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

    def delegate_all(options = {})
      @_delegation_target = options.fetch(:to)
    end

    def _delegation_target
      @_delegation_target
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

  def method_missing(method, *args, &block)
    return super unless delegatable?(method)

    # TODO: Figure out why self.class.delegate(method, to: self.class._delegation_target)
    # doesn't work.

    self.class.send(:define_method, method) do |*args, &block|
      _delegation_target.send(method, *args, &block)
    end

    send(method, *args, &block)
  end

  def delegatable?(method)

    if !_delegation_target.nil?
      _delegation_target.respond_to?(method)
    else
      false
    end
  end

  def _delegation_target
    target = self.class._delegation_target

    if target.is_a? Symbol
      self.send(target)
    else
      target
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
