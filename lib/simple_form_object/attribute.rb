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
        form.send("#{@name}=", @default) if @apply_default
      end
    end

    private

    def extract_options
      @apply_default = true
      @default = options.fetch(:default) { @apply_default = false; nil }
      @skip_validations = options.fetch(:skip_validations, false)
    end
  end
end
