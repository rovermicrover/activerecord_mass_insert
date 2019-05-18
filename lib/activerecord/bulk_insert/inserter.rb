require 'forwardable'
require 'securerandom'

module ActiveRecord
  module BulkInsert
    class Inserter
      extend Forwardable

      attr_reader :model, :payload, :columns, :mapped_columns

      def initialize(model, **data, *columns, **mapped_columns)
        @model = model
        @payload = data[:json].presence || (data[:hashes].presence || data[:objects].presence).to_json
        @columns = columns
        @mapped_columns = mapped_columns
      end

      def_delegators :model, :column_for_attribute, :arel_table

      def insert_statement
        Arel::Nodes::InsertStatement.new.tap do |insert_manager|
          insert_manager.relation = arel_table
          insert_manager.values = values
          insert_manager.columns = insert_columns
        end
      end

      def insert_columns
        [
          *columns.map { |column| arel_table[column] },
          *mapped_columns.map { |column, mapping| arel_table[column] }
        ]
      end

      def projection_table_name
        @projection_table_name ||= ['json_projection', SecureRandom.hex].join('_')
      end

      def values
        Arel::Nodes::NamedFunction.new('json_to_recordset', [Arel::Nodes::SqlLiteral.new('?')]).as(

        )
      end
    end
  end
end