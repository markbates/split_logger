require 'test_helper'
require 'logger'

describe SplitLogger do

  let(:sp) {SplitLogger.new}

  describe 'add' do

    it 'should add a logger to the list' do
      sp.list.size.must_equal 0
      sp.add(:std, ::Logger.new(STDOUT))
      sp.list.size.must_equal 1
    end

  end

  describe 'list' do

    it 'should return a list of all loggers' do
      std = mock('std logger')
      sp.add(:std, std)
      sp.list.must_equal(std: std)
    end

  end

  describe 'remove' do

    it 'should remove a logger from the list' do
      std = mock('std logger')
      sp.add(:std, std)
      other = mock('other logger')
      sp.add(:other, other)
      sp.list.must_equal(std: std, other: other)
      sp.remove(:other)
      sp.list.must_equal(std: std)
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
      sp.list.must_equal(rails_default_logger: RAILS_DEFAULT_LOGGER)
    end

  end

  [:debug, :info, :warn, :error, :fatal].each do |level|

    describe level do

      it "should call #{level} on each logger" do
        std = mock('std logger')
        other = mock('other logger')
        std.expects(level).with('this is my message')
        other.expects(level).with('this is my message')
        sp.add(:std, std)
        sp.add(:other, other)
        sp.send(level, 'this is my message')
      end

      it 'should remove a bad logger from the list and write a message to the other loggers' do
        std = mock('std logger')
        std.expects(level).with('this is my message')
        std.expects(level).with("Ah! Crap!")
        std.expects(level).with("Removed logger 'oops' from the logger list!")
        oops = mock('oops')
        oops.expects(level).with('this is my message').raises('Ah! Crap!')
        sp.add(:std, std)
        sp.add(:oops, oops)
        sp.send(level, 'this is my message')
      end

    end

  end

end
