# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
# ... suas configurações existentes ...

    config.active_job.queue_adapter = :sidekiq
end
