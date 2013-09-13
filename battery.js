var arDrone = require('ar-drone');

//end web server stuff

var client = arDrone.createClient();

client.config('general:navdata_demo', true);
client.on('batteryChange', function(e){
  console.log(e);
    client.stop();
      process.exit(0);
      });
