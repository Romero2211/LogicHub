class CommentMailer < ApplicationMailer
  # Лист автору поста: хтось залишив новий коментар.
  # Виклик: CommentMailer.with(comment: comment).new_comment.deliver_later
  def new_comment
    @comment = params[:comment]
    @post = @comment.post
    @author = @post.user
    @commenter = @comment.user

    mail(
      to: @author.email,
      subject: "Новый комментарий к посту «#{@post.title.truncate(60)}»"
    )
  end
end
