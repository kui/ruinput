# -*- coding:utf-8; mode:ruby; -*-

require "revdev"

module Ruinput

  # a class for /dev/uinput
  class UinputDevice < Revdev::EventDevice
    attr_reader :is_created

    DEFUALT_LOCATION = "/dev/uinput"
    DEFAULT_DEVICE_NAME = "ruinput"
    DEFAULT_INPUT_ID = Revdev::InputId.new({ :bustype => Revdev::BUS_VIRTUAL,
                                             :vendor => 1,
                                             :product => 1,
                                             :version => 1 })

    def initialize  location=nil
      @is_created = false
      location ||= DEFUALT_LOCATION
      super location
    end

    # create virtual event divece
    # _name_ :: device name
    # _id_ :: InputId ("struct input_id" on input.h)
    def create name = DEFAULT_DEVICE_NAME, id = DEFAULT_INPUT_ID
      if not name.kind_of? String
        raise ArgumentError, "1st arg expect String"
      elsif not id.kind_of? Revdev::InputId
        raise ArgumentError, "2nd arg expect Revdev::InputId"
      end

      uud = UinputUserDev.new({ :name => name, :id => id,
                                :ff_effects_max => 0, :absmax => [20],
                                :absmin => [30], :absfuzz => [4],
                                :absflat => [5] })
      @file.syswrite uud.to_byte_string

      set_all_events

      @file.ioctl UI_DEV_CREATE, nil
      @is_created = true
    end

    def destroy
      if not @is_created
        raise Exception, "invalid method call: this uinput is not created"
      end
      @file.ioctl UI_DEV_DESTROY, nil
      @file.close
    end

    def set_all_events
      if @is_created
        raise Exception, "invalid method call: this uinput is already created"
      end
      @file.ioctl UI_SET_EVBIT, Revdev::EV_KEY
      Revdev::KEY_CNT.times do |i|
        @file.ioctl UI_SET_KEYBIT, i
      end

      @file.ioctl UI_SET_EVBIT, Revdev::EV_MSC
      Revdev::MSC_CNT.times do |i|
        @file.ioctl UI_SET_MSCBIT, i
      end

      @file.ioctl UI_SET_EVBIT, Revdev::EV_MSC
      Revdev::MSC_CNT.times do |i|
        @file.ioctl UI_SET_MSCBIT, i
      end

      @file.ioctl UI_SET_EVBIT, Revdev::EV_ABS
      Revdev::ABS_CNT.times do |i|
        @file.ioctl UI_SET_ABSBIT, i
      end

      @file.ioctl UI_SET_EVBIT, Revdev::EV_REP
    end

  end
end
