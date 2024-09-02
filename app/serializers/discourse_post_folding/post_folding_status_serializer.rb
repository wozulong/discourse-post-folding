# frozen_string_literal: true

module ::DiscoursePostFolding
  class PostFoldingStatusSerializer < ::ApplicationSerializer
    attributes :user, :created_at

    def user
      BasicUserSerializer.new(object.user).as_json(root: false)
    end
  end
end
