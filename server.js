var express = require('express');
var fs = require('fs');
var app = express();

app.get('/', function(req, res){
	renderPage(res, 'view/index.html', 'text/html');
});

//display a page to the browser
function renderPage(res, file, type) {
  var page = fs.readFileSync(file);
  renderString(res, page, type);
}

//display a string to the browser
function renderString(res, data, type){
	res.setHeader('Content-Type', type);
	res.setHeader('Content-Length', data.length);
	res.end(data);	
}

app.listen(3000);
