# SaaShot

SaaShot = SaaS + Snapshot

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'saashot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saashot

## Usage

```
# this is config file
cat example.yml
name: datadog
path: /tmp/datadog.snapshot

# saves dumps your SaaS state as Snapshot
saashot pull -c example.yml

# syncs Snapshot to SaaS (e.g. creating / updating / deleting resources)
saashot push -c example.yml

# show differences between Snapshot and SaaS to standard output
saashot diff -c example.yml
---
- service: datadog
  name: test alert
  diff:
  - - "~"
    - options.notify_no_data
    - false
    - true
  old:
    id: 448760
    name: test alert
    message: this is test.
    type: metric alert
    query: avg(last_5m):avg:aws.s3.bucket_size_bytes{*} > 100
    tags: []
    options:
      notify_audit: false
      timeout_h: 0
      silenced: {}
      thresholds:
        critical: 100.0
        warning: 10.0
      notify_no_data: false
      renotify_interval: 0
      no_data_timeframe: 2
    key: test alert
  new:
    id: 448760
    name: test alert
    message: this is test.
    type: metric alert
    query: avg(last_5m):avg:aws.s3.bucket_size_bytes{*} > 100
    tags: []
    options:
      notify_audit: false
      timeout_h: 0
      silenced: {}
      thresholds:
        critical: 100.0
        warning: 10.0
      notify_no_data: true
      renotify_interval: 0
      no_data_timeframe: 2
    key: test alert
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takus/saashot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

