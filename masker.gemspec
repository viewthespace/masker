Gem::Specification.new do |s|
  s.name          = 'masker'
  s.version       = '0.1.0'
  s.authors       = ['Danny Park']
  s.email         = ['dannypark92@gmail.com']
  s.summary       = "Database masking for sensitive information"
  s.description   = "Production databases contain sensitive information that should not be
                     propagated down to other environments. This gem allows users to create
                     masking strategies in a YML file that specify columns to mask and tables
                     to truncate"
  s.license       = 'MIT'
  s.files         = Dir.glob("lib/**/*.rb")
  s.homepage      = 'https://www.github.com/viewthespace/masker'

  s.add_runtime_dependency 'pg', '~> 0.21'
  s.add_runtime_dependency 'faker', '~> 1.8'
end
