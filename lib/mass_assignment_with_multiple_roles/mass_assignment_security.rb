module ActiveModel
  module MassAssignmentSecurity

    protected

    def mass_assignment_authorizer(roles)
      active_authorizer = self.class.active_authorizer

      roles_array = if roles.is_a? Array
        roles
      elsif roles.is_a?(String) or roles.is_a?(Symbol)
        [roles]
      elsif roles.respond_to? :roles
        roles.send :roles
      end

      if roles_array
        roles_array.map!(&:to_sym)
        mixed_role_name = roles_array.sort.join('_').to_sym
      end

      if roles_array and active_authorizer.has_key?(mixed_role_name)
        active_authorizer[mixed_role_name]

      elsif roles_array and has_attr_configs_for?(roles_array)
        build_new_attrs_config roles_array, mixed_role_name
        self.class.active_authorizer[mixed_role_name]

      else
        active_authorizer[:default]
      end
    end

    private

    def has_attr_configs_for?(roles_array)
      roles_array.all? { |role_name| self.class.active_authorizer.has_key? role_name }
    end

    def build_new_attrs_config(roles_array, new_role_name)
      fields = roles_array.inject([]) do |result, role_name|
        result += self.class._accessible_attributes[role_name].to_a
      end

      self.class.attr_accessible(*fields, as: new_role_name)
    end
  end
end
