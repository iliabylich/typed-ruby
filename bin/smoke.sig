
# 1st comment
# 2nd comment


class Integer
  def m(...) : Any
end

class Integer
  def reoponed(...) : Any
end

class A
  @x: String

  def initialize(x<String>) : void
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
