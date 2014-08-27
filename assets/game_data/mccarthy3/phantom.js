var page = require('webpage').create(),
  system = require('system');

if (system.args.length === 1) {
  console.log('Usage: phantom.js <path>');
  phantom.exit();
}

var host = 'http://localhost:8000/';
var path = system.args[1];

var pass = 'pass';
var fail = 'fail';

page.open(host + path, function (status) {

  if (status === 'fail') { console.log(fail); phantom.exit(); return; }

  var txt = page.evaluate(function () {
    var nameEl = document.getElementById('logo');
    return nameEl ? nameEl.innerHTML : '';
  });

    console.log(txt === 'Hacker School!' ? pass : fail);

  phantom.exit();

});
