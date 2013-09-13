express = require('express')
fs      = require('fs')
drone   = require('ar-drone')
Interpreter = require('./lib/interpreter')
app     = express()
PORT    = 3000;

client = drone.createClient();

app.use(express.static('assets'))
app.use(express.bodyParser())

app.get '/', (req, res) ->
  renderPage(res, 'view/index.html', 'text/html')

app.post '/die', (req, res) ->
  console.log('landing the drone')
  client.stop()
  client.land()
  res.end()

app.post '/takeoff', (req, res) ->
  console.log('drone takeoff')
  client.takeoff()
  client.animateLeds('redSnake', 5, 2)
  res.end()   

app.post '/command', (req, res) ->
  client.stop()
  client.disableEmergency()
  interpretor = new Interpreter(client)
  result = interpretor.interpret(req.body.text)
  if !result
    client.animateLeds('blinkRed', 5, 2)
    res.status(405).end()
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

app.use ( err, req, res, next ) ->
  res.status(500)
  res.end()

app.listen(PORT)

console.log("Listening on localhost:#{PORT}")
