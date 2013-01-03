require 'fog'
module InstanceManager
  module Actions
    class Search < Action

      def run
        connection = InstanceManager::Connection.instance.compute_connection
        st = prepare_search_hash(connection)
        instances = connection.servers.all(st)

        if instances.nil? || instances.size == 0
          puts "No instances found that match #{@args}"
        else
          puts InstanceFormatter.new(instances).format_output
        end
      end

      private

      def prepare_search_hash(connection)
        if instance_id?
          filter = "instance-id"
        elsif private_ip?
          filter = "private-ip-address"
        elsif public_ip?
          filter = "ip-address"
        elsif private_hostname?
          filter = "private-dns-name"
        elsif public_hostname?
          filter = "dns-name"
        end
        {filter => append_domain_name}
      end

      def append_domain_name
        args = @args.dup
        ec2 = args.match(/ec2.internal/)
        compute = args.match(/compute-1.internal/)
        if args =~ /^domU/ && !compute
          args << ".compute-1.internal"
        elsif args =~ /^ip/ && !ec2
          args << ".ec2.internal"
        end
        args
      end

      def instance_id?
        !!@args.match(/^i-/)
      end
      def private_ip?
        !!@args.match(/^10\./)
      end
      def public_ip?
        !!@args.match(/^\d{1,3}/)
      end
      def public_hostname?
        !!@args.match(/^(ec2)/)
      end
      def private_hostname?
        @args.match(/^(ip|domU)/)
      end

    end
  end
end

