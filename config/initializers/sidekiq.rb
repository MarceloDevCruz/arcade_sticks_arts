Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    timeout: 15, 
    reconnect_attempts: 5,
    connect_timeout: 10,
    read_timeout: 10,
    write_timeout: 10
  }
end
  
Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    timeout: 15,
    reconnect_attempts: 5,
    connect_timeout: 10,
    read_timeout: 10,
    write_timeout: 10
  }
end