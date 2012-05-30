require 'active_model'
require 'mass_assignment_with_multiple_roles/version'
require 'mass_assignment_with_multiple_roles/active_model/mass_assignment_security'

ActiveModel::MassAssignmentSecurity.send(
  :alias_method, :_original_mass_assignment_authorizer, :mass_assignment_authorizer)

ActiveModel::MassAssignmentSecurity.send :remove_method, :mass_assignment_authorizer

ActiveModel::MassAssignmentSecurity.send :include,
  MassAssignmentWithMultipleRoles::ActiveModel::MassAssignmentSecurity
