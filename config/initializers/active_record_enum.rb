# frozen_string_literal: true

# This is to override the default error message for enum validation
module ActiveRecord
  # This is the main module
  module Enum
    # This is the main Type module
    class EnumType < Type::Value
      def assert_valid_value(value)
        return if value.blank? || mapping.key?(value) || mapping.value?(value)

        "#{value} is not included in the list"
      end
    end
  end
end
