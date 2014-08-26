var page = require('webpage').create(),
  system = require('system');

if (system.args.length === 1) {
  console.log('Usage: phantom.js <path>');
  phantom.exit();
}

var host = 'http://localhost:4567/';
var path = system.args[1];

var pass = 'pass';
var fail = 'fail';

page.open(host + path, function (status) {

  if (status === 'fail') { console.log(fail); phantom.exit(); return; }

  var txt = page.evaluate(function () {
    var nameEl = document.getElementById('gadget-name');
    return nameEl ? nameEl.textContent : '';
  });

  console.log(txt === 'Max' ? pass : fail);

  phantom.exit();

});
