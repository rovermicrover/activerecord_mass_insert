# frozen_string_literal: true

module ActiveRecord
  module MassInsert
    # Common structure for all SQL statement builders
    class Statement
      def initialize(model, payload, *matching_columns, **mapped_columns)
        @model = model
        @payload = payload_to_json_array(payload)
        if matching_columns.empty? && mapped_columns.empty?
          @matching_columns = fallback_matching_columns(model)
          @mapped_columns = fallback_mapped_columns(model)
        else
          @matching_columns = matching_columns
          @mapped_columns = mapped_columns
        end
      end

      private

      attr_reader :model, :payload, :matching_columns, :mapped_columns

      def fallback_matching_columns(new_model)
        new_model.columns.map(&:name) - [new_model.primary_key, 'created_at', 'updated_at']
      end

      def fallback_mapped_columns(new_model)
        {}.tap do |result|
          %w[created_at updated_at].each do |column|
            if new_model.columns_hash.keys.include?(column)
              result[column.to_sym] = Arel::Nodes::NamedFunction.new('NOW', [])
            end
          end
        end
      end

      def payload_to_json_array(new_payload)
        wrap_payload(standardize_payload(new_payload))
      end

      def standardize_payload(new_payload)
        if new_payload.nil?
          new_payload = new_payload.to_s
        elsif new_payload.is_a?(Array) && new_payload.all? { |p| p.is_a?(String) }
          # If payload is an array of strings, assume its an array
          # of json objects. contact them togther to form the
          # inner part of a json array.
          new_payload = new_payload.join(',')
        elsif !new_payload.is_a?(String)
          # Otherwise transform to JSON
          new_payload = new_payload.to_json
        end
      end

      def wrap_payload(new_payload)
        # If payload is not a json array wrap it in brackets to make it so.
        new_payload.start_with?('[') ? new_payload : "[#{new_payload}]"
      end
    end
  end
end
