require 'rubygems'
require 'sinatra'
require 'redcloth'
require 'page'

HOME_PAGE = 'Evento'

HOME_SLOGAN = 'Encuentro de desarrolladores Ruby'

configure do
  set :generated_menu, Page.generate_menu
end

get '/' do
  render_page(HOME_PAGE)
end

get '/:page_name' do
  render_page(params[:page_name])
end

helpers do
  
  def menu
    settings.generated_menu
  end
  
  def html_title
    request.path == '/' ? HOME_SLOGAN : @title
  end
  
  private
  
  def render_page(name)
    @title, @body = Page.new(name).to_a
    erb :page
  end
  
end