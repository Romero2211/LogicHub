class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]
  before_action :set_comment, only: %i[edit update destroy]
  before_action :require_comment_owner, only: %i[edit update destroy]

  def require_comment_owner
    if @comment.user != current_user
      redirect_to @comment.post, alert: "Вы не можете редактировать этот комментарий"
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @post, notice: "Комментарий добавлен"
    else
      redirect_to @post, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.post, notice: "Комментарий обновлен"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = @comment.post
    @comment.destroy
    redirect_to @comment.post, notice: "Комментарий удален"
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
