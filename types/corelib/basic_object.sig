class BasicObject
  def ! : Boolean
  def !=(other<Any>) : Boolean
  def ==(other<Any>) : Boolean
  def __id__ : Integer

  def __send__(...) : Any

  def equal?(other<Any>) : Boolean

  def instance_eval(...) : Any
  def instance_exec(...) : Any
  def method_missing(...) : Any
  def singleton_method_added(...) : Any
  def singleton_method_removed(...) : Any
end
