class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :require_post_owner, only: %i[edit update destroy]

  def require_post_owner
    if @post.user != current_user
      redirect_to posts_path, alert: "Вы не можете редактировать этот пост"
    end
  end

  def index
    @query = params[:q].to_s.strip
    @sort = Post::SORTS.key?(params[:sort]) ? params[:sort] : "newest"
    posts = Post.search(@query).sorted_by(@sort).with_attached_image
    @pagy, @posts = pagy(:offset, posts, limit: 10)
  end

  def show
    @comment_sort = Comment::SORTS.key?(params[:comment_sort]) ? params[:comment_sort] : "newest"
    @comments = @post.comments.includes(:user, :likes).sorted_by(@comment_sort)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      Rails.cache.delete('posts_count')
      redirect_to @post, notice: "Пост опубликован"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    purge_image_if_requested

    if @post.update(post_params)
      redirect_to @post, notice: "Пост обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Пост удалён"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :category, :source_url, :image)
  end

  def purge_image_if_requested
    return unless params.dig(:post, :remove_image) == "1"
    return if params.dig(:post, :image).present?

    @post.image.purge if @post.image.attached?
  end
end
