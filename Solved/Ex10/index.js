'use strict';

var app = Elm.Ex10.init({
  node: document.getElementById('main'),
  flags: {
    name: 'Me',
    email: 'me@example.com'
  }
});

app.ports.notifyJs.subscribe(function (word) {
  console.log(word);
});

app.ports.notifiedByJs.send('value');
