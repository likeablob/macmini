const Gpio = require('orange-pi-gpio');
const fetch = require('node-fetch')

let gpio5 = new Gpio({pin:7, mode: 'in'});

prev = 0
setInterval(function () {
  gpio5.read()
  .then((state)=>{
    state = parseInt(state)
    if (state !== prev && state === 0) {
      console.log("push");
      fetch("http://localhost:5501/").catch((err) => {console.log(err);})
    }
    prev = state
  });
}, 100);
