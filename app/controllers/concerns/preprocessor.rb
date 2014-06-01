# -*- encoding : utf-8 -*-
module Preprocessor
  extend ActiveSupport::Concern

  require 'ruby_preprocessor'
  require 'java_preprocessor'

  attr_accessor :code

  private # TODO is that really necessary?

  @lang

  # A method that takes the given message aka the code of the user and checks which
  # programming language is selected as well as if the debug mode is set or not.
  # Default set ist no debug mode and Ruby. The method then commits the code to the
  # specified preprocessor and afterwards returns the modified code.
  def preprocess_code(msg, language='Ruby', debug=false)
    case language
      when 'Ruby'
        @lang = RubyPreprocessor.new('Ruby')
        @code = debug ? @lang.debug_code(msg, var=[]) : @lang.process_code(msg)
      when 'Java'
        @lang = JavaPreprocessor.new('Java')
        @code =debug ? @lang.debug_code(msg, var=[]) : @lang.process_code(msg)
      else
        @code = 'Something went terribly wrong!'
    end
    @code
  end

  def postprocess_error(line,code)
    @lang.postprocess_error(line,code)
  end

  def postprocess_error_compile(line,code)
    @lang.postprocess_error_compile(line,code)
  end

  def preprocess_filename
    @lang.filename
  end

  def preprocess_compile
    @lang.compile
  end

  def preprocess_execute
    @lang.execute
  end

  def preprocess_compile_error
    @lang.compile_error
  end

  def preprocess_execute_error
    @lang.execute_error
  end

end
