# -*- coding:utf-8; mode:ruby; -*-

require 'test/unit'
require 'rubygems'
require 'revdev'
require 'ruinput'

class UinputDeviceTest < Test::Unit::TestCase
  include Ruinput

  FILE = "/tmp/foo"
  FileUtils.touch FILE

  def test_init
    UinputDevice.new FILE
  end

  def test_create
    $file = File.new FILE
    $ioctls = []
    def $file.ioctl cmd, val=nil
      $ioctls << cmd
    end
    $syswrites = ""
    def $file.syswrite arg
      $syswrites << arg
    end

    ud = UinputDevice.new $file
    assert_nothing_raised do
      ud.create
    end
    assert_equal UI_DEV_CREATE, $ioctls.last
    assert 0 < $syswrites.length
  end

  def test_create
    $file = File.new FILE
    $ioctls = []
    def $file.ioctl cmd, val=nil
      $ioctls << cmd
    end
    def $file.syswrite arg
    end

    ud = UinputDevice.new $file
    assert_nothing_raised do
      ud.create
      ud.destroy
    end
    assert_equal UI_DEV_DESTROY, $ioctls.last
  end

end
