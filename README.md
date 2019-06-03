[![CircleCI](https://circleci.com/gh/rovermicrover/activerecord_mass_insert.svg?style=svg)](https://circleci.com/gh/rovermicrover/activerecord_mass_insert) [![Maintainability](https://api.codeclimate.com/v1/badges/88fdc770f138c6ae5eb5/maintainability)](https://codeclimate.com/github/rovermicrover/activerecord_mass_insert/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/88fdc770f138c6ae5eb5/test_coverage)](https://codeclimate.com/github/rovermicrover/activerecord_mass_insert/test_coverage)

## Purpose
Mass Insert For ActiveRecord via Postgresql json_to_recordset. Can handle raw JSON directly into Postgresql. With the ability to declare mappings directly in Postgresql.

## Installation

Requires Postgresql 9.5+

ActiveRecord >= 4.2 supported and tested.

Ruby >= 2.5 supported and tested. Though Ruby >= 2.3 should work, they are currently untested.

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
```

For a payload you can pass a JSON objects by itself, in a JSON array, or a ruby array. You can also
pass a ruby object that responds to to_json by itself or in an array. nil payload is treated as an empty
json array. JSON will never be parsed to ruby. This done to ensure no time is wasted parsing json twice.

### Payload As JSON Array

```ruby
payload <<-JSON    
  [
    {"name":"Madison","breed":"Golden","meta":{"rescue":false,"age":null}},
    {"name":"Daisy","meta":{"rescue":true,"age":18}},
    {"name":"Gracey","meta":{"rescue":false,"nickname":"Scoogie","age":11}},
    {"name":"Sadie","meta":{"rescue":true,"dingo_blood":true,"age":11}},
    {"name":"Raymond","meta":{"rescue":null,"nickname":"Radar","tail":false,"age":11}},
    {"name":"Nemo","meta":{"rescue":true,"number_of_ears":1,"age":2}}
  ]
JSON

dog_ids = Dog.mass_insert(payload)
```

### Payload As Ruby Array Of JSON Objects

```ruby
payload = [
  '{"name":"Madison","breed":"Golden","meta":{"rescue":false,"age":null}}',
  '{"name":"Daisy","meta":{"rescue":true,"age":18}}',
  '{"name":"Gracey","meta":{"rescue":false,"nickname":"Scoogie","age":11}}',
  '{"name":"Sadie","meta":{"rescue":true,"dingo_blood":true,"age":11}}',
  '{"name":"Raymond","meta":{"rescue":null,"nickname":"Radar","tail":false,"age":11}}',
  '{"name":"Nemo","meta":{"rescue":true,"number_of_ears":1,"age":2}}',
]

dog_ids = Dog.mass_insert(payload)
```

### Payload As Ruby Array Of Ruby Objects That Responds To to_json

```ruby
payload = [
  { name: 'Madison', breed: 'Golden', meta: { rescue: false, age: nil } },
  { name: 'Daisy', meta: { rescue: true, age: 18 } },
  { name: 'Gracey', meta: { rescue: false, nickname: 'Scoogie', age: 11 } },
  { name: 'Sadie', meta: { rescue: true, dingo_blood: true, age: 11 } },
  { name: 'Raymond', meta: { rescue: nil, nickname: 'Radar', tail: false, age: 11 } },
  { name: 'Nemo', meta: { rescue: true, number_of_ears: 1, age: 2 } },
]

dog_ids = Dog.mass_insert(payload)
```

### Results For All

```ruby
dogs = Dog.find(dog_ids)

puts dogs.count # => 6
puts dogs.first.name # => Madison
puts dogs.first.breed # => Golden
puts dogs.first.meta # => { "rescue" => false, "age" => null }
```

## Mappings

You can also delcare your mappings. 

The second argument of mass_insert is an array of directly one to one mapped columns.

The third argument of mass_insert is a hash of column names to either lambda that return an arel statement, an arel node, or a string.

```ruby
Dog.mass_insert(
  payload,
  # Directly mapped columns for name (string) and meta (jsonb)
  :name, :meta, 
  # Inspect the meta json object to pull out nickname (string)
  nickname: lambda { |arel_table, column|
    Arel::Nodes::InfixOperation.new(
      '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
    )
  },
  # Inspect the meta json object to pull out rescue (boolean)
  rescue: lambda { |arel_table, column|
    inner_sql = Arel::Nodes::InfixOperation.new(
      '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
    ).as(
      Arel::Nodes::SqlLiteral.new('boolean')
    )

    Arel::Nodes::NamedFunction.new('CAST', [inner_sql])
  },
  # Inspect the meta json object to pull out age (integer)
  age: lambda { |arel_table, column|
    inner_sql = Arel::Nodes::InfixOperation.new(
      '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
    ).as(
      Arel::Nodes::SqlLiteral.new('integer')
    )

    Arel::Nodes::NamedFunction.new('CAST', [inner_sql])
  },
  # For less complex mappings you can use a simple Arel::Node or a String
  created_at: Arel::Nodes::NamedFunction.new('NOW', []), updated_at: 'NOW()'
 )
```

## Development

Requires Postgresql 9.5+

After checking out the repo, run `gem install bundle`, then `bundle install`, and run `bin/setup` to install dependencies. Then, run `bundle exec appraisal rspec` to run the tests, this includes the lints. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run the performance test call `bundle exec ruby spec/performance.rb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rovermicrover/activerecord_mass_insert.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
