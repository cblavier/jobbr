module Jobbr

  class OhmPagination

    attr_accessor :array, :current_page, :limit_value, :total_items, :sort_by, :order

    def initialize(array)
      @array = array
      @total_items = array.count
    end

    def page(page)
      @current_page = [page.to_i, 1].max
      self
    end

    def sort_by(sort_by)
      @sort_by = sort_by
      self
    end

    def order(order)
      @order = order
      self
    end

    def per(limit_value)
      @limit_value = limit_value.to_i
      self
    end

    def total_pages
      @total_pages ||= (total_items.to_f / limit_value).ceil
    end

    def each
      return unless block_given?
      limit_start = (current_page - 1) * limit_value
      array.sort_by(@sort_by, order: @order, limit: [limit_start, limit_value]).each do |item|
        yield(item)
      end
    end

  end

end