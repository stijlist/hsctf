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
    `echo #{string} | ./Markdown.pl`
  end

  def comment(name, string)
    comments << {name: name, comment: markdownify(string), timestamp: DateTime.now}
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
<h1>My Hackathon Guestbook</h1>
I'm getting married. Leave a message about how much you love me!
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
