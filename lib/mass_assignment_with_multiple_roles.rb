require 'active_model'
require 'mass_assignment_with_multiple_roles/version'

module MassAssignmentWithMultipleRoles
  ROLE_NAMES_METHOD = :role_names

  def compile_role_name(roles, active_authorizer)
    roles_array = if roles.is_a? Array
      roles
    elsif roles.respond_to? ROLE_NAMES_METHOD
      [roles.send(ROLE_NAMES_METHOD)].flatten
    else
      [roles]
    end

    roles_array = roles_array.find_all { |role| active_authorizer.has_key? role }

    if roles_array.any?
      [ roles_array.map(&:to_s).join('_').to_sym, roles_array ]
    else
      [ nil, roles_array ]
    end
  end

  def build_new_attrs_config(roles_array, new_role_name, klass)
    fields = roles_array.inject([]) do |result, role_name|
      result += klass.active_authorizer[role_name].to_a
    end

    method_name = if klass.active_authorizer[ roles_array[0] ].is_a? ActiveModel::MassAssignmentSecurity::WhiteList
      :attr_accessible
    else
      :attr_protected
    end

    klass.send method_name, *fields, :as => new_role_name
  end

  extend self
end

module ActiveModel
  module MassAssignmentSecurity

    protected

    def mass_assignment_authorizer(roles)
      active_authorizer = self.class.active_authorizer

      composite_role_name, roles_array = MassAssignmentWithMultipleRoles::compile_role_name roles, active_authorizer

      if !composite_role_name
        active_authorizer[:default]

      elsif active_authorizer.has_key? composite_role_name
        active_authorizer[composite_role_name]

      else
        MassAssignmentWithMultipleRoles::build_new_attrs_config roles_array, composite_role_name, self.class
        self.class.active_authorizer[composite_role_name]
      end
    end

  end
end
