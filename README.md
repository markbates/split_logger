# SplitLogger
[![Build Status](https://travis-ci.org/markbates/split_logger.png)](https://travis-ci.org/markbates/split_logger) [![Code Climate](https://codeclimate.com/github/markbates/split_logger.png)](https://codeclimate.com/github/markbates/split_logger)

This gem let's you write to multiple log destinations at the same time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'split_logger'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install split_logger
```

## Usage

You can set up loggers in one of two ways:

```ruby
logger = SplitLogger.new
logger.add(std: Logger.new(STDOUT))
logger.add(file: Logger.new("/path/to/log"))
logger.level = ::Logger::INFO

logger.info "Hello Logs"
```

or you can pass them all into the initializer:

```ruby
logger = SplitLogger.new({
  std: Logger.new(STDOUT),
  file: Logger.new("/path/to/log")
})
logger.level = ::Logger::INFO

logger.info "Hello Logs"
```

### Rails

By default the Rails logger is automatically added when creating a new `SplitLogger`.

Of course, if you don't want the Rails logger it can easily be removed.

```ruby
logger.remove(:rails_default_logger)
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/split_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
