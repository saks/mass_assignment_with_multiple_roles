# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mass_assignment_with_multiple_roles/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["saksmlz"]
  gem.email         = ["saksmlz@gmail.com"]
  gem.description   = %q{This gem allows you to pass multiple roles into methods like save and update_attributes}
  gem.summary       = %q{Allows to use intersection of attr_accessible if passing multiple role names on save}
  gem.homepage      = "http://github.com/saks/mass_assignment_with_multiple_roles"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mass_assignment_with_multiple_roles"
  gem.require_paths = ["lib"]
  gem.version       = MassAssignmentWithMultipleRoles::VERSION

  gem.add_development_dependency 'activesupport', '~> 3.2.3'
  gem.add_development_dependency 'mocha', '> 0'
  gem.add_development_dependency 'rake', '> 0'
  gem.add_dependency 'activemodel', '~> 3.2.3'
end
