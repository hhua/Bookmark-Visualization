require 'net/http'
require 'json'
require 'open-uri'

#Author hhua.dev@gmail.com

api_token = ARGV
xml = File.open("./data/suggest.xml");
puts xml.read();

def count_commnets(comment_array)
	comment_array.size % 20
end
	
def thread_data(board, tnum)
	url = URI.parse('http://api.4chan.org/' + board.to_s + '/res/' + tnum.to_s + '.json')
	return Net::HTTP.get(url)
end

#return the likelyhood of a meme from 1-10
def meme_factor(board, tnum)
	data = JSON.parse(thread_data(board, tnum))
	count_comments(data["posts"])
end
