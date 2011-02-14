class Page
  
  def initialize(name)
    @url = name.to_url
    @file_content = File.read(File.join(File.dirname(__FILE__), 'pages', "#{@url}.textile"))
    @title = title
    @content = content
  end
  
  def to_a
    [@title, @content]
  end
  
  def self.generate_menu
    Dir[File.join(File.dirname(__FILE__), 'pages', '*.textile')].collect do |page_file|
      ordered_menu_list_items(page_file.to_url, File.read(page_file).match(/h1. (?:\[(\d+)\] )?(.*)/))
    end.compact.sort_by{|list_item| list_item.first}.collect{|list_item| list_item[1]}.join(' ')
  end
  
  def self.ordered_menu_list_items(url, title_match)
    unless title_match.nil?
      order = title_match[1].to_i || rand(1000)
      list_item = %|<li><a href='#{url}'>#{title_match[2]}</a></li>|
      [order, list_item]
    end
  end
  
  private 
  
  def urlize(name)
    name
  end
  
  def title()
    @file_content.match(/h1. (?:\[\d+\] )?(.*)/)[1]
  end
  
  def content()
    content = RedCloth.new(@file_content.gsub(/h1. (.*)/, '')).to_html
    content.gsub(/<a/, "<a target='_blank' ")
  end
  
end

class String
  def to_url
    "/#{split('/').last.gsub('.textile', '').downcase.gsub(' ', '_')}"
  end
end