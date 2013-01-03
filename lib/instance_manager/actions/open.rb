require 'erb'
module InstanceManager
  module Actions
    class Open < Action

      def run
        execute_script
      end


      def applescript
        select_ssh_user
        file = ENV['TERM_PROGRAM'] == 'iTerm.app' ? 'open-iterm.scpt.erb' : 'open.scpt.erb'
        template = ERB.new(File.read(File.join(File.dirname(__FILE__),
                                               '../templates', file)))
        @instances = Instances.new(@options,@args).find_instances
        template.result(binding)
      end

      private
      def select_ssh_user
        if user_from_options_file_contents
          @ssh_user = user_from_options_file_contents
        else
          @ssh_user = "deploy"
        end
      end

      def user_from_options_file_contents
        options_file = @options[:options_file] ||
          InstanceManager::Connection.instance.configuration.manager_conf_path
        if File.exists?(options_file)
          options_file_contents = YAML.load_file(
            File.expand_path(options_file)
          )
          if options_file_contents && options_file_contents[:instance_manager]
            options_file_contents[:instance_manager][:username]
          end
        end
      end

      def write_script
        script = Tempfile.new("instance-manager")
        script.write applescript
        script.close
        script
      end

      def execute_script
        script = write_script
        `osascript #{script.path}`
      end
    end
  end
end

