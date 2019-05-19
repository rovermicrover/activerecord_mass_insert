# frozen_string_literal: true

require 'forwardable'

module ActiveRecord
  module MassInsert
    # Handles the building of the mass insert statement
    class Inserter < Statement
      extend Forwardable

      def_delegators :model, :primary_key, :arel_table, :connection

      def self.insert(*args)
        new(*args).insert
      end

      def insert
        connection.execute(sql)
      end

      def sql
        [
          model.send(:sanitize_sql_array, [statement.to_sql, payload]),
          'RETURNING',
          primary_key
        ].join(' ')
      end

      def statement
        Arel::Nodes::InsertStatement.new.tap do |new_statement|
          new_statement.relation = arel_table
          new_statement.values = projection.statement
          new_statement.columns = columns
        end
      end

      def columns
        matching_columns.concat(mapped_columns.keys).map do |column|
          arel_table[column]
        end
      end

      def projection
        Projection.new(model, payload, *matching_columns, **mapped_columns)
      end
    end
  end
end
