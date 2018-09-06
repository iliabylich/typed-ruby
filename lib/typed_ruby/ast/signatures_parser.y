class TypedRuby::AST::SignaturesParser

token kCLASS kMODULE kEND kDEF kANY_ARGS kANY kINCLUDE kPREPEND
      tIDENTIFIER tCOLON tLPAREN tRPAREN
      tPIPE tMINUS tCOMMA tQM tLT tGT tSTAR tRUBYCODE

rule

                target: # nothing
                      | rules

                 rules: rule
                      | rule rules

                  rule: class
                      | module
                      | rubycode

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
                      | method

                method: kDEF tIDENTIFIER tLPAREN arglist tRPAREN tCOLON type
                        {
                          result = @builder.method(name_t: val[1], arguments: val[3], returns: val[6])
                        }
                      | kDEF tIDENTIFIER                         tCOLON type
                        {
                          result = @builder.method(name_t: val[1],                    returns: val[3])
                        }

        module_include: kINCLUDE tIDENTIFIER
                        {
                          result = @builder.module_include(name_t: val[1])
                        }

        module_prepend: kPREPEND tIDENTIFIER
                        {
                          result = @builder.module_prepend(name_t: val[1])
                        }

                  type: single_type
                      | single_type tPIPE type
                        {
                          result = @builder.union(val[0], val[2])
                        }
                      | single_type tMINUS type
                        {
                          result = @builder.minus(val[0], val[2])
                        }
                      | kANY
                        {
                          result = @builder.any_type
                        }

           single_type: tIDENTIFIER
                        {
                          result = @builder.instance_of(name_t: val[0])
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

                   arg: tIDENTIFIER tLT type tGT
                        {
                          result = @builder.arg(name_t: val[0], type: val[2])
                        }
                      | tQM tIDENTIFIER tLT type tGT
                        {
                          result = @builder.optarg(name_t: val[1], type: val[3])
                        }
                      | tSTAR tIDENTIFIER tLT type tGT
                        {
                          result = @builder.restarg(name_t: val[1], type: val[3])
                        }

              rubycode: tRUBYCODE
                        {
                          @registry.instance_eval(val[0], '__RUBY__')
                        }

end

---- header

require 'typed_ruby/ast/builder'

---- inner

  def initialize(source, file)
    @buffer = StringScanner.new(source)
    @file = file
    # @yydebug = true
  end

  def import_into(registry)
    @registry = registry
    @builder = TypedRuby::AST::Builder.new(registry)
    @queue = []
    do_parse
  end

  MAP = {
    /class\b/         => :kCLASS,
    /module\b/        => :kMODULE,
    /end\b/           => :kEND,
    /def\b/           => :kDEF,
    /\.\.\./          => :kANY_ARGS,
    /Any/             => :kANY,
    /include\b/       => :kINCLUDE,
    /prepend\b/       => :kPREPEND,

    /:/               => :tCOLON,
    /\(/              => :tLPAREN,
    /\)/              => :tRPAREN,
    /\|/              => :tPIPE,
    /,/               => :tCOMMA,
    /\?/              => :tQM,

    /\<\=\>/          => :tIDENTIFIER,
    /\<\=/            => :tIDENTIFIER,
    /\>\=/            => :tIDENTIFIER,

    /</               => :tLT,
    />/               => :tGT,
    /\*/              => :tSTAR,
    /-/               => :tMINUS,

    /^__RUBY__$/      => :tRUBYCODE,

    /\!\=/            => :tIDENTIFIER,
    /\!~/             => :tIDENTIFIER,
    /\!/              => :tIDENTIFIER,
    /\=\=\=/          => :tIDENTIFIER,
    /\=~/             => :tIDENTIFIER,
    /\=\=/            => :tIDENTIFIER,
    /\+/              => :tIDENTIFIER,
    /\w+\?/           => :tIDENTIFIER,
    /\w+\!/           => :tIDENTIFIER,
    /\w+\b/           => :tIDENTIFIER,
  }.freeze

  def next_token
    @buffer.skip(/(\s+|\#.*$)*/)

    _, token_type = MAP.detect { |rule, token| @buffer.scan(rule) }

    if token_type == :tRUBYCODE
      code = @buffer.scan_until(/^__RUBY__$/).sub('__RUBY__', '')
      return [:tRUBYCODE, code]
    end

    token_value = @buffer.matched
    token_pos   = @buffer.pos
    token       = [token_value, token_pos]

    if @queue.last == :kDEF && %i[tLT tGT kINCLUDE kPREPEND kCLASS].include?(token_type)
      return [:tIDENTIFIER, token]
    end

    @queue << token_type

    if token_type
      [token_type, token]
    else
      [false, '$end']
    end
  end

  SyntaxError = Class.new(StandardError)

  def on_error(error_token_id, error_value, value_stack)
    error_token = token_to_str(error_token_id)
    token_value, token_pos = *error_value

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
