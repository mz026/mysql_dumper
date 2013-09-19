# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mysql_dumper/version'

Gem::Specification.new do |spec|
  spec.name          = "mysql_dumper"
  spec.version       = MysqlDumper::VERSION
  spec.authors       = ["Yang-Hsing Lin"]
  spec.email         = ["yanghsing.lin@gmail.com"]
  spec.description   = %q{mysqldump wrapper}
  spec.summary       = %q{provides both command line and ruby interface}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
