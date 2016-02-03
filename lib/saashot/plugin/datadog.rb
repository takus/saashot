require 'dogapi'

class SaaShot
  class Plugin
    class Datadog

      def initialize(config = {})
        config["dd_api_key"] ||= ENV["DD_API_KEY"]
        config["dd_app_key"] ||= ENV["DD_APP_KEY"]

        api_key, app_key = config.values_at("dd_api_key", "dd_app_key")
        raise 'API Key does not exist' unless api_key
        raise 'APP Key does not exist' unless app_key
        @client = Dogapi::Client.new(api_key, app_key)
      end

      def pull
        monitors = []
        @client.get_all_monitors()[1].each do |raw|
          m = Hash.new
          %W{id name message type query tags options}.each do |k|
            m[k] = raw[k]
          end
          m["key"] = m["name"]
          monitors << m
        end
        monitors
      end

      def push(state)
        raise NotImplementedError
      end

      def diff(old, new)
        changes = []
        (old.keys + new.keys).uniq.each do |k|
          hash_diff = HashDiff.diff(old[k], new[k])
          if hash_diff.size > 0
            changes << {
              "service" => "datadog",
              "name" => new[k] ? new[k]["name"] : old[k]["name"],
              "diff" => hash_diff,
              "old"  => old[k],
              "new"  => new[k],
            }
          end
        end
        changes
      end

    end
  end
end

