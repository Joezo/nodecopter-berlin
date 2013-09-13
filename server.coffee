express = require('express')
fs      = require('fs')
app     = express()

app.get '/', (req, res) ->
  renderPage(res, 'view/index.html', 'text/html')

renderPage = (res, file, type) ->
  page = fs.readFileSync(file)
  renderString(res, page, type)

renderString = (res, data, type) ->
  res.setHeader('Content-Type', type)
  res.setHeader('Content-Length', data.length)
  res.end(data)

app.listen(3000)
