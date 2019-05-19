# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'insert and maps correctly' do
  it 'should result in the correct number of rows mapped correct' do
    expect { new_dogs }.to change(Dog, :count).by(dogs.length)
    new_dogs.each_with_index do |new_dog, index|
      dog = dogs.dig(index)
      dog_meta = dog[:meta]
      # Direct and nested data should all map to columns correctly
      expect(new_dog.name).to eq dog[:name]
      expect(new_dog.nickname).to eq dog_meta[:nickname]
      # Note PG < 11 does not have direct JSON boolean to boolean or JSON integer to integer cast
      # support.
      expect(new_dog.rescue).to be dog_meta[:rescue]
      expect(new_dog.age).to be dog_meta[:age]
      # All of meta should be stored as a jsonb field and match up.
      expect(new_dog.meta).to eq dog_meta.map { |k, v| [k.to_s, v] }.to_h
      # Event though some fixtures have breed it is not mapped and thus should not be set.
      expect(new_dog.breed).to be nil
    end
  end
end

RSpec.describe ActiveRecord::BulkInsert do
  let(:dog_fixture) do
    DogFixture.dogs
  end

  let(:matching_columns) { %i[name meta] }
  let(:mapped_columns) do
    {
      nickname: nickname_mapping, rescue: rescue_mapping, age: age_mapping,
      created_at: Arel::Nodes::NamedFunction.new('NOW', []), updated_at: 'NOW()'
    }
  end

  let(:nickname_mapping) do
    lambda { |arel_table, column|
      Arel::Nodes::InfixOperation.new(
        '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
      )
    }
  end

  let(:rescue_mapping) do
    lambda { |arel_table, column|
      inner_sql = Arel::Nodes::InfixOperation.new(
        '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
      ).as(
        Arel::Nodes::SqlLiteral.new('boolean')
      )

      Arel::Nodes::NamedFunction.new('CAST', [inner_sql])
    }
  end

  let(:age_mapping) do
    lambda { |arel_table, column|
      inner_sql = Arel::Nodes::InfixOperation.new(
        '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
      ).as(
        Arel::Nodes::SqlLiteral.new('integer')
      )

      Arel::Nodes::NamedFunction.new('CAST', [inner_sql])
    }
  end

  let(:new_dog_ids) do
    Dog.bulk_insert(payload, *matching_columns, **mapped_columns)
  end

  let(:new_dogs) do
    Dog.find(new_dog_ids)
  end

  context 'raw json' do
    context 'one dog' do
      let(:dogs) { dog_fixture.first(1) }
      let(:payload) { dogs.first.to_json }
      include_examples 'insert and maps correctly'
    end

    context 'many dogs' do
      let(:dogs) { dog_fixture }
      let(:payload) { dogs.to_json }
      include_examples 'insert and maps correctly'
    end
  end

  context 'hash' do
    context 'one dog' do
      let(:dogs) { dog_fixture.first(1) }
      let(:payload) { dogs.first }
      include_examples 'insert and maps correctly'
    end

    context 'many dogs' do
      let(:dogs) { dog_fixture }
      let(:payload) { dogs }
      include_examples 'insert and maps correctly'
    end
  end

  context 'array of json' do
    context 'many dogs' do
      let(:dogs) { dog_fixture }
      let(:payload) { dogs.map(&:to_json) }
      include_examples 'insert and maps correctly'
    end
  end

  context 'rubocop' do
    let(:report) { `bundle exec rubocop` }

    it 'has no offenses' do
      expect(report).to match(/no\ offenses\ detected/)
    end
  end

  context 'brakeman' do
    let(:report) do
      `bundle exec brakeman -q --force-scan --add-libs-path ./lib/`
    end

    it 'has no offenses' do
      expect(report).to match(/No\ warnings\ found/)
    end
  end
end
