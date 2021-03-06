require 'mongoid'
require 'will_paginate/collection'

module WillPaginateMongoid

  DEFAULT_PER_PAGE = 10

  module MongoidPaginator
    extend ActiveSupport::Concern

    included do
      def self.paginate(options = {})
        options = base_options options

        WillPaginate::Collection.create(options[:page], options[:per_page]) do |pager|
          fill_pager_with self.skip(options[:offset]).limit(options[:per_page]), self.count, pager
        end
      end

      private

      def self.base_options(options)
        options[:page] ||= 1
        options[:per_page] ||= 10
        options[:offset] = (options[:page].to_i - 1) * options[:per_page]
        options
      end

      def self.fill_pager_with(medias, size, pager)
        pager.replace medias.to_a
        pager.total_entries = size
      end
    end
  end
end

Mongoid::Document.send :include, WillPaginateMongoid::MongoidPaginator
Mongoid::Criteria.send :include, WillPaginateMongoid::MongoidPaginator