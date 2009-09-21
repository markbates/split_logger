class SplitLogger
  
  attr_accessor :logger_list
  
  def initialize(loggers = {})
    self.logger_list = {}
    loggers.each do |name, logger|
      self.add(name, logger)
    end
    if defined?(RAILS_DEFAULT_LOGGER)
      self.add(:rails_default_logger, RAILS_DEFAULT_LOGGER)
    end
  end
  
  def add(name, logger)
    self.logger_list[name.to_sym] = logger
  end
  
  def remove(name)
    name = name.to_sym
    if self.logger_list.has_key?(name)
      self.logger_list.delete(name)
    end
  end
  
  def list
    self.logger_list
  end
  
  [:debug, :info, :warn, :error, :fatal].each do |level|
    define_method(level) do |*args|
      if self.logger_list.empty?
        logger = ::Logger.new(STDOUT)
        self.add(:default, logger)
        logger.send(level, *args)
      else
        self.logger_list.each do |name, logger|
          begin
            logger.send(level, *args)
          rescue Exception => e
            self.remove(name)
            self.send(level, e.message)
            self.send(level, "Removed logger '#{name}' from the logger list!")
          end
        end
      end
    end
  end
  
end