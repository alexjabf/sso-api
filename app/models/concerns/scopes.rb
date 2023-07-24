# frozen_string_literal: true

# This is the ContactMessageController class
module Scopes
  extend ActiveSupport::Concern

  class_methods do
    def search(params:, valid_search: false)
      results = params.map do |key, value|
        next if value.blank? || search_fields.exclude?(key.to_sym)

        valid_search = true
        filter_by_key(key, value).pluck(:id)
      end.compact.flatten.uniq

      collect_records(params, results, valid_search)
    end

    def filter_by_key(key, value)
      where("LOWER(#{key}) LIKE ?", "%#{sanitize_sql_like(value).downcase}%")
    end

    private

    def collect_records(params, results, valid_search)
      data = records(params: params.except!(*search_fields).to_h.deep_symbolize_keys)
      valid_search ? data.where(id: results) : data
    end

    def search_fields
      column_names.map(&:to_sym)
    end
  end

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
