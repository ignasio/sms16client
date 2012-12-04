# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name = 'sms16client'
  spec.description = %q{A gem that provides an interface to sms16.ru API.}
  spec.authors = ['Nikolay Burlov']
  spec.email = ['kohgpat@gmail.com']

  spec.add_dependency 'builder'
  spec.add_dependency 'sax-machine'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fakeweb'

  spec.version = '0.0.3'
  spec.files = `git ls-files`.split("\n")
  spec.homepage = 'http://github.com/kohgpat/sms16client'
  spec.licenses = ['MIT']
  spec.require_paths = ['lib']
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.summary = %q{A gem that provides an interface to sms16.ru API.}
  spec.test_files = `git ls-files -- {test,spec,feature}/*`.split("\n")
end
