require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe SplitLogger do

  it 'should use a default logger if none is added' do
    log = mock('logger')
    log.should_receive(:error).with('hi!')
    Logger.should_receive(:new).with(STDOUT).and_return(log)
    sp = SplitLogger.new
    sp.list.size.should == 0
    sp.error('hi!')
  end

  describe 'add' do
    
    it 'should add a logger to the list' do
      sp = SplitLogger.new
      sp.list.size.should == 0
      sp.add(:std, Logger.new(STDOUT))
      sp.list.size.should == 1
    end
    
  end
  
  describe 'list' do
    
    it 'should return a list of all loggers' do
      sp = SplitLogger.new
      std = mock('std logger')
      sp.add(:std, std)
      sp.list.should == {:std => std}
    end
    
  end
  
  describe 'remove' do
    
    it 'should remove a logger from the list' do
      sp = SplitLogger.new
      std = mock('std logger')
      sp.add(:std, std)
      other = mock('other logger')
      sp.add(:other, other)
      sp.list.should == {:std => std, :other => other}
      sp.remove(:other)
      sp.list.should == {:std => std}
    end
    
  end
  
  describe 'Rails' do
    
    before(:each) do
      Object.send(:remove_const, 'RAILS_DEFAULT_LOGGER') if defined?(RAILS_DEFAULT_LOGGER)
    end
    
    after(:each) do
      Object.send(:remove_const, 'RAILS_DEFAULT_LOGGER') if defined?(RAILS_DEFAULT_LOGGER)
    end
    
    it 'should automatically add the RAILS_DEFAULT_LOGGER to the list, if defined' do
      RAILS_DEFAULT_LOGGER = mock('rails_default_logger')
      sp = SplitLogger.new
      sp.list.should == {:rails_default_logger => RAILS_DEFAULT_LOGGER}
    end
    
  end
  
  [:debug, :info, :warn, :error, :fatal].each do |level| 
    
    describe level do
      
      it "should call #{level} on each logger" do
        std = mock('std logger')
        other = mock('other logger')
        std.should_receive(level).with('this is my message')
        other.should_receive(level).with('this is my message')
        sp = SplitLogger.new
        sp.add(:std, std)
        sp.add(:other, other)
        sp.send(level, 'this is my message')
      end
      
      it 'should remove a bad logger from the list and write a message to the other loggers' do
        std = mock('std logger')
        std.should_receive(level).with('this is my message')
        std.should_receive(level).with("Ah! Crap!")
        std.should_receive(level).with("Removed logger 'oops' from the logger list!")
        oops = mock('oops')
        oops.should_receive(level).with('this is my message').and_raise('Ah! Crap!')
        sp = SplitLogger.new
        sp.add(:std, std)
        sp.add(:oops, oops)
        sp.send(level, 'this is my message')
      end
      
    end
    
  end

end
