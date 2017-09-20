require 'yaml'

module Configuration
  def self.load(config_path)
    fail "File not found: #{config_path}" unless File.exist?(config_path)
    YAML.load_file(config_path)
  end
end
