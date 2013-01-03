require 'pry'
require_relative 'formatter'
module InstanceManager
  class InstanceFormatter < Formatter
    def initialize(instances = nil, options = {labels: true})
      @output = ""
      @instances = Array(instances)
      @options = options
    end

    def format_output
      if @instances.empty? || @instances.nil?
        @output << "No Instances Matched"
      else
        @instances.reject {|ins| ins.id.nil?}.each do |instance|
          if instance.class.to_s.match /rds/i
            format_rds_instance(instance)
          else
            format_ec2_instance(instance)
          end
        end
      end
      @output.chomp
    end

    private

    def format_ec2_instance(instance)
      amazon_id(instance)
      space
      hashrocket
      space
      name(instance)
      newline
      indent
      ip(instance)
      newline
      if @options[:private_ip]
        indent
        private_ip
        newline
      end
      indent
      private_hostname(instance)
      newline
      newline
    end

    def format_rds_instance(instance)
      @output << instance.id
      newline
      @output << "Endpoint: #{instance.endpoint["Address"]}"
      newline
      @output << "Type: "
      if instance.read_replica_source
        @output << "Replica"
      else
        @output << "Master"
      end
      newline
      newline
    end

    def newline
      @output << "\n"
    end

    def amazon_id(instance)
      @output << instance.id unless instance.id.nil?
    end

    def hashrocket
      @output << "=>"
    end

    def name(instance)
      @output << "#{instance.tags["Name"]}" unless instance.tags.nil?
    end

    def ip(instance)
      @output << "ip: " if @options[:labels]
      @output << instance.public_ip_address unless instance.public_ip_address.nil?
    end

    def private_hostname(instance)
      @output << "private hostname: " if @options[:labels]
      @output << instance.private_dns_name unless instance.private_dns_name.nil?
    end

    def private_ip(instance)
      @output << "private ip: " if @options[:labels]
      @output << instance.private_ip_address unless instance.private_ip_address.nil?
    end

    def space
      @output << " "
    end

    def indent
      if block_given?
        yield("  ")
      else
        @output << "  "
      end

    end

  end
end
