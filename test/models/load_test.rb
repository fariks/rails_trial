require 'test_helper'

class LoadTest < ActiveSupport::TestCase
  test "should not save load for driver if there is previous load for this driver" do
      load = Load.new({:user => one})
      assert_not load.save
  end
end
