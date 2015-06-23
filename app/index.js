require('./app.tag');
var riot = require('riot');
var actions = new (require('./actions.js'))();


global.window.riot = riot; //TODO deletme; for testing
//require('../node_modules/leaflet/dist/leaflet.css');
//require('../node_modules/riot/riot+compiler.js');


var oldMs = Date.now();
var tick = setInterval(function() {
    var newMs = Date.now();
    var deltaSeconds = (newMs - oldMs) / 1000.0;
    oldMs = newMs;

    //trigger action TODO
    actions.trigger(actions.TICK, deltaSeconds);
}, 1000);

riot.mount('*');

riot.update(); // TODO this should not be necessary, but the markers won't appear otherwise
