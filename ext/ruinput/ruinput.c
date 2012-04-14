// -*- coding:utf-8; mode:c; -*-

#include <stdlib.h>
#include <stdio.h>
#include <linux/input.h>
#include <linux/uinput.h>

#include <ruby.h>

#define NAME "Ruinput"
#define BUFF_SIZE 255

#define FALSE 0
#define TRUE !FALSE

#define AttrAccessor(klass,name) rb_define_attr(klass,name,TRUE,TRUE)

VALUE module_ruinput;
VALUE class_uinput_user_dev;

void type_exception(char* name, char* klass)
{
  rb_raise(rb_eTypeError, "%s is expected a %s", name, klass);
}

int abs_array_cpy(int abs_arr[], VALUE array_obj)
{
  int len, i;
  VALUE* ptr;

  // TODO check class
  len = RARRAY_LEN(array_obj);
  ptr = RARRAY_PTR(array_obj);
  for(i=0; i<len; i++) {
    abs_arr[i] = FIX2INT(ptr[i]);
  }

  for(; i<ABS_CNT; i++){
    abs_arr[i] = 0;
  }

  return len;
}

VALUE uinput_user_dev_raw_initalize(VALUE self, VALUE bytes)
{
  struct uinput_user_dev *uud;
  uud = RSTRING(bytes)->ptr;
  printf("name: %s, ff_effects_max: %d\n", uud->name, uud->ff_effects_max);
  printf("id.bustype: %d, id.version: %d\n", uud->id.bustype, uud->id.version);
  printf("firsts-> absmax: %d, absflat: %d \n", uud->absmax[0], uud->absflat[0]);
}

VALUE uinput_user_dev_to_byte_string(VALUE self)
{
  struct uinput_user_dev uud;
  char* name;
  VALUE value_tmp;

  // TODO check @name size
  // @name
  value_tmp = rb_iv_get(self, "@name");
  if(TYPE(value_tmp) != T_STRING){
    type_exception("@name", "String");
    return Qnil;
  }
  strncpy(uud.name, StringValuePtr(value_tmp), UINPUT_MAX_NAME_SIZE);

  // @id
  value_tmp = rb_iv_get(self, "@id");
  if(TYPE(value_tmp) != T_OBJECT){
    type_exception("@id", "Revdev::UserId");
    return Qnil;
  }
  value_tmp = rb_funcall(value_tmp, rb_intern("to_byte_string"), 0);
  memcpy(&(uud.id), StringValuePtr(value_tmp), sizeof(struct input_id));

  // @ff_effects_max
  value_tmp = rb_iv_get(self, "@ff_effects_max");
  FIXNUM_P(value_tmp);
  uud.ff_effects_max = FIX2INT(value_tmp);

  // @absmax
  abs_array_cpy(uud.absmax, rb_iv_get(self, "@absmax"));

  // @absmin
  abs_array_cpy(uud.absmin, rb_iv_get(self, "@absmin"));

  // @absfuzz
  abs_array_cpy(uud.absfuzz, rb_iv_get(self, "@absfuzz"));

  // @absflat
  abs_array_cpy(uud.absflat, rb_iv_get(self, "@absflat"));

  return rb_str_new(&uud, sizeof(struct uinput_user_dev));
}


void Init_ruinput()
{
  /* module Ruinput */
  module_ruinput = rb_define_module("Ruinput");

  /* class UinputUserDev */
  class_uinput_user_dev =
    rb_define_class_under(module_ruinput, "UinputUserDev", rb_cObject);
  rb_define_method(class_uinput_user_dev, "raw_initialize",
                   uinput_user_dev_raw_initalize, 1);
  rb_define_method(class_uinput_user_dev, "to_byte_string",
                   uinput_user_dev_to_byte_string, 0);
}
