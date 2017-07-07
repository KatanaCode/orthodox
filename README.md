# Orthodox

Replacement Rails generators for Katana apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'orthodox', github: "katana/orthodox"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install orthodox

## Usage

### An empty controller:

    rails g controller users

Creates:

    class Users < ApplicationController

    end


### A controller with prepopulated actions:

    rails g controller users new create show

Creates:

    class Users < ApplicationController

      def new
        @user = users_scope.new
      end

      def create
        @user = users_scope.new(user_params)
        if @user.save
          redirect_to(user_url(@user), notice: "Successfully created user")
        else
          render :new
        end
      end

      def show
        @user = users_scope.find(params[:id])
      end


      private


      def users_scope
        User.all
      end

      def user_params
        params.require(:user).permit()
      end

    end

### A controller with actions and authentication:

    rails g controller users new create show --authenticate admin
    
Creates:

    class Users < ApplicationController

      before_action :authenticate_admin!


      def new
        @user = users_scope.new
      end

      def create
        @user = users_scope.new(user_params)
        if @user.save
          redirect_to(user_url(@user), notice: "Successfully created user")
        else
          render :new
        end
      end

      def show
        @user = users_scope.find(params[:id])
      end




      private


      def users_scope
        User.all
      end

      def user_params
        params.require(:user).permit()
      end

    end

### A controller with a namespace:

    rails g controller admins/users new create show --authenticate admin

Creates:

    class Admins::Users < Admins::BaseControler

      before_action :authenticate_admin!


      def new
        @user = users_scope.new
      end

      def create
        @user = users_scope.new(user_params)
        if @user.save
          redirect_to(user_url(@user), notice: "Successfully created user")
        else
          render :new
        end
      end

      def show
        @user = users_scope.find(params[:id])
      end


      private


      def users_scope
        User.all
      end

      def user_params
        params.require(:user).permit()
      end

    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KatanaCode/orthodox.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
