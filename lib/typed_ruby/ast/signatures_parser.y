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
                          result = @builder.find_or_create_class(name: val[1])
                        }
                      | kCLASS tIDENTIFIER tLT tIDENTIFIER
                        {
                          result = @builder.find_or_create_class(name: val[1], superclass: val[3])
                        }

                module: module_open              kEND
                      | module_open module_items kEND
                        {
                          @builder.apply_module_items(val[1], on: val[0])
                        }

           module_open: kMODULE tIDENTIFIER
                        {
                          result = @builder.find_or_create_module(name: val[1])
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
                          result = @builder.method(name: val[1], arguments: val[3], returns: val[6])
                        }
                      | kDEF tIDENTIFIER                         tCOLON type
                        {
                          result = @builder.method(name: val[1], returns: val[3])
                        }

        module_include: kINCLUDE tIDENTIFIER
                        {
                          result = @builder.module_include(val[1])
                        }

        module_prepend: kPREPEND tIDENTIFIER
                        {
                          result = @builder.module_prepend(val[1])
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
                          result = @builder.instance_of(@registry.find_class(val[0]))
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
                      | arg tCOMMA args
                        {
                          result = [val[0]] + val[2]
                        }

                   arg: tIDENTIFIER tLT type tGT
                        {
                          result = @builder.arg(name: val[0], type: val[2])
                        }
                      | tQM tIDENTIFIER tLT type tGT
                        {
                          result = @builder.optarg(name: val[1], type: val[3])
                        }
                      | tSTAR tIDENTIFIER tLT type tGT
                        {
                          result = @builder.restarg(name: val[1], type: val[3])
                        }

              rubycode: tRUBYCODE
                        {
                          @registry.instance_eval(val[0], '__RUBY__')
                        }

end

---- header

require 'typed_ruby/ast/builder'

---- inner

  def initialize(source)
    @buffer = StringScanner.new(source)
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

    if @queue.last == :kDEF && %i[tLT tGT kINCLUDE kPREPEND kCLASS].include?(token_type)
      return [:tIDENTIFIER, @buffer.matched]
    end

    @queue << token_type

    if token_type
      token_value = @buffer.matched
      [token_type, token_value]
    else
      [false, '$end']
    end
  end
