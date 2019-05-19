## Installation

Requires Postgresql 9.5+

ActiveRecord >= 4.2 supported and tested.

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_mass_insert'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_mass_insert

## Usage
```ruby
payload = '[{"name":"Madison","breed":"Golden","meta":{"rescue":false,"age":null}},{"name":"Daisy","meta":{"rescue":true,"age":18}},{"name":"Gracey","meta":{"rescue":false,"nickname":"Scoogie","age":11}},{"name":"Sadie","meta":{"rescue":true,"dingo_blood":true,"age":11}},{"name":"Raymond","meta":{"rescue":null,"nickname":"Radar","tail":false,"age":11}},{"name":"Nemo","meta":{"rescue":true,"number_of_ears":1,"age":2}}]'

dog_ids = Dog.mass_insert(payload, :name, created_at: 'NOW()', updated_at: 'NOW()')

dogs = Dog.find(dog_ids)

puts dogs.count # => 6
puts dogs.first.name # => Madison
```

For a payload you can pass a JSON objects by itself, in a JSON array, or a ruby array. You can also
pass a ruby object that responds to to_json by itself or in an array. JSON will never be parsed to ruby.
This done to ensure no time is wasted parsing json twice.

## Development

Requires Postgresql 9.5+

After checking out the repo, run `gem install bundle`, then `bundle install`, and run `bin/setup` to install dependencies. Then, run `bundle exec appraisal rspec` to run the tests, this includes the lints. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rovermicrover/activerecord_mass_insert.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).