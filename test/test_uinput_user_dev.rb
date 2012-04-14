# -*- coding:utf-8; mode:ruby; -*-

require 'test/unit'
require 'rubygems'
require 'ruinput'
require 'revdev'

class UinputUserDevTest < Test::Unit::TestCase
  include Ruinput

  def test_init
    assert_nothing_raised do
      u = UinputUserDev.new :name => ""
    end
  end

  def test_to_byte_string
    id = Revdev::InputId.new :bustype => 1, :vendor => 2, :product => 3,
    :version => 4
    u = UinputUserDev.new :name => "foo", :id => id, :ff_effects_max => 100,
    :absmax => [20], :absmin => [30],  :absfuzz => [4], :absflat => [5]

    assert_nothing_raised do
      u.raw_initialize u.to_byte_string
    end
  end

end
