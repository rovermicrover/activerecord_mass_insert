# frozen_string_literal: true

module ActiveRecord
  module MassInsert
    # Helper for adding mass_insert to ActiveRecord::Base
    module Helper
      def mass_insert(payload, *matching_columns, **mapped_columns)
        Inserter.insert(
          self, payload, *matching_columns, **mapped_columns
        ).to_a.map { |result| result['id'] }
      end
    end
  end
end
