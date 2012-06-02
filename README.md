# MassAssignmentWithMultipleRoles [![Build Status](https://secure.travis-ci.org/saks/mass_assignment_with_multiple_roles.png)](http://travis-ci.org/#!/saks/mass_assignment_with_multiple_roles)

Quite often your user can have multiple roles at the same time. `ActiveModel` does not provide the ability to sanitize attributes using intersection of `attr_accessible` for several role names at the same time.

This gem is all about to solve this problem.

## Example of usage

Consider we have the following model code:

```ruby
class Student < ActiveRecord::Base

  attr_accessible :phone_number
  attr_accessible :name, as: :admin
  attr_accessible :email, as: :user
end
```


Now, while updating in controller we can write:

```ruby
student = Student.find(params[:id])
if student.update_attributes(params[:student], :as => [:admin, :teacher])
```

Role names can be passed in `ActiveModel` style:
```ruby
student.update_attributes(params[:student], :as => :admin)
```

all it's functionality is fully supported.

Several roles can be passed as an array symbols:
```ruby
student.update_attributes(params[:student], :as => [:admin, :teacher])
```

But in most cases, role names can be obtained from user model. If your user
model provides method called `role_names`, which returns as array of role
names, you can write code which is quite easy to understand.

In model:
```ruby
class User < ActiveRecord::Base
  has_many :roles

  def role_names
    roles.map &:name
  end

end
```

In controller:
```ruby
student.update_attributes(params[:student], :as => current_user)
```


## Installation

Add this line to your application's Gemfile:

    gem 'mass_assignment_with_multiple_roles'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mass_assignment_with_multiple_roles

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
