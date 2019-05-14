class TypedRuby::Parsers::SignaturesParser

token kCLASS kMODULE kEND kDEF kANY_ARGS kANY kINCLUDE kPREPEND kSELF
      tIDENTIFIER tCOLON tLPAREN tRPAREN
      tPIPE tMINUS tCOMMA tQM tLT tGT tSTAR tAMP tDOT tRUBYCODE

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
                      | method_def

            method_def: kDEF            tIDENTIFIER tLPAREN arglist tRPAREN tCOLON type
                        {
                          result = @builder.method_def(name_t: val[1], arguments: val[3], returns: val[6])
                        }
                      | kDEF            tIDENTIFIER                         tCOLON type
                        {
                          result = @builder.method_def(name_t: val[1],                    returns: val[3])
                        }
                      | kDEF kSELF tDOT tIDENTIFIER tLPAREN arglist tRPAREN tCOLON type
                        {
                          result = @builder.method_def(name_t: val[3], arguments: val[5], returns: val[8])
                        }
                      | kDEF kSELF tDOT tIDENTIFIER                         tCOLON type
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

              rubycode: tRUBYCODE
                        {
                          @registry.instance_eval(val[0], '__RUBY__')
                        }

end

---- header

require 'typed_ruby/parsers/builder'

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
    /self\b/          => :kSELF,

    /:/               => :tCOLON,
    /\(/              => :tLPAREN,
    /\)/              => :tRPAREN,
    /\|/              => :tPIPE,
    /,/               => :tCOMMA,
    /\./              => :tDOT,
    /\?/              => :tQM,
    /&/               => :tAMP,

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
