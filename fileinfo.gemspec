# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_info/version'

Gem::Specification.new do |spec|
  spec.name          = 'fileinfo'
  spec.version       = FileInfo::VERSION
  spec.authors       = ['Rafaël Blais Masson']
  spec.email         = ['rafael@heliom.ca']
  spec.description   = "FileInfo detects file encodings and MIME types using the wonderful Unix `file` command."
  spec.summary       = "FileInfo detects file encodings and MIME types using the wonderful Unix `file` command."
  spec.homepage      = 'http://github.com/rafBM/fileinfo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'mime-types'
end
