class TypedRuby::Parsers::SignaturesParser

token kCLASS kMODULE kEND kDEF kANY_ARGS kINCLUDE kPREPEND kSELF kVOID
      tIDENTIFIER tCOLON tLPAREN tRPAREN tPLACEHOLDER tDSTAR tVARIABLE
      tPIPE tMINUS tCOMMA tLT tGT tSTAR tAMP tDOT tRUBYCODE tAT tGENERIC_TYPE
      kTYPE tEQ

prechigh
  left tPIPE tMINUS
preclow

rule

                target: # nothing
                      | rules
                        {
                          result = [:program, val[0]]
                        }

                 rules: rule
                        {
                          result = [val[0]]
                        }
                      | rule rules
                        {
                          result = [val[0]] + val[1]
                        }

                  rule: class_definition
                      | module_definition
                      | type_definition
                      | rubycode

      class_definition: kCLASS type_ref maybe_super maybe_module_items kEND
                        {
                          result = [:class, val[1], val[2], val[3]]
                        }

     module_definition: kMODULE type_ref maybe_module_items kEND
                        {
                          result = [:module, val[1], val[2]]
                        }
              rubycode: tRUBYCODE
                        {
                          result = [:eval, val[0]]
                        }
       type_definition: kTYPE type_ref tEQ type_expr

           maybe_super: tLT type_ref
                        {
                          result = val[1]
                        }
                      | # nothing

    maybe_module_items: module_items
                      | # nothing
                        {
                          result = []
                        }

          module_items: module_item
                        {
                          result = [ val[0] ]
                        }
                      | module_item module_items
                        {
                          result = [ val[0] ] + val[1]
                        }

           module_item: include_module
                      | prepend_module
                      | method_definition
                      | ivar_definition

     method_definition: kDEF maybe_on_self identifier maybe_arglist tCOLON return_type
                        {
                          result = [:method, on_self: val[1], name: val[2], arglist: val[3], returns: val[5]]
                        }

         maybe_on_self: kSELF tDOT
                        {
                          result = true
                        }
                      | # nothing
                        {
                          result = false
                        }

         maybe_arglist: tLPAREN arglist tRPAREN
                        {
                          result = [:arglist, val[1]]
                        }
                      | # nothing
                        {
                          result = [:arglist, []]
                        }

        include_module: kINCLUDE identifier
                        {
                          result = [:include, val[1]]
                        }
        prepend_module: kPREPEND identifier
                        {
                          result = [:prepend, val[1]]
                        }

           return_type: type_expr
                        {
                          result = [:returns, val[0]]
                        }
                      | kVOID
                        {
                          result = [:returns, :void]
                        }

               arglist: args
                      | kANY_ARGS
                        {
                          result = :any_args
                        }
                      | # nothing
                        {
                          result = []
                        }

                  args: arg
                        {
                          result = [ val[0] ]
                        }
                      | arg tCOMMA args
                        {
                          result = [ val[0] ] + val[2]
                        }

                   arg: type_expr argdef
                        {
                          kind, name = val[1]
                          result = [ :arg, type: val[0], kind: kind, name: name ]
                        }

                argdef: variable
                        {
                          result = [ :req, val[0] ]
                        }
                      | variable tEQ tPLACEHOLDER
                        {
                          result = [ :opt, val[0] ]
                        }
                      | tSTAR variable
                        {
                          result = [ :rest, val[1] ]
                        }
                      | variable tCOLON
                        {
                          result = [ :kwreq, val[0] ]
                        }
                      | variable tCOLON tPLACEHOLDER
                        {
                          result = [ :kwopt, val[0] ]
                        }
                      | tDSTAR variable
                        {
                          result = [ :kwrest, val[1] ]
                        }
                      | tAMP variable
                        {
                          result = [ :block, val[1] ]
                        }

                  ivar: tAT identifier
                        {
                          binding.pry
                        }
                      | tAT variable
                        {
                          result = val[1]
                        }

       ivar_definition: ivar tCOLON type_expr
                        {
                          result = [ :ivar, val[0], val[2] ]
                        }

              type_ref: single_type
                      | generic_type

             type_expr: single_type
                      | generic_type
                      | types_composition

           single_type: identifier
                        {
                          result = [:type, val[0]]
                        }

          generic_type: tGENERIC_TYPE tLT generic_variables tGT
                        {
                          result = [:generic, name: value_of(val[0]), variables: val[2]]
                        }

     types_composition: union
                      | diff

                 union: type_expr tPIPE type_expr

                  diff: type_expr tMINUS type_expr

     generic_variables: identifier
                        {
                          result = [ val[0] ]
                        }
                      | identifier tCOMMA generic_variables
                        {
                          result = [ val[0] ] + val[2]
                        }

            identifier: tIDENTIFIER
                        {
                          result = value_of(val[0])
                        }

              variable: tVARIABLE
                        {
                          result = value_of(val[0])
                        }

end

---- header

require 'strscan'

---- inner

  def initialize(source, file)
    @buffer = StringScanner.new(source)
    @file = file
    # @yydebug = true
  end

  def import_into(registry)
    # @registry = registry

    tokenize

    p @file
    ast = do_parse
    pp ast

    TypedRuby::AST::Visitor.new(ast).apply_on(registry)
    puts "\n\n"
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
      elsif defining_method? && !@buffer.match?(/self/) && @buffer.scan(METHOD_NAME_REGEX)
        emit(:tIDENTIFIER)

      # keywords
      elsif @buffer.scan(/class\b/)     then emit(:kCLASS)
      elsif @buffer.scan(/module\b/)    then emit(:kMODULE)
      elsif @buffer.scan(/end\b/)       then emit(:kEND)
      elsif @buffer.scan(/def\b/)       then emit(:kDEF)
      elsif @buffer.scan(/\.\.\./)      then emit(:kANY_ARGS)
      elsif @buffer.scan(/include\b/)   then emit(:kINCLUDE)
      elsif @buffer.scan(/prepend\b/)   then emit(:kPREPEND)
      elsif @buffer.scan(/self\b/)      then emit(:kSELF)
      elsif @buffer.scan(/void\b/)      then emit(:kVOID)
      elsif @buffer.scan(/Type\b/)      then emit(:kTYPE)

      # __RUBY__ code interpolation
      elsif @buffer.scan(/^__RUBY__$/)
        code = @buffer.scan_until(/^__RUBY__$/).sub('__RUBY__', '')
        emit(:tRUBYCODE, code)

      # Placeholder _
      elsif @buffer.scan(/_\b/)         then emit(:tPLACEHOLDER)

      # Identifiers
      elsif @buffer.scan(IDENTIFIER_REGEX)
        first_letter = @buffer.matched[0]
        if first_letter == first_letter.upcase
          emit(:tIDENTIFIER)
        else
          emit(:tVARIABLE)
        end

      # Generic end
      elsif @buffer.scan(/>/)
        popped = []
        popped << @queue.pop until last_token == :tLT
        popped << @queue.pop # presumably tLT
        type, token = @queue.pop # presumably tIDENTIFIER

        type = :tGENERIC_TYPE if type == :tIDENTIFIER
        # push back in reverse order
        @queue << [type, token]
        popped.reverse_each { |item| @queue << item }

        emit(:tGT)

      # Punctuation
      elsif @buffer.scan(/:/)    then emit(:tCOLON)
      elsif @buffer.scan(/\(/)   then emit(:tLPAREN)
      elsif @buffer.scan(/\)/)   then emit(:tRPAREN)
      elsif @buffer.scan(/\|/)   then emit(:tPIPE)
      elsif @buffer.scan(/,/)    then emit(:tCOMMA)
      elsif @buffer.scan(/\./)   then emit(:tDOT)
      elsif @buffer.scan(/\?/)   then emit(:tQM)
      elsif @buffer.scan(/&/)    then emit(:tAMP)
      elsif @buffer.scan(/</)    then emit(:tLT)
      elsif @buffer.scan(/\*\*/) then emit(:tDSTAR)
      elsif @buffer.scan(/\*/)   then emit(:tSTAR)
      elsif @buffer.scan(/-/)    then emit(:tMINUS)
      elsif @buffer.scan(/@/)    then emit(:tAT)
      elsif @buffer.scan(/=/)    then emit(:tEQ)
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

  def defining_method?
    last_token == :kDEF ||
      last_tokens(3) == [:kDEF, :kSELF, :tDOT]
  end

  def in_generic?
    last_tokens(2) == [:tIDENTIFIER, :tLT]
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

  def value_of(tok)
    tok[0]
  end

  def pos_of(tok)
    tok[1]
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
