require "test/unit"
require "opencl"

class TestVArray < Test::Unit::TestCase

  def test_new
    vary = OpenCL::VArray.new(OpenCL::VArray::INT2, 1)
    assert_equal(vary.length, 1)
  end

  def test_aset
    vary = OpenCL::VArray.new(OpenCL::VArray::FLOAT2, 2)
    vary[0] = OpenCL::Float2.new(1,2)
    assert_equal(vary[0].to_a, [1.0, 2.0])
    vary[1] = 10.0
    assert_equal(vary[1].to_a, [10.0, 10.0])
  end

  def test_narray
    na = NArray.sfloat(2,4).indgen
    vary = OpenCL::VArray.to_va(na)
    assert_equal(vary.length, 4)
    assert_equal(vary[0].to_a, [0.0, 1.0])
    assert_equal(vary[-1].to_a, [6.0, 7.0])
    assert_equal(vary.to_na, na)
  end

  def test_endian
    na = NArray.sint(2,2).indgen
    vary = OpenCL::VArray.to_va(na,  :binary => true)
    if OpenCL::Vector::BIG_ENDIAN
      assert_equal(vary[0].to_a, [0,1])
      assert_equal(vary[1].to_a, [2,3])
      assert_equal(vary.to_na, na)
    else
      assert_equal(vary[0].to_a, [1,0])
      assert_equal(vary[1].to_a, [3,2])
      assert_equal(vary.to_na, na[-1..0,true])
    end
    assert_equal(vary.to_na(:binary => true), na)
  end

  def test_calc
    vary = OpenCL::VArray.to_va(NArray.sfloat(2,2).indgen)
    vary + 1
    assert_equal(vary[0].to_a, [1.0, 2.0])
    assert_equal(vary[1].to_a, [3.0, 4.0])
    vary * OpenCL::Float2.new(10, 20)
    assert_equal(vary[0].to_a, [10.0, 40.0])
    assert_equal(vary[1].to_a, [30.0, 80.0])
    vary2 = vary.copy
    vary2 / OpenCL::VArray.to_va(NArray.sfloat(2,2).indgen(1))
    assert_equal(vary2[0].to_a, [10.0, 20.0])
    assert_equal(vary2[1].to_a, [10.0, 20.0])
    assert_equal(vary[0].to_a, [10.0, 40.0])
    assert_equal(vary[1].to_a, [30.0, 80.0])
  end

end
