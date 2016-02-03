require 'thor'

class SaaShot
  class CLI < Thor

    class_option :config,
      :aliases => ["c"],
      :default => "saashot.yml",
      :type    => :string

    desc "pull", "pull SaaS states"
    def pull
      config = Psych.load_file(options[:config])
      SaaShot::Snapshot.new(config).store
    end

    desc "push", "push SaaS states"
    def push
      config = Psych.load_file(options[:config])
      SaaShot::Snapshot.new(config).push
    end

    desc "diff", "compare SaaS states"
    option :format,
      :aliases => ["f"],
      :default => "yaml",
      :type    => :string
    def diff
      config = Psych.load_file(options[:config])
      diff = SaaShot::Snapshot.new(config).diff
      if diff.size > 0
        puts format(diff, options[:format])
      end
    end

    private
    def format(obj, format = "yaml")
      case format
      when 'yaml'
        return obj.to_yaml
      when 'json'
        return obj.to_json
      else
        raise "Unknown output format"
      end
    end

  end
end
