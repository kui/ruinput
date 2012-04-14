# -*- coding:utf-8; mode:ruby; -*-

require 'revdev/each_values_equal'

module Ruinput

  # import uinput_user_dev from uinput.h
  #
  # struct uinput_user_dev {
  #       char name[UINPUT_MAX_NAME_SIZE];
  #       struct input_id id;
  #       int ff_effects_max;
  #       int absmax[ABS_CNT];
  #       int absmin[ABS_CNT];
  #       int absfuzz[ABS_CNT];
  #       int absflat[ABS_CNT];
  # };
  class UinputUserDev
    attr_accessor(:name, :id, :ff_effects_max, :absmax, :absmin,
                  :absfuzz, :absflat)
    include Revdev::EachValuesEqual

    # TODO String class
    def initialize arg=nil
      if arg.kind_of? Hash
        [:name, :id, :ff_effects_max, :absmax,
         :absmin, :absfuzz, :absflat].each do |n|
          instance_variable_set("@#{n}", arg[n] || arg[n.to_s])
        end
      elsif not arg.nil?
        raise ArgumentError, "expected a Hash"
      end
    end

  end
end
