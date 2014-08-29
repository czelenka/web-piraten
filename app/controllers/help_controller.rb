# -*- encoding : utf-8 -*-
class HelpController < ApplicationController

  def index
    unless params[:file]
      redirect_to :controller => :help, :action => :index, :file => :index
      return
    end
    
    filename = params[:file]
    contend = ''
    begin
      File.open("help/#{filename}.md") do |file|
        contend = file.read
      end
    rescue
      redirect_to :controller => :help, :action => :index, :file => :index
      return
    else
      @code = Markdown.new(contend).to_html
      puts @code
    end
  end

end
