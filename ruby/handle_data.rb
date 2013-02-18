require 'rexml/document'

doc = REXML::Document.new File.new('../data/tags.xml')

doc.elements.each('tags/tag') do |element| 
	puts element.attributes["tag"]
end

#api_token = ARGV
#xml = File.open("../data/tags.xml");
#puts xml.read();
