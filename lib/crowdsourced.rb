require 'rubygems'
require 'cassandra'
 
store = Cassandra.new('CrowdSourced');

store.insert(:Tweets, 'tweet1', { 'author' => 'Bruno'});
store.insert(:Tweets, 'tweet1', { 'text' => 'That is my first tweet'});
store.insert(:Tweets, 'tweet1', { 'url' => 'www.google.com.au'});
 
# query information
user = store.get(:Tweets, 'tweet1')
 
# show result
user.each do |field|
  puts field.inspect
end
 
# remove entries
store.remove(:Tweets, 'tweet1')