module Kernel
  # def !~(...) : Any
  # def <=>(...) : Any
  # def ===(...) : Any
  # def =~(...) : Any
  # def class(...) : Any
  # def clone(...) : Any
  # def define_singleton_method(...) : Any
  # def display(...) : Any
  # def dup(...) : Any
  # def enum_for(...) : Any
  # def eql?(...) : Any
  # def extend(...) : Any
  # def freeze(...) : Any
  # def frozen?(...) : Any
  # def hash(...) : Any
  # def inspect(...) : Any
  # def instance_of?(...) : Any
  # def instance_variable_defined?(...) : Any
  # def instance_variable_get(...) : Any
  # def instance_variable_set(...) : Any
  # def instance_variables(...) : Any
  # def is_a?(...) : Any
  # def itself(...) : Any
  # def kind_of?(...) : Any
  # def method(...) : Any
  # def methods(...) : Any

  def nil? : Boolean
  def puts(...): void
  # def object_id : Integer

  # def pp(...) : Any
  # def private_methods(...) : Any
  # def protected_methods(...) : Any
  # def public_method(...) : Any
  # def public_methods(...) : Any
  # def public_send(...) : Any
  # def remove_instance_variable(...) : Any
  # def respond_to?(...) : Any
  # def send(...) : Any
  # def singleton_class(...) : Any
  # def singleton_method(...) : Any
  # def singleton_methods(...) : Any
  # def taint(...) : Any
  # def tainted?(...) : Any
  # def tap(...) : Any
  # def to_enum(...) : Any
  # def to_s(...) : Any
  # def trust(...) : Any
  # def untaint(...) : Any
  # def untrust(...) : Any
  # def untrusted?(...) : Any
  # def yield_self(...) : Any
end

class Object
  include Kernel
end
