class NotifyUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    puts "Уведомление для #{user.email}"
  end
end
