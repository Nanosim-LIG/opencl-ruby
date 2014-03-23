require "test/unit"
require "opencl"


class TestVector < Test::Unit::TestCase
  def test_new
    assert_equal(OpenCL::Short4.new(1, 2, 3, 4.0).to_a, [1, 2, 3, 4])
    assert_equal(OpenCL::Int2.new(1, 2.0).to_a, [1, 2])
    assert_equal(OpenCL::Float4.new(1, 2, 3, 4.0).to_a, [1.0, 2.0, 3.0, 4.0])
  end
end
