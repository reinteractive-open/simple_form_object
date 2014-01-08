# SimpleFormObjects

Allows you to make really simple non-persisted form objects or models.

**Only suitable for Rails 4 applications.**

You don't need to remember to:

1. `include ActiveModel::Model`
2. Set the class `model_name` so Rails url generation works for forms.

It gives you:

1. Default values for your form attributes.
2. Integration with simple_form so you don't need to specify the field type on the form.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_form_objects'
```

And then execute:

    $ bundle

## Usage

Create a form class. I like to put them inside `app/forms/`. If you
prefer to create models then that will work too.

```ruby
class PostForm
  include SimpleFormObject

  attribute :body, :text
  attribute :title, :string
  attribute :publish_date, :datetime, default: Time.now
end
```

`SimpleFormObject` includes `ActiveModel::Model` so you don't need to.
It also intelligently sets the `model_name` on the class so that Rails
routing works as expected. As an example:

```erb
<%= simple_form_for @post_form do |f| %>
  <%= f.input :title        # renders a simple string input %>
  <%= f.input :body         # renders a textarea %>
  <%= f.input :publish_date # renders a datetime select html element %>
<% end %>
```

Will create a HTML form which will `POST` to `posts_path`.

## Todo:

1. Automatically add good validations for types.
2. It's tested in `spec` but better tests wouldn't hurt.

## Contributing

1. Fork it ( http://github.com/reInteractive-open/simple_form_objects/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
