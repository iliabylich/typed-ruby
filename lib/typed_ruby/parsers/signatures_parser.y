class TypedRuby::Parsers::SignaturesParser

token kCLASS kMODULE kEND kDEF kANY_ARGS kANY kINCLUDE kPREPEND kSELF kVOID
      tIDENTIFIER tCOLON tLPAREN tRPAREN
      tPIPE tMINUS tCOMMA tQM tLT tGT tSTAR tAMP tDOT tRUBYCODE tAT
      kTYPE tEQ

prechigh
  left tPIPE tMINUS
preclow

rule

                target: # nothing
                      | rules

                 rules: rule
                      | rule rules

                  rule: class
                      | module
                      | rubycode
                      | typedef

                 class: class_open              kEND
                      | class_open module_items kEND
                        {
                          @builder.apply_module_items(val[1], on: val[0])
                        }

            class_open: kCLASS tIDENTIFIER
                        {
                          result = @builder.find_or_create_class(name_t: val[1])
                        }
                      | kCLASS tIDENTIFIER tLT tIDENTIFIER
                        {
                          result = @builder.find_or_create_class(name_t: val[1], superclass_t: val[3])
                        }

                module: module_open              kEND
                      | module_open module_items kEND
                        {
                          @builder.apply_module_items(val[1], on: val[0])
                        }

           module_open: kMODULE tIDENTIFIER
                        {
                          result = @builder.find_or_create_module(name_t: val[1])
                        }

          module_items: module_item
                        {
                          result = [val[0]]
                        }
                      | module_item module_items
                        {
                          result = [val[0]] + val[1]
                        }

           module_item: module_include
                      | module_prepend
                      | method_def
                      | ivar_def

            method_def: kDEF            tIDENTIFIER tLPAREN arglist tRPAREN tCOLON return_type
                        {
                          result = @builder.method_def(name_t: val[1], arguments: val[3], returns: val[6])
                        }
                      | kDEF            tIDENTIFIER                         tCOLON return_type
                        {
                          result = @builder.method_def(name_t: val[1],                    returns: val[3])
                        }
                      | kDEF kSELF tDOT tIDENTIFIER tLPAREN arglist tRPAREN tCOLON return_type
                        {
                          result = @builder.method_def(name_t: val[3], arguments: val[5], returns: val[8])
                        }
                      | kDEF kSELF tDOT tIDENTIFIER                         tCOLON return_type
                        {
                          result = @builder.method_def(name_t: val[3],                    returns: val[5])
                        }

        module_include: kINCLUDE tIDENTIFIER
                        {
                          result = @builder.module_include(name_t: val[1])
                        }

        module_prepend: kPREPEND tIDENTIFIER
                        {
                          result = @builder.module_prepend(name_t: val[1])
                        }

                  type: tIDENTIFIER
                        {
                          result = @builder.instance_of(type_t: val[0])
                        }
                      | type tPIPE type
                        {
                          result = @builder.union(val[0], val[2])
                        }
                      | type tMINUS type
                        {
                          result = @builder.minus(val[0], val[2])
                        }
                      | kANY
                        {
                          result = @builder.any_type
                        }

           return_type: type
                      | kVOID
                        {
                          result = @builder.void
                        }

               arglist: args
                        {
                          result = val[0]
                        }
                      | kANY_ARGS
                        {
                          result = @builder.any_args
                        }
                      | # nothing
                        {
                          result = []
                        }

                  args: arg
                        {
                          result = [val[0]]
                        }
                      | args tCOMMA arg
                        {
                          result = val[0] + [val[2]]
                        }

                   arg: required_arg
                      | opt_arg
                      | rest_arg
                      | kwarg
                      | kwoptarg
                      | kwrestarg
                      | blockarg

          required_arg: typed_value
                        {
                          name_t, type = val[0]
                          result = @builder.arg(name_t: name_t, type: type)
                        }

               opt_arg: tQM typed_value
                        {
                          name_t, type = val[1]
                          result = @builder.optarg(name_t: name_t, type: type)
                        }

              rest_arg: tSTAR typed_value
                        {
                          name_t, type = val[1]
                          result = @builder.restarg(name_t: name_t, type: type)
                        }

                 kwarg: typed_value tCOLON
                        {
                          name_t, type = val[0]
                          result = @builder.kwarg(name_t: name_t, type: type)
                        }

              kwoptarg: tQM typed_value tCOLON
                        {
                          name_t, type = val[1]
                          result = @builder.kwoptarg(name_t: name_t, type: type)
                        }

             kwrestarg: tSTAR tSTAR typed_value
                        {
                          name_t, type = val[1]
                          result = @builder.kwrestarg(name_t: name_t, type: type)
                        }

              blockarg: tAMP typed_value
                        {
                          name_t, type = val[1]
                          result = @builder.blockarg(name_t: name_t, type: type)
                        }

           typed_value: tIDENTIFIER tLT type tGT
                        {
                          result = [val[0], val[2]]
                        }

             ivar_name: tAT tIDENTIFIER
                        {
                          result = val[1]
                        }

              ivar_def: ivar_name tCOLON type
                        {
                          result = @builder.ivar(name_t: val[0], type: val[2])
                        }

              rubycode: tRUBYCODE
                        {
                          @registry.instance_eval(val[0], '__RUBY__')
                        }

               typedef: kTYPE tIDENTIFIER tEQ type
                        {
                          @registry.register_type(name: val[1][0], type: val[3])
                        }

end

---- header

require 'typed_ruby/parsers/builder'
require 'strscan'

---- inner

  def initialize(source, file)
    @buffer = StringScanner.new(source)
    @file = file
    # @yydebug = true
  end

  def import_into(registry)
    @registry = registry
    @builder = TypedRuby::AST::Builder.new(registry)

    tokenize

    do_parse
  end

  METHOD_NAME_REGEX = /
    (<=>)
      |(<=)
      |(>=)
      |(<)
      |(>)
      |(!=)
      |(!~)
      |(!)
      |(===)
      |(=~)
      |(==)
      |(\+)
      |(\w+\?)
      |(\w+\!)
      |(\w+)
    \b
  /x

  METHOD_REF_REGEX = /(\#|\.)#{METHOD_NAME_REGEX}/

  RUBY_CODE_REGEX = /^__RUBY__$.*^__RUBY__$/

  IDENTIFIER_REGEX = /\w+/

  def tokenize
    @queue = []

    loop do
      @buffer.skip(/\s+/)

      break if @buffer.eos?

      if @buffer.scan(/#.*/)
        # comments, ignoring
      elsif method_name? && !@buffer.match?(/self/) && @buffer.scan(METHOD_NAME_REGEX)
        emit(:tIDENTIFIER)
      elsif @buffer.scan(/class\b/)
        emit(:kCLASS)
      elsif @buffer.scan(/module\b/)
        emit(:kMODULE)
      elsif @buffer.scan(/end\b/)
        emit(:kEND)
      elsif @buffer.scan(/def\b/)
        emit(:kDEF)
      elsif @buffer.scan(/\.\.\./)
        emit(:kANY_ARGS)
      elsif @buffer.scan(/Any/)
        emit(:kANY)
      elsif @buffer.scan(/include\b/)
        emit(:kINCLUDE)
      elsif @buffer.scan(/prepend\b/)
        emit(:kPREPEND)
      elsif @buffer.scan(/self\b/)
        emit(:kSELF)
      elsif @buffer.scan(/void\b/)
        emit(:kVOID)
      elsif @buffer.scan(/Type\b/)
        emit(:kTYPE)
      elsif @buffer.scan(/^__RUBY__$/)
        code = @buffer.scan_until(/^__RUBY__$/).sub('__RUBY__', '')
        emit(:tRUBYCODE, code)
      elsif @buffer.scan(IDENTIFIER_REGEX)
        emit(:tIDENTIFIER)
      elsif @buffer.scan(/:/)
        emit(:tCOLON)
      elsif @buffer.scan(/\(/)
        emit(:tLPAREN)
      elsif @buffer.scan(/\)/)
        emit(:tRPAREN)
      elsif @buffer.scan(/\|/)
        emit(:tPIPE)
      elsif @buffer.scan(/,/)
        emit(:tCOMMA)
      elsif @buffer.scan(/\./)
        emit(:tDOT)
      elsif @buffer.scan(/\?/)
        emit(:tQM)
      elsif @buffer.scan(/&/)
        emit(:tAMP)
      elsif @buffer.scan(/</)
        emit(:tLT)
      elsif @buffer.scan(/>/)
        emit(:tGT)
      elsif @buffer.scan(/\*/)
        emit(:tSTAR)
      elsif @buffer.scan(/-/)
        emit(:tMINUS)
      elsif @buffer.scan(/@/)
        emit(:tAT)
      elsif @buffer.scan(/=/)
        emit(:tEQ)
      else
        break
      end
    end
  end

  def last_token
    last_tokens(1).last
  end

  def last_tokens(n)
    @queue.last(n).map { |token_type, _token| token_type }
  end

  def method_name?
    last_token == :kDEF ||
      last_tokens(3) == [:kDEF, :kSELF, :tDOT]
  end

  def emit(token_type, token = matched_token)
    @queue << [token_type, token]
  end

  def matched_token
    token_value = @buffer.matched
    token_pos   = @buffer.pos
    [token_value, token_pos]
  end

  def next_token
    if @queue.empty?
      [false, '$end']
    else
      @queue.shift
    end
  end

  SyntaxError = Class.new(StandardError)

  def on_error(error_token_id, error_value, value_stack)
    error_token = token_to_str(error_token_id)
    token_value, token_pos = *error_value

    raise SyntaxError.new("Unexpected $end") if error_token == '$end'

    @buffer.pos = token_pos
    @buffer.pos -=1 until @buffer.beginning_of_line?

    line_start = @buffer.pos

    line = @buffer.scan_until(/$/)
    lineno = @buffer.string[0..@buffer.pos].count("\n")

    error = SyntaxError.new(<<~MESSAGE)

      Unexpected token #{error_token}:

          #{line}
          #{' ' * (token_pos - line_start - token_value.length) + '^' * token_value.length}

    MESSAGE

    error.set_backtrace(["#{@file}:#{lineno}"])

    raise error
  end
