# frozen_string_literal: true

# name: discourse-post-folding
# about: Allow collapsing some posts
# meta_topic_id: TODO
# version: 0.0.1
# authors: Linca
# url: https://github.com/Lhcfl/discourse-post-folding
# required_version: 3.3.0

enabled_site_setting :discourse_post_folding_enabled

if respond_to?(:register_svg_icon)
  register_svg_icon "expand"
  register_svg_icon "compress"
  register_svg_icon "toggle-off"
  register_svg_icon "toggle-on"
end

register_asset "stylesheets/common/discourse-post-folding.scss"

module ::DiscoursePostFolding
  PLUGIN_NAME = "discourse-post-folding"
end

require_relative "lib/discourse_post_folding/engine"

after_initialize do
  # Code which should run after Rails has finished booting

  reloadable_patch do
    ::Post.prepend ::DiscoursePostFolding::PostFoldingMixin

    ::TopicView.prepend ::DiscoursePostFolding::TopicViewMixin
  end

  add_to_class(:user, :can_fold_post?) do
    in_any_groups? SiteSetting.discourse_post_folding_can_fold_post_groups_map
  end

  add_to_class(:guardian, :can_fold_post?) { user && user.can_fold_post? }

  add_to_serializer(:post, :post_folding_status) do
    ::DiscoursePostFolding::PostFoldingStatusSerializer.new(object.post_folding_status).as_json(
      root: false,
    )
  end

  add_to_serializer(:current_user, :can_fold_post) { object.can_fold_post? }
end
