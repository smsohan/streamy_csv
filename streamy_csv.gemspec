# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'streamy_csv/version'

Gem::Specification.new do |gem|
  gem.name          = "streamy_csv"
  gem.version       = StreamyCsv::VERSION
  gem.authors       = ["smsohan"]
  gem.email         = ["sohan39@gmail.com"]
  gem.description   = %q{Streamy CSV lets you stream live generated CSV files}
  gem.summary       = %q{Provides a simple API for your controllers to stream CSV files one row at a time}
  gem.homepage      = "https://github.com/smsohan/streamy_csv"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec')
end
