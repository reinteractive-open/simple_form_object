require 'spec_helper'

describe SimpleFormObject::Attribute do
  describe 'initialization' do
    subject(:attribute) { SimpleFormObject::Attribute.new(name, type, options) }

    let(:name) { :foo }
    let(:type) { :boolean }
    let(:options) { { default: 'hello' } }

    it 'should be initialized with a name, type and options hash' do
      expect(attribute.name).to eq name
      expect(attribute.type).to eq type
      expect(attribute.options).to eq options
    end

    describe 'type' do
      let(:type) { nil }

      it 'is :string when nil or not provided' do
        expect(attribute.type).to eq :string
      end
    end
  end

  describe '#apply_default_to' do
    let(:name) { :foo }
    let(:type) { :boolean }
    let(:options) { { default: default } }
    let(:default) { true }
    let(:attribute) { SimpleFormObject::Attribute.new(name, type, options) }
    let(:form) { double(foo: nil) }

    it 'should apply the default value to the attribute on the object' do
      expect(form).to receive("#{name}=").with(default)
      attribute.apply_default_to(form)
    end

    context 'with a falsey default' do
      let(:default) { false }
      it 'should apply the default value to the attribute on the object' do
        expect(form).to receive("#{name}=").with(default)
        attribute.apply_default_to(form)
      end
    end

    context 'when the form object attribute has a value' do
      let(:form) { double(foo: false) }

      it 'should not apply the default' do
        expect(form).to_not receive("#{name}=").with(default)
        attribute.apply_default_to(form)
        expect(form.foo).to eq false
      end
    end

    context 'with a lambda/proc default' do
      let(:default) { Proc.new { :bar } }

      it 'calls the lambda' do
        expect(form).to receive("#{name}=").with(:bar)
        attribute.apply_default_to(form)
      end

      context 'when the proc references the form' do
        let(:default) { Proc.new { current_foo } }
        let(:form) { double('Form', foo: nil, current_foo: :bar) }

        it 'calls the lambda' do
          expect(form).to receive("#{name}=").with(:bar)
          attribute.apply_default_to(form)
        end
      end
    end
  end
end
