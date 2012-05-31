# require File.expand_path('../../../../load_paths', __FILE__)

lib = File.expand_path("#{File.dirname(__FILE__)}/../../lib")
$:.unshift(lib) unless $:.include?('lib') || $:.include?(lib)

require 'config'
require 'active_model'
require 'active_support/core_ext/string/access'
require 'mass_assignment_with_multiple_roles'
require 'active_model/mass_assignment_security/permission_set'
require 'active_model/mass_assignment_security/sanitizer'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true

require 'test/unit'
