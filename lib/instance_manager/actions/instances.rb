require 'fog'
module InstanceManager
  module Actions
    class Instances < Action

      def run
        instances = find_instances
        puts InstanceFormatter.new(instances).format_output
        if instances.size == 0
          puts "  #{ 'env: ' << @options[:environment]}" if @options[:environment]
          puts "  #{ 'role: ' << @options[:role]}" if @options[:role]
        end
      end


      def find_instances
        if @options[:type] == "database"
          instances = InstanceManager::Connection.instance.rds_connection.servers
        else
          instances = InstanceManager::Connection.instance.compute_connection.servers
          # find only the running instances
          instances = instances.find_all {|x| x.state == "running" } unless @options[:all_instances]
          # filter for the environment
          instances = instances.find_all {|x| x.tags["Environment"] =~ /#{@options[:environment]}/i } if @options[:environment]
          # filter for the role
          instances = instances.find_all {|x| x.tags["Role"] =~ /#{@options[:role]}/i } if @options[:role]
        end
        instances = instances.find_all { |ins| ins.id == @args } if @args
        instances
      end
    end
  end
end
