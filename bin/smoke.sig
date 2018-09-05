
# 1st comment
# 2nd comment


class Integer
  def m(...) : Any
end

class Integer
  def reoponed(...) : Any
end

class A
  def integer : Integer
  def test_sif(x<Integer>, ?y<Integer>, *z<Integer>) : Integer
  def double_integer(i<Integer>) : Integer
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
