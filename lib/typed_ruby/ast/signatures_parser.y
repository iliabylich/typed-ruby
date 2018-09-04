class TypedRuby::AST::SignaturesParser

token kCLASS kMODULE kEND tIDENTIFIER kDEF tCOLON
      tLPAREN tRPAREN tPIPE tCOMMA tQM tLT tGT tSTAR
      tMINUS

rule

      target: # nothing
            | rules

       rules: rule
            | rule rules

        rule: class
            | module

       class: kCLASS tIDENTIFIER         kEND
            | kCLASS tIDENTIFIER methods kEND

      module: kMODULE tIDENTIFIER         kEND
            | kMODULE tIDENTIFIER methods kEND

     methods: method
            | method methods

      method: kDEF tIDENTIFIER tLPAREN arglist tRPAREN tCOLON type

        type: tIDENTIFIER
            | tIDENTIFIER tPIPE  type
            | tIDENTIFIER tMINUS type

     arglist: args tCOMMA optargs tCOMMA restarg
            | args tCOMMA optargs
            | args tCOMMA optargs tCOMMA
            | args tCOMMA                restarg
            | args
            |             optargs tCOMMA restarg
            |             optargs
            |             optargs tCOMMA
            |                            restarg
            | # nothing

        args: arg
            | arg args

         arg: tIDENTIFIER tLT type tGT

     optargs: optarg
            | optarg optargs

      optarg: tIDENTIFIER tQM tLT type tGT

     restarg: tSTAR tIDENTIFIER tLT type tGT

end

---- header

# require 'typed_ruby/ast/builder'

---- inner

  def initialize
    @builder = TypedRuby::AST::Builder.new
  end

  def next_token
    raise NotImplementedError
  end
