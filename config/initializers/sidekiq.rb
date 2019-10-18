require 'sidekiq/web'

redis_config = {
  host: Rails.application.secrets[:redis_host],
  port: Rails.application.secrets[:redis_port],
  db: 2
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.default_worker_options = { retry: 10 }
