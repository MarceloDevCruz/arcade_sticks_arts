require "wisper/sidekiq"

# Ruby 3.1+ blocks YAML.load for !ruby/class tags used by wisper-sidekiq.
# Keep the original broadcast/serialize flow; only fix deserialization.
module Wisper
  class SidekiqBroadcaster
    class Worker
      def perform(yml)
        subscriber, event, args = ::YAML.unsafe_load(yml)
        subscriber.public_send(event, *args)
      end
    end
  end
end

Rails.application.reloader.to_prepare do
  Wisper.clear if Rails.env.development?

  Wisper.subscribe(Psd::FilesListeners::ParsePsd, async: true)
end
