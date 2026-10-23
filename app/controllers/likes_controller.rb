class LikesController < ApplicationController
  before_action :require_login
  before_action :set_likeable

  def create
    current_user.likes.find_or_create_by!(likeable: @likeable)
    respond_like
  end

  def destroy
    current_user.likes.find_by(likeable: @likeable)&.destroy
    respond_like
  end

  private

  def set_likeable
    @likeable = if params[:post_id]
      Post.find(params[:post_id])
    else
      Comment.find(params[:comment_id])
    end
  end

  def respond_like
    @likeable.likes.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: likeable_redirect }
    end
  end

  def likeable_redirect
    @likeable.is_a?(Comment) ? @likeable.post : @likeable
  end
end
