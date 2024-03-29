# sinatra app
# use sqlite
# guestbook
# -> backtick to a markdown parser
require 'date'
require 'sinatra/base'




class Guestbook
  attr_accessor :comments
  def initialize
    @comments = []
  end
  def markdownify(string)
    string = filter_bad_chars(string)
    `echo #{string} | ./Markdown.pl`
  end

  def comment(name, string)
    comments << {name: name, comment: markdownify(string), timestamp: DateTime.now}
  end

  def filter_bad_chars(string)
    # Get rid of semi-colons, quotes, and ampersands so they can't hack us
    string.gsub(/[;"&]/,"")
  end
  
end

class App < Sinatra::Base
  configure do
    @@guestbook = Guestbook.new
  end

  template :layout do
    """
<html>
<head>
<title>My Hackathon Guestbook</title>
</head>
<body>
<%= yield %>
</body>
</html>
"""
  end

template :index do
  """
<h1>Hacker Schmool Guestbook</h1>
What do you think of Hacker Schmool?
<form action='/guestbook/comments' method='POST'>
    <label>Name: </label>
    <input type='text' name='name'>
    <label>Comment: </label>
    <input type='text' name='comment'>
    <input type='submit'>
</form>
            
<% comments.each do |comment| %>
  <div>
   <p>Name: <%= comment[:name] %></p>
   <p><%= comment[:comment] %> Time: <%= comment[:timestamp] %> 
<% end %>
"""
end

  get '/' do
    erb :index, {locals: {comments: @@guestbook.comments}}
  end

  post '/guestbook/comments' do
    @@guestbook.comment(params[:name], params[:comment])
    redirect '/'
  end

  def self.run!
    rack_handler_config = {}

    ssl_options = {
      :private_key_file => './ssl/server.key',
      :cert_chain_file => './ssl/server.crt',
      :verify_peer => false,
    }

    Rack::Handler::Thin.run(self, rack_handler_config) do |server|
      server.ssl = true
      server.ssl_options = ssl_options
    end
  end
end

App.run!
