
# 1st comment
# 2nd comment

__RUBY__
puts "Dynamic code evaluated"
__RUBY__

class T
end

class X < Object
  def self.m1(Object req, Object opt = _, Object *rest, Object kw:, Object kwopt: _, Object **kwrest, Object &block): T
  def m2(Object a): T

  include Kernel
  prepend Kernel
end

class Integer
  def to_i : Integer
end

class Boolean
  def to_i : Integer
end

# Type Str = String
# Type Int = Integer
# Type Bool = Boolean
# Type StrOrIntOrBool = Str | Int | Bool

# Type Strings = Array<String, WhateverElse>

class A
  @x: String

  def initialize(String | Integer x) : void
  def sum(Integer a, Integer b) : Integer
  def other : Integer

  def test_generics(String strings): Array
end
