
# 1st comment
# 2nd comment


class Integer
end

class Integer
  def to_i : Integer
end

class Boolean
  def to_i : Integer
end

Type Str = String
Type Int = Integer
Type Bool = Boolean
Type StrOrIntOrBool = Str | Int | Bool

class A
  @x: StrOrIntOrBool

  def initialize(x<Str | Int>) : void
  def sum(a<Integer>, b<Integer>) : Integer
  def other : Integer
end
