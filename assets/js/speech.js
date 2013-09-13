var recognition = new webkitSpeechRecognition();
recognition.continuous = true;
recognition.interimResults = true;
var start_timestamp;
var ignore_onend;
var interim_transcript;
var recognizing = false;

recognition.onstart = function() {
  recognizing = true;
  console.log("Listening now, so speck")
};

recognition.onerror = function(event) {
  if (event.error == 'no-speech') {
    console.log('No speech?')
    ignore_onend = true;
  }
  if (event.error == 'audio-capture') {
    console.log('No microphone?');
    ignore_onend = true;
  }
  if (event.error == 'not-allowed') {
    if (event.timeStamp - start_timestamp < 100) {
      console.log('Blocked?')
    } else {
      console.log("Denied?!")
    }
    ignore_onend = true;
  }
};

recognition.onend = function() {
  recognizing = false;
  if (ignore_onend) {
    return;
  }
};

recognition.onresult = function(event) {
  var interim_transcript = '';
  if (typeof(event.results) == 'undefined') {
    recognition.onend = null;
    recognition.stop();
    console.log('Something went horrendously wrong');
    return;
  }
  for (var i = event.resultIndex; i < event.results.length; ++i) {
    if (event.results[i].isFinal) {
      sendCommand(event.results[i][0].transcript)
    } else {
      interim_transcript += event.results[i][0].transcript;
    }
  }
  console.log('Interim transcript:', interim_transcript);
};

function stopButton(){
  recognition.stop();
  recognizing = false;
  return;
}

function startButton(){
  if (recognizing) {
    recognition.stop();
    return;
  }
  recognition.lang = 'en-US';
  recognition.start();
  ignore_onend = false;
  start_timestamp = event.timeStamp;
}

function sendCommand(text){
  console.log("Going to send", text);
}
