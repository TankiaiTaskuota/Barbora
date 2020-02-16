# frozen_string_literal: true

module Orders
  # Order Import service
  class Import
    def initialize(order, file_path)
      @order = order
      @file_path = file_path
    end

    def call
      t = Time.now.to_i
      files = `pdftohtml -c #{@file_path} /tmp/#{t}.html`
      order = @order.nil? ? Order.check_file(file_off_page(t)) : @order

      if files.to_s.include?('Page-2')
        order.import_nikogiri(file_off_page(t), 1)
        order.import_nikogiri(file_off_page(t, 2), 2)
      else
        order.import_nikogiri(file_off_page(t))
      end
    end

    private

    def file_off_page(time, page = 1)
      "/tmp/#{time}-#{page}.html"
    end
  end
end
