# Sidekiq needs a running Redis (redis://localhost:6379).
# LogicHub uses :async in development and :solid_queue in production,
# so this file stays inactive unless you explicitly switch the adapter.
#
# To use Sidekiq later:
#   1. Start Redis
#   2. Set config.active_job.queue_adapter = :sidekiq
#   3. Uncomment the block below and run: bundle exec sidekiq

# if Rails.application.config.active_job.queue_adapter == :sidekiq
#   Sidekiq.configure_server do |config|
#     config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
#   end
#
#   Sidekiq.configure_client do |config|
#     config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
#   end
# end
