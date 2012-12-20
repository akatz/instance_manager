module ShopkeepManager
  class Configuration
    DEFAULT_PATH = File.expand_path("~/.shopkeep")
    attr_accessor :fog_conf_path, :fog_conf, :manager_conf_path, :manager_conf
    def initialize(options = {})
      @conf = {}
      conditionally_set_paths(options)
      load_configurations
    end
    private
    def conditionally_set_paths(options)
      options.each do |option,value|
        send("#{option}=", options[option])
      end
      self.fog_conf_path = DEFAULT_PATH if fog_conf_path.nil?
      self.manager_conf_path = DEFAULT_PATH if manager_conf_path.nil?
    end
    def load_configurations
      self.fog_conf = YAML.load_file(self.fog_conf_path) if File.exist?(self.fog_conf_path)
      self.manager_conf = YAML.load_file(self.manager_conf_path) if File.exist?(self.manager_conf_path)
    end
  end
end
