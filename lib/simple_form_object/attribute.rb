module SimpleFormObject
  class Attribute
    def initialize(name, type = nil, options)
      @name = name
      @type = type || :string
      @options = options

      extract_options
    end

    attr_accessor :name, :type, :options

    def fake_column
      self
    end

    def apply_default_to(form)
      if form.send(@name).nil?
        default_value = @default.respond_to?(:call) ? @default.call : @default
        form.send("#{@name}=", default_value) if @apply_default
      end
    end

    def number?
      %i(integer float decimal).include?(type)
    end

    def limit
      nil
    end

    private

    def extract_options
      @apply_default = true
      @default = options.fetch(:default) { @apply_default = false; nil }
      @skip_validations = options.fetch(:skip_validations, false)
    end
  end
end
