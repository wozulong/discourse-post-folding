# frozen_string_literal: true

DiscoursePostFolding::Engine.routes.draw do
  put "/status/:id" => "post_folding_status#create"
  delete "/status/:id" => "post_folding_status#destroy"
  # define routes here
end

Discourse::Application.routes.draw do
  mount ::DiscoursePostFolding::Engine, at: "discourse-post-folding"
end
