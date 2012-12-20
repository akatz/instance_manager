module ShopkeepManager
  module Actions
    class SshConfig < Action

      def run
        puts generate_config.chomp
      end

      def generate_config
        template = ERB.new(File.read(File.join(File.dirname(__FILE__),'../templates/ssh-config.erb')))
        @instances = Instances.new(@options).find_instances
        template.result(binding)
      end

    end
  end
end


