# frozen_string_literal: true

module ActiveRecord
  module MassInsert
    # Common structure for all SQL statement builders
    class Statement
      attr_reader :model, :payload, :matching_columns, :mapped_columns

      def initialize(model, payload, *matching_columns, **mapped_columns)
        @model = model
        @payload = payload_to_json_array(payload)
        @matching_columns = matching_columns
        @mapped_columns = mapped_columns
      end

      private

      def payload_to_json_array(new_payload)
        if new_payload.is_a?(Array) && new_payload.all? { |p| p.is_a?(String) }
          # If payload is an array of strings, assume its an array
          # of json objects. contact them togther to form the
          # inner part of a json array.
          new_payload = new_payload.join(',')
        elsif !new_payload.is_a?(String)
          # Otherwise transform to JSON
          new_payload = new_payload.to_json
        end
        # If payload is not a json array wrap it in brackets to make it so.
        new_payload.start_with?('[') ? new_payload : "[#{new_payload}]"
      end
    end
  end
end
