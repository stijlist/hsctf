# sinatra app
require 'sinatra'


get '/' do
  erb :index
end

__END__

@@ layout
<html>
    <head>
        <title>My Hacker Schmool Magic Trick</title>
        <script>
        function setInnerText(element, value) {
          if (element.innerText) {
            element.innerText = value;
          } else {
            element.textContent = value;
          }
        }
     
        function includeGadget(url) {
          var scriptEl = document.createElement('script');
     
          // This will totally prevent us from loading evil URLs!
          if (url.match(/^https?:\/\//)) {
            setInnerText(document.getElementById("gadget-name"),
              "Sorry, cannot load a URL containing \"http\".");
            return;
          }
     
          // Load this awesome gadget
          scriptEl.src = url;
     
          // Show log messages
          scriptEl.onload = function() { 
            console.log("Loaded gadget from " + url);
          }
          scriptEl.onerror = function() { 
            console.log("Couldn't load gadget from " + url);
          }
     
          document.head.appendChild(scriptEl);
        }
     
        // Take the value after # and use it as the gadget filename.
        function getGadgetPath() { 
          return window.location.hash.substr(1) || "/static/gadget.js";
        }
     
        includeGadget(getGadgetPath());
     
        // Extra code so that we can communicate submitted result to evaluation engine
        window.addEventListener("message", function(event){
          if (event.source == parent) {
            includeGadget(getGadgetPath());
          }
        }, false);
     
        </script>
    </head>
    <body>
        <%= yield %>
    </body>
</html>

@@ index
<h1>Hacker Schmool Gadgetz</h1>
Find a way to load an external .js file that will print your name on the page.
<h2 id="gadget-name">Your Name Here</h2>
