# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveRecord::BulkInsert do
  let(:dogs) do
    [
      { name: 'Madison', meta: { rescue: false } },
      { name: 'Daisy', meta: { rescue: true } },
      { name: 'Gracey', meta: { rescue: false, nickname: 'Scoogie' } },
      { name: 'Sadie', meta: { rescue: true } },
      { name: 'Raymond', meta: { rescue: false, nickname: 'Radar' } },
      { name: 'Nemo', meta: { rescue: true } }
    ]
  end

  let(:matching_columns) { %i[name meta] }
  let(:mapped_columns) do
    {
      nickname: nickname_mapping, rescue: rescue_mapping, created_at: Arel::Nodes::NamedFunction.new('NOW', []),
      updated_at: 'NOW()'
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
      Arel::Nodes::NamedFunction.new('CAST', [
                                       Arel::Nodes::InfixOperation.new(
                                         '->>', arel_table[:meta], Arel::Nodes.build_quoted(column)
                                       ).as(
                                         Arel::Nodes::SqlLiteral.new('Boolean')
                                       )
                                     ])
    }
  end

  let(:new_dog_ids) do
    Dog.bulk_insert(payload, *matching_columns, **mapped_columns)
  end

  context 'raw json' do
    context 'one dog' do
      let(:payload) { dogs.first.to_json }

      it 'can insert' do
        expect { new_dog_ids }.to change(Dog, :count).by(1)
      end
    end

    context 'many dogs' do
      let(:payload) { dogs.to_json }

      it 'can insert many dogs' do
        expect { new_dog_ids }.to change(Dog, :count).by(6)
      end
    end
  end

  context 'hash' do
    context 'one dog' do
      let(:payload) { dogs.first }

      it 'can insert' do
        expect { new_dog_ids }.to change(Dog, :count).by(1)
      end
    end

    context 'many dogs' do
      let(:payload) { dogs }

      it 'can insert many dogs' do
        expect { new_dog_ids }.to change(Dog, :count).by(6)
      end
    end
  end

  context 'array of json' do
    context 'many dogs' do
      let(:payload) { dogs.map(&:to_json) }

      it 'can insert many dogs' do
        expect { new_dog_ids }.to change(Dog, :count).by(6)
      end
    end
  end
end
