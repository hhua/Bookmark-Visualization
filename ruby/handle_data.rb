require 'rexml/document'

class Post
	
	def initialize(href, time, description, tags)
		@href = href
		@time = time
		@description = description
		@tags = tags.split(' ')
	end

	attr_reader :href
	attr_reader :time
	attr_reader :description
	attr_reader :tags
end

doc = REXML::Document.new File.new('../data/tags.xml')

tags = {}

doc.elements.each('tags/tag') do |element| 
	if not element.attributes["tag"].eql? ""
		tags[element.attributes["tag"]] = element.attributes["count"].to_i
	end
end

posts = [] 
post_doc = REXML::Document.new File.new('../data/posts.xml')

post_doc.elements.each('posts/post') do |element|
	post = Post.new(element.attributes["href"], element.attributes["time"],element.attributes["description"], element.attributes["tag"])
	posts.push(post)
end

tags_month = {}
for tag in tags
	tag_month = {}
	for post in posts
		for each_tag in post.tags
			if tag[0].eql? each_tag
				date = post.time[0..6]	
				if not tag_month[date]
					tag_month[date] = 1
				else
					tag_month[date] += 1
				end
			end
		end
	end
	tags_month[tag[0]] = tag_month
end
puts tags_month

#api_token = ARGV
#xml = File.open("../data/tags.xml");
#puts xml.read();
