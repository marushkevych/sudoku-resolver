require "test/unit"
require '../element'
class ElementTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_can_increment_is_true
    element = Element.new(" ", 1, 1)
    element.variants = [1,2,3]
    element.variant_index = 1
    
    assert_equal true, element.can_increment?

  end

  def test_can_increment_is_false
    element = Element.new(" ", 1, 1)
    element.variants = [1,2,3]
    element.variant_index = 2

    assert_equal false, element.can_increment?

  end
end