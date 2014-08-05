# sinatra app
# use sqlite
# guestbook
# -> backtick to a markdown parser
require 'date'
require 'sinatra'

class Guestbook
  attr_accessor :comments
  def initialize
    @comments = []
  end
  def markdownify(string)
    string = filter_bad_chars(string)
    `./Markdown.pl <<< #{string}`
  end

  def comment(name, string)
    comments << {name: name, comment: markdownify(string), timestamp: DateTime.now}
  end

  def filter_bad_chars(string)
    # Get rid of semi-colons, quotes, and ampersands so they can't hack us
    string.gsub(/[;"&]/,"")
  end
  
end

guestbook = Guestbook.new

get '/' do
  erb :index, {locals: {comments: guestbook.comments}}
end

post '/guestbook/comments' do
  guestbook.comment(params[:name], params[:comment])
  redirect '/'
end

__END__

@@ layout
<html>
    <head>
        <title>My Hackathon Guestbook</title>
    </head>
    <body>
        <%= yield %>
    </body>
</html>

@@ index
<h1>Hacker School Guestbook</h1>
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
