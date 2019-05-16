
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
  def integer : Integer
  def test_sig(x<Integer>, ?y<Integer>, *z<Integer>) : Integer
  def double_integer(i<Integer>) : Integer

  def sum(a<Integer>, b<Integer>) : Integer
  def other : Integer
end

# another comment

module M
  def test: A
end


module M
  def reopened: A
end

module N
end

class A
  include M
  prepend N
end

# def () : Any
