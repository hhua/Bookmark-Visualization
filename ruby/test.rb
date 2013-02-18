require 'rexml/document'
require 'json'

# hhua.dev@gmail.com

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

limited_tags = {}
for key in tags.keys
	if tags[key] >= 6
		limited_tags[key] = tags[key]
	end
end

puts limited_tags.length
tags = limited_tags

mapping = {}
mapping_doc = REXML::Document.new File.new('../data/mapping.xml')

mapping_doc.elements.each('dates/date') do |element|
	mapping[element.attributes["date"]] = element.attributes["order"].to_i
end

posts = [] 
post_doc = REXML::Document.new File.new('../data/posts.xml')

post_doc.elements.each('posts/post') do |element|
	post = Post.new(element.attributes["href"], element.attributes["time"],element.attributes["description"], element.attributes["tag"])
	posts.push(post)
end

tags_month = {}
tag_post = {}
for tag in tags
	tag_month = {}
	post_list = []
	for post in posts
		isTag = false
		for each_tag in post.tags
			if tag[0].eql? each_tag
				isTag = true
				date = post.time[0..6]	
				if not tag_month[date]
					tag_month[date] = 1
				else
					tag_month[date] += 1
				end
			end
		end
		if isTag
			post_item = {}
			post_item["description"] = post.description
			post_item["href"] = post.href
			post_list.push(post_item)
		end
	end
	tag_post[tag[0]] = post_list
	tags_month[tag[0]] = tag_month 
end
# puts tags_month
# puts tag_post

# write into JSON file
File.open("../viz/tag-post.json","w") do |f|
	f.write(tag_post.to_json)
end

tag_detail = {}
for key in tags_month.keys
	month_count = tags_month[key]
	month_list = []
	for month in month_count.keys
		each_month = {}		
		each_month["month"] = month
		each_month["count"] = month_count[month]
		each_month["order"] = mapping[month]
		month_list.push(each_month)
	end
	tag_detail[key] = month_list
end
# puts tag_detail

File.open("../viz/tag-detail.json","w") do |f|
	f.write(tag_detail.to_json)
end

all_tags = []
for tag in tags
	detail = tag_detail[tag[0]]
	for date in detail
		entry = {}
		entry["all_count"] = tag[1]
		entry["month"] = date["month"]
		entry["count"] = date["count"]
		entry["order"] = date["order"]
		entry["tag"] = tag[0]
		all_tags.push(entry)
	end
end
#puts all_tags

File.open("../viz/all-tags.json","w") do |f|
	f.write(all_tags.to_json)
end


