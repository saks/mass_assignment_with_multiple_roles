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

  def test_it_falls_to_default_if_no_valid_role_was_passed
    student = Student.new
    expected = { 'phone_number' => 'buz' }

    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'), [])
    assert_equal expected, sanitized

    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'), nil)
    assert_equal expected, sanitized

    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'))
    assert_equal expected, sanitized

    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'), [Object.new])
    assert_equal expected, sanitized
  end

  def test_with_an_array_of_roles_for_attr_accesible
    student = Student.new
    expected = { 'name' => 'buz', 'email' => 'foo' }
    sanitized = student.sanitize_for_mass_assignment(expected, [:user, :admin])
    assert_equal expected, sanitized
  end

  def test_with_an_array_of_roles_for_attr_protected
    student = Teacher.new
    expected = { 'phone_number' => 'bar' }

    sanitized = student.sanitize_for_mass_assignment(
      expected.merge('name' => 'buz', 'email' => 'foo'),
      [:user, :admin]
    )

    assert_equal expected, sanitized
  end

  def test_with_object_that_respond_to_roles_method
    student = Student.new
    user    = OpenStruct.new MassAssignmentWithMultipleRoles::ROLE_NAMES_METHOD => [:user, :admin]

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

  def test_do_not_take_into_account_not_known_roles
    student = Student.new
    expected = { 'name' => 'foo', 'email' => 'bar' }

    sanitized = student.sanitize_for_mass_assignment(
      expected.merge('phone_number' => 'buz'),
      [:user, :admin, :not_existent]
    )

    assert_equal expected, sanitized
  end

  def test_do_not_fail_and_use_DEFAULT_if_wrong_data_type_was_passed_as_role
    student = Student.new
    expected = { 'phone_number' => 'buz' }
    sanitized = student.sanitize_for_mass_assignment(expected.merge('email' => 'bar'), {wrong: 'data type'})
    assert_equal expected, sanitized
  end

end
