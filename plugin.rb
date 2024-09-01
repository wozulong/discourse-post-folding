# frozen_string_literal: true

# name: discourse-post-folding
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_post_folding_enabled

module ::DiscoursePostFolding
  PLUGIN_NAME = "discourse-post-folding"
end

require_relative "lib/discourse_post_folding/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
