require "cases/helper"
require 'models/mass_assignment_specific'
require 'ostruct'
require 'mocha'

class MassAssignmentSecurityWithMultipleRolesTest < ActiveModel::TestCase
  def setup
    Student.active_authorizer.delete :admin_user
  end

  def test_attribute_protection_when_role_is_nil
    student = Student.new
    expected = { 'name' => 'buz' }
    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'), [nil, :admin])
    assert_equal expected, sanitized
  end

  def test_with_an_array_of_roles
    student = Student.new
    expected = { 'name' => 'buz', 'email' => 'foo' }
    sanitized = student.sanitize_for_mass_assignment(expected, [:user, :admin])
    assert_equal expected, sanitized
  end

  def test_with_object_that_respond_to_roles_method
    student = Student.new
    user    = OpenStruct.new roles: [:user, :admin]

    expected = { 'name' => 'buz', 'email' => 'foo' }
    sanitized = student.sanitize_for_mass_assignment(expected, user)
    assert_equal expected, sanitized
  end

  def test_that_attributes_are_cached_and_not_created_second_time
    student = Student.new
    expected = { 'name' => 'buz', 'email' => 'foo' }

    student.sanitize_for_mass_assignment(expected, [:user, :admin])

    Student.expects(:attr_accessible).never

    student.sanitize_for_mass_assignment(expected, [:user, :admin])
  end

  def test_fall_to_defaut_if_not_existent_role_was_passed
    student = Student.new
    expected = { 'phone_number' => 'buz' }

    Student.expects(:attr_accessible).never

    student.sanitize_for_mass_assignment(
      expected.update('name' => 'foo', 'email' => 'bar'),
      [:user, :admin, :not_existent]
    )
  end

  def test_do_not_fail_and_use_DEFAULT_if_wrong_data_type_was_passed_as_role
    student = Student.new
    expected = { 'phone_number' => 'buz' }
    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'), {wrong: 'data type'})
    assert_equal expected, sanitized
  end

end
