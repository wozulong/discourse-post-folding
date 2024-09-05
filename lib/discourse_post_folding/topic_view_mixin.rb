# frozen_string_literal: true
module DiscoursePostFolding
  module TopicViewMixin
    extend ActiveSupport::Concern

    prepended do
      private

      alias_method :setup_filtered_posts_old, :setup_filtered_posts

      def setup_filtered_posts
        setup_filtered_posts_old

        # Filter replies
        return if @replies_to_post_number.present?

        # Username filters
        return if @username_filters.present?

        if SiteSetting.discourse_post_folding_enabled && @filter.to_s != "unfold_all"
          @contains_gaps = true
          @filtered_posts =
            @filtered_posts.where(
              "posts.id NOT IN (SELECT fd.post_id FROM discourse_post_folding_post_folding_statuses fd)",
            )
        end
      end
    end
  end
end
