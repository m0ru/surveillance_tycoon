require('./app.tag');
var riot = require('riot');

global.window.riot = riot; //TODO deletme; for testing
//require('../node_modules/leaflet/dist/leaflet.css');
//require('../node_modules/riot/riot+compiler.js');

riot.mount('*');

riot.update(); // TODO this should not be necessary, but the markers won't appear otherwise
