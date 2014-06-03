# -*- encoding : utf-8 -*-
class RubyPreprocessor < BasePreprocessor

  def initialize(attribut)
    super(attribut)
  end

  def process_code(code_msg)
    i=0
    codes = ''
    code_msg << "\n"
    code_msg.each_line do |s|
      codes += s + "line(#{i})\n"
      i += 1
    end
    insert_logic + codes + "\n"
  end

  def debug_code(code_msg, vars)
    i=0
    code = ''
    code_msg << "\n"
    code_msg.each_line do |s|
      code += s + "line(#{i})\n" #TODO: add the json object for tracing variables
      i += 1
    end
    insert_logic + code + "\n"
  end

  # A method that stores the language- and ship-logic for Ruby that's put in the
  # code of the user to get the ship moving and so on.
  def insert_logic
    "STDOUT.sync = true\n" +
        "def move\n" +
        "  puts \"#{$prefix}move\"\n" +
        "end\n" +
        "def turnRight\n" +
        "  puts \"#{$prefix}turnRight\"\n" +
        "end\n" +
        "def turnLeft\n" +
        "  puts \"#{$prefix}turnLeft\"\n" +
        "end\n" +
        "def put\n" +
        "  puts \"#{$prefix}put\"\n" +
        "end\n" +
        "def line(i)\n" +
        "  puts \"\\n#{$prefix}line!\#{i}\"\n" +
        "end\n" +
        "def look(dir)\n" +
        "  case dir\n" +
        "    when :right then puts \"#{$prefix}?_look_right\"\n" +
        "    when :left then puts \"#{$prefix}?_look_left\"\n" +
        "    when :here then puts \"#{$prefix}?_look_here\"\n" +
        "    when :back then puts \"#{$prefix}?_look_back\"\n" +
        "    when :front then puts \"#{$prefix}?_look_front\"\n"+
        "  end\n" +
        "  ret = gets\n" +
        "  if ret.include? \"#{$prefix}!_Buoy\"\n" +
        "    return :buoy\n" +
        "  elsif ret.include? \"#{$prefix}!_Monster\"\n" +
        "    return :monster\n" +
        "  elsif ret.include? \"#{$prefix}!_Treasure\"\n" +
        "    return :treasure\n" +
        "  elsif ret.include? \"#{$prefix}!_Wave\"\n" +
        "    return :wave\n" +
        "  else\n" +
        "    return :nothing\n" +
        "  end\n" +
        "end\n\n"
  end

end