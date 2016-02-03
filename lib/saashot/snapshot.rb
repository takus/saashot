class SaaShot
  class Snapshot

    def initialize(config = {})
      raise "'name' does not exist" unless config["name"]
      raise "'path' does not exist" unless config["path"]

      @path = config["path"]

      require "saashot/plugin/#{config['name']}"
      class_name = "SaaShot::Plugin::#{camelize(config['name'])}"
      @plugin = Object.const_get(class_name).new(config)
    end

    def pull
      @plugin.pull
    end

    def push
      @plugin.push
    end

    def store
      state = self.pull
      open(@path, "w") do |f|
        Psych.dump(state, f, :line_width => 256)
      end
    end

    def load
      Psych.load_file(@path) || []
    end

    def diff
      old = Hash[self.load.map { |o| [o["key"], o] }]
      new = Hash[self.pull.map { |o| [o["key"], o] }]
      @plugin.diff(old, new)
    end

	private
	def camelize(string)
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { $2.capitalize }
      string.gsub!(/\//, '::')
      string
    end
  end
end
