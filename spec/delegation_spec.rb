require 'spec_helper'

describe 'SimpleFormObject delegation' do
  let(:base_klass) { Class.new.tap{|k| k.include SimpleFormObject } }
  let(:klass) { base_klass }
  let(:instance) { klass.new }

  describe '.delegate_all' do
    let(:target) { double }

    before do
      klass.delegate_all to: target
    end

    it 'should delegate foo to the target' do
      expect(target).to receive(:foo)
      instance.foo

      expect(target).to receive(:foo).with([1,2,3,4])
      instance.foo([1,2,3,4])
    end
  end

  describe 'a more complex delegation' do
    let(:base_klass) do
      Class.new do
        include SimpleFormObject

        def initialize(target_object, attributes = {})
          @target_object = target_object
          super(attributes)
        end

        attr_reader :target_object

        delegate_all to: :target_object
      end
    end

    let(:target) { double }
    let(:instance) { klass.new(target) }

    it 'should delegate foo to the target' do
      expect(target).to receive(:foo)
      instance.foo

      expect(target).to receive(:foo).with([1,2,3,4])
      instance.foo([1,2,3,4])
    end

  end
end
