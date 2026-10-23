class NotifyPostJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)

    Rails.logger.info("New post: #{post.title}")
  end
end
