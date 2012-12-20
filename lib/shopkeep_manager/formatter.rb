module ShopkeepManager
  class Formatter
    def initialize(thing_to_format)
      @output = ""
      @thing_to_format = thing_to_format
    end

    def format_output
      @thing_to_format.to_s
    end
  end
end
