# frozen_string_literal: true

module ::DiscoursePostFolding
  class PostFoldingStatus < ::ActiveRecord::Base
    belongs_to :post
    belongs_to :user
  end
end
