[![CircleCI](https://circleci.com/gh/rovermicrover/activerecord_mass_insert.svg?style=svg)](https://circleci.com/gh/rovermicrover/activerecord_mass_insert)

[![Maintainability](https://api.codeclimate.com/v1/badges/88fdc770f138c6ae5eb5/maintainability)](https://codeclimate.com/github/rovermicrover/activerecord_mass_insert/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/88fdc770f138c6ae5eb5/test_coverage)](https://codeclimate.com/github/rovermicrover/activerecord_mass_insert/test_coverage)

## Installation

Requires Postgresql 9.5+

ActiveRecord >= 4.2 supported and tested.

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_mass_insert'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord_mass_insert

## Usage

```ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend ActiveRecord::MassInsert::Helper
end

class Dog < ApplicationRecord
end

payload = '[{"name":"Madison","breed":"Golden","meta":{"rescue":false,"age":null}},{"name":"Daisy","meta":{"rescue":true,"age":18}},{"name":"Gracey","meta":{"rescue":false,"nickname":"Scoogie","age":11}},{"name":"Sadie","meta":{"rescue":true,"dingo_blood":true,"age":11}},{"name":"Raymond","meta":{"rescue":null,"nickname":"Radar","tail":false,"age":11}},{"name":"Nemo","meta":{"rescue":true,"number_of_ears":1,"age":2}}]'

dog_ids = Dog.mass_insert(payload)

dogs = Dog.find(dog_ids)

puts dogs.count # => 6
puts dogs.first.name # => Madison
puts dogs.first.breed # => Golden
puts dogs.first.meta # => { "rescue" => false, "age" => null }
```

For a payload you can pass a JSON objects by itself, in a JSON array, or a ruby array. You can also
pass a ruby object that responds to to_json by itself or in an array. nil payload is treated as an empty
json array. JSON will never be parsed to ruby. This done to ensure no time is wasted parsing json twice.

## Development

Requires Postgresql 9.5+

After checking out the repo, run `gem install bundle`, then `bundle install`, and run `bin/setup` to install dependencies. Then, run `bundle exec appraisal rspec` to run the tests, this includes the lints. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run the performance test call `bundle exec ruby spec/performance.rb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rovermicrover/activerecord_mass_insert.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).