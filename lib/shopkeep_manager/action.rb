module ShopkeepManager
  module Actions
    class Action
      def self.run(options,args = nil)
        q = new(options,args)
        q.run
      end
      def initialize(options = {},args = nil)
        @options = options
        @args = args if args
      end
    end
  end
end
