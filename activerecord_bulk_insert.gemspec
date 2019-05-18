# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/bulk_insert/version'

Gem::Specification.new do |spec|
  spec.name        = 'ActiveRecord::BulkInsert'
  spec.version     = ActiveRecord::BulkInsert::VERSION.join('.')
  spec.date        = '2019-05-01'
  spec.summary     = 'Bulk Insert For ActiveRecord'
  spec.description = 'Bulk Insert For ActiveRecord via Postgresql json_to_recordset'
  spec.authors     = ['Andrew Rove']
  spec.email       = 'andrew.m.rove@gmail.com'
  spec.homepage    = 'https://rubygemspec.org/gems/activerecord_bulk_insert'
  spec.license     = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|gemfiles)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 4.0.0'
  spec.add_runtime_dependency 'pg'

  spec.add_development_dependency 'appraisal', '~> 2.2'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.69'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'brakeman', '~> 4.5'
end
