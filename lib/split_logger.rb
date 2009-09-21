require 'logger'
Dir.glob(File.join(File.dirname(__FILE__), 'split_logger', '**/*.rb')).each do |f|
  require File.expand_path(f)
end
