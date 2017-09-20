require 'masker/adapters/postgres'
require 'masker/configurations/postgres'
require 'masker/null_object'
require 'masker/configuration'
require 'masker/data_generator'
require 'pg'

class Masker
  def initialize(database_url:, config_path:, logger: NullObject.new, opts: {})
    @adapter = Adapters::Postgres.new(database_url, config_path, logger, opts)
  end

  def mask
    adapter.mask
  end

  private

  attr_reader :adapter
end
