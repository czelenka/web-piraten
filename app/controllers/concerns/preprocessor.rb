# -*- encoding : utf-8 -*-
module Preprocessor
  extend ActiveSupport::Concern

  include CommandsForVm

  require 'ruby_preprocessor'
  require 'java_preprocessor'

  attr_accessor :code

  private # TODO is that really necessary?

  @lang

  # A method that takes the given message aka the code of the user and checks which
  # programming language is selected as well as if the debug mode is set or not by
  # checking if there are any variables given the user wants to trace.
  # Default set ist no debug mode and Ruby. The method then commits the code to the
  # specified preprocessor and afterwards returns the modified code.
  def initialize_preprocessor(language)
    case language
      when 'ruby'
        @lang = RubyPreprocessor.new('Ruby')
      when 'java'
        @lang = JavaPreprocessor.new('Java')
      when 'erlang'
        @lang = ErlangPreprocessor.new('Erlang')
      else
        $stderr.puts 'Something went terribly wrong!'
    end
  end

  def commands_for_vm(code, tracing_vars)
    proof_commands(@lang.commands_for_vm(code, tracing_vars))
  end

  def postprocess_print(send,type,line,code)
    result = @lang.postprocess_print(send,type,line,code)
    unless result[:type] or result[:message]
      $stderr.puts 'The result of \'postprocess_print/3\' must be a hash with key \':type\' (value one of :log, :warning, :error) and key \':message\'.'
      return
    end
    unless [:log, :warning, :error].include?(result[:type])
      $stderr.puts 'The value of \':type\' must be one of :log, :warning, :error.'
      return
    end
    result
  end

  def line_first
    @lang.line_first
  end

end
