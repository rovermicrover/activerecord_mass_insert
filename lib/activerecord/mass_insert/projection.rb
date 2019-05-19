# frozen_string_literal: true

require 'forwardable'
require 'securerandom'

module ActiveRecord
  module MassInsert
    # Handles the building of the select statement that projects the JSON array
    class Projection < Statement
      extend Forwardable

      def_delegators :model, :column_for_attribute

      def statement
        init_args = []
        init_args << arel_table.engine if arel_table.respond_to?(:engine)

        Arel::SelectManager.new(*init_args).tap do |select_manager|
          select_manager.project(select)
          select_manager.from(table)
        end
      end

      def select
        [
          *matching_columns.map { |column| arel_table[column] },
          *select_mapped_columns
        ]
      end

      def select_mapped_columns
        mapped_columns.map do |column, mapping|
          mapping = mapping.call(arel_table, column) if mapping.is_a?(Proc)
          case mapping
          when Arel::Nodes::Node
            mapping
          else
            Arel::Nodes::SqlLiteral.new(mapping.to_s)
          end
        end
      end

      def column_sql_definitions
        matching_columns.map do |column|
          column_for_attribute(column)
        end.map do |column_objects|
          [column_objects.name, column_objects.sql_type].join(' ')
        end
      end

      def table_name
        @table_name ||= ['json_projection', SecureRandom.hex].join('_')
      end

      def arel_table
        @arel_table ||= Arel::Table.new(table_name)
      end

      def table
        Arel::Nodes::NamedFunction.new(
          'json_to_recordset', [Arel::Nodes::SqlLiteral.new('?')]
        ).as(
          [table_name, '(', column_sql_definitions.join(', '), ')'].join
        )
      end
    end
  end
end
