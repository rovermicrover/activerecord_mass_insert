# frozen_string_literal: true

module ActiveRecord
  module BulkInsert
    # Helper for adding bulk_insert to ActiveRecord::Base
    module Helper
      def bulk_insert(payload, *matching_columns, **mapped_columns)
        Inserter.new(self, payload, *matching_columns, **mapped_columns).insert
      end
    end
  end
end

ActiveRecord::Base.extend(ActiveRecord::BulkInsert::Helper)
