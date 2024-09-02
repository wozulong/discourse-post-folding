# frozen_string_literal: true
module DiscoursePostFolding
  module PostFoldingMixin
    extend ActiveSupport::Concern

    prepended do
      has_one :post_folding_status,
              dependent: :destroy,
              class_name: :"::DiscoursePostFolding::PostFoldingStatus"
    end
  end
end
