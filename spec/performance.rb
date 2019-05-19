# frozen_string_literal: true

require 'bundler/setup'
load 'spec/spec_helper.rb'
require 'benchmark'
require 'json'

dogs_ruby_ruby = DogFixture.random_dogs.take(10_000)
dogs_ruby_json = dogs_ruby_ruby.map(&:to_json)
dogs_json_json = dogs_ruby_ruby.to_json

puts 'Test of 10,000 Row Inserts Through Different Methods'

Benchmark.bm do |benchmark|
  benchmark.report('JSON Parse One At A Time - Individual Model Create') do
    dogs_ruby_json.map { |json| Dog.create(JSON.parse(json)).id }
  end

  benchmark.report('Ruby Array Ruby Hash - Mass Insert') do
    Dog.mass_insert(dogs_ruby_ruby)
  end

  benchmark.report('Ruby Array Ruby Hash - Mass Insert In Batches') do
    dogs_ruby_ruby.each_slice(1000) do |batch|
      Dog.mass_insert(batch)
    end
  end

  benchmark.report('Ruby Array JSON Object - Mass Insert') do
    Dog.mass_insert(dogs_ruby_json)
  end

  benchmark.report('Ruby Array JSON Object - Mass Insert In Batches') do
    dogs_ruby_json.each_slice(1000) do |batch|
      Dog.mass_insert(batch)
    end
  end

  benchmark.report('JSON Array JSON Object Mass Insert') do
    Dog.mass_insert(dogs_json_json)
  end
end
