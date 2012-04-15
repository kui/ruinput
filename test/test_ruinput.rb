# -*- coding:utf-8; mode:ruby; -*-

require 'test/unit'
require 'ruinput'

class UinputUserDevTest < Test::Unit::TestCase
  include Ruinput

  def test_consts
    puts "Ruinput.constants.length = #{Ruinput.constants.length}"
    assert Ruinput.constants.length > 10
  end

end
