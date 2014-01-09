require 'spec_helper'

describe 'SimpleFormObject' do
  let(:base_klass) { Class.new.tap{|k| k.include SimpleFormObject } }
  let(:klass) { base_klass }
  let(:instance) { klass.new }

  context 'when included' do
    it 'should have ActiveModel::Model' do
      expect(instance).to respond_to :valid?
    end
  end

  describe '.attribute' do
    let(:attribute) { :foo }

    before do
      klass.attribute :foo
    end

    it 'should respond to "attribute"' do
      expect(instance).to respond_to(attribute)
    end

    it 'should respond to "attribute="' do
      expect(instance).to respond_to("#{attribute}=")
    end

    describe 'type' do
      let(:types) { %i(boolean string email url tel password search text file hidden integer float decimal range datetime date time select radio_buttons check_boxes country time_zone) }

      let(:type) { :boolean }
      let(:attr) { :la }

      before do
        klass.attribute attr, type
      end

      it 'should return a fake column with the correct type' do
        expect(instance.column_for_attribute(attr).type).to eq type
      end
    end

    describe 'options' do
      let(:type) { :boolean }
      let(:attr) { :doh }

      before do
        klass.attribute attr, type, default: true
      end

      describe 'default' do
        it 'should set the attribute to the default' do
          expect(instance.doh).to eq true
        end

        context 'when a value is supplied in the initialization hash' do
          let(:instance) { klass.new(doh: false) }

          it 'should use the value in the hash' do
            expect(instance.doh).to eq false
          end
        end

      end
    end
  end

  describe '.model_name' do
    let(:klass) do
      class KlassForm
        include SimpleFormObject
      end

      KlassForm
    end

    it 'should return an ActiveModel::Name' do
      expect(klass.model_name).to be_a_kind_of ActiveModel::Name
    end

    it 'should remove Form from the name of the class' do
      expect(klass.model_name.name).to eq "Klass"
    end
  end
end
