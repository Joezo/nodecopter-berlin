express = require('express')
fs      = require('fs')
app     = express()
PORT    = 3000;

app.get '/', (req, res) ->
  renderPage(res, 'view/index.html', 'text/html')

renderPage = (res, file, type) ->
  page = fs.readFileSync(file)
  renderString(res, page, type)
  console.log("Rendered", file, type)

renderString = (res, data, type) ->
  res.setHeader('Content-Type', type)
  res.setHeader('Content-Length', data.length)
  res.end(data)

app.listen(PORT)

console.log("Listening on localhost:#{PORT}")
