express = require('express')
fs      = require('fs')
drone   = require('ar-drone')
Interpreter = require('./lib/interpreter')
app     = express()
PORT    = 3000;

app.use(express.static('assets'))
app.use(express.bodyParser())

app.get '/', (req, res) ->
  renderPage(res, 'view/index.html', 'text/html')

app.post '/command', (req, res) ->
  interpretor = new Interpreter
  result = interpretor.interpret(req.body.text)
  if !result
    res.status(404).end()
  else
    res.end()
  console.log('result', result)

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
