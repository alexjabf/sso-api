# frozen_string_literal: true

# This is the ContactMessageController class
module Scopes
  extend ActiveSupport::Concern

  class_methods do
    def records(params: { sort_by: :id, order: :desc, page: 1, per_page: 20 })
      sanitized_sort, sanitized_per_page, sanitized_direction, sanitized_page, = sanitized_params(params)
      paginate(page: sanitized_page, per_page: sanitized_per_page).order("#{sanitized_sort} #{sanitized_direction}")
    end

    def sanitized_params(params)
      [sanitize_params(params[:sort_by]&.to_sym, :id), sanitize_params(params[:per_page]&.to_i, 20),
       sanitize_params(params[:order]&.to_sym, :desc), sanitize_params(params[:page]&.to_i, 1)]
    end

    def sanitize_params(param, default_value)
      return default_value if param.nil? || param.blank?

      sanitized_param = ActiveRecord::Base.sanitize_sql(param)
      return sanitized_param if sanitized_param.is_a?(Integer) && sanitized_param.positive?

      sanitized_value(sanitized_param, default_value)
    end

    def sanitized_value(sanitized_param, default_value)
      if default_value == :id
        column_names.map(&:to_sym).include?(sanitized_param) ? sanitized_param : default_value
      elsif %i[asc desc].include?(default_value)
        %i[asc desc].include?(sanitized_param) ? sanitized_param : default_value
      end
    end
  end
end
