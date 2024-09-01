# frozen_string_literal: true

DiscoursePostFolding::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DiscoursePostFolding::Engine, at: "discourse-post-folding" }
