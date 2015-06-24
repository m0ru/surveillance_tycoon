var riot = require('riot');
var actions = new (require('./actions.js'))();
var statesData = require('./us-states-data');
var personas = require('./personas');

module.exports = UsStateStore
function UsStateStore() {
  if ( arguments.callee._singletonInstance )
      return arguments.callee._singletonInstance;
  arguments.callee._singletonInstance = this;

  // Make instances observable
  riot.observable(this);



  var statesGeoJSON = statesData;
  //secondary map for easier access
  // actually we should build the geoJSON from
  // this object on demand for the sake of
  // clarity. but w/e. it's a prototype.
  var states = {};

  //enrich data with personas and cctv count
  for(var i = 0; i < statesGeoJSON.features.length; i++){
      var p = statesGeoJSON.features[i].properties;
      p.persona = personas.randomPersona();
      p.cctvCount = 0;
      states[p.name] = p;
  }

  this.minCctvLevel = function() {
      if(!statesGeoJSON.features[0]) return 0;
      var min = statesGeoJSON.features[0].properties.cctvCount;
      for(var i = 0; i < statesGeoJSON.features.length; i++){
          var p = statesGeoJSON.features[i].properties;
          if(p.cctvCount < min)
            min = p.cctvCount;
      }
      return min;
  }
  this.maxCctvLevel = function() {
      var max = 0
      for(var i = 0; i < statesGeoJSON.features.length; i++){
          var p = statesGeoJSON.features[i].properties;
          if(p.cctvCount > max)
            max = p.cctvCount;
      }
      return max;
  }


  this.get = function() {      return statesGeoJSON;  }  this.getState = function(stateName) {      console.log(states);      return states[stateName];  }  actions.on(actions.SELL_CCTV, function(state) {      states[state].cctvCount += 1;      // get state as arg      // increase the cctv count there      this.trigger("change");  }.bind(this));}