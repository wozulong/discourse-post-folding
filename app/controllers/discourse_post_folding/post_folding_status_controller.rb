# frozen_string_literal: true

module ::DiscoursePostFolding
  class PostFoldingStatusController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    def create
      unless guardian.can_fold_post?
        return(
          render json: { success: false, message: "no permisson", post_id: post.id }, status: 403
        )
      end

      post = ::Post.find_by(id: params[:id].to_i)

      if post.post_number == 1
        return(
          render json: { success: false, message: "cannot fold op", post_id: post.id }, status: 403
        )
      end

      if post.nil?
        return(
          render json: {
                   success: false,
                   message: "no such post",
                   post_id: params[:id],
                 },
                 status: 404
        )
      end

      if PostFoldingStatus.find_by(post_id: post.id).present?
        return(
          render json: { success: false, message: "already folded", post_id: post.id }, status: 403
        )
      end

      ps = PostFoldingStatus.create!(post_id: post.id, user_id: current_user.id)

      post_folding_status = PostFoldingStatusSerializer.new(ps).as_json(root: false)

      ::MessageBus.publish(
        "/discourse-post-folding/topic/#{post.topic_id}",
        { post_id: post.id, post_folding_status: },
      )

      render json: { success: true, post_id: post.id, post_folding_status: }
    end

    def destroy
      unless guardian.can_fold_post?
        return(
          render json: { success: false, message: "no permisson", post_id: post.id }, status: 403
        )
      end

      post = Post.find_by(id: params[:id])
      ps = PostFoldingStatus.find_by(post_id: post.id)

      if ps.present?
        ps.destroy!
        render json: { success: true, message: "succeed", post_id: post.id }
      else
        render json: { success: false, message: "already unfolded", post_id: post.id }, status: 404
      end
    end
  end
end
