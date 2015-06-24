var riot = require('riot');
var actions = new (require('./actions.js'))();

module.exports = SocialCapitalStore
function SocialCapitalStore() {
  if ( arguments.callee._singletonInstance )
      return arguments.callee._singletonInstance;
  arguments.callee._singletonInstance = this;

  // Make instances observable
  riot.observable(this);
  var CHANGE_EVENT = 'change'

  var resentment = 0.0;
  actions.on(actions.TICK, function(deltaSeconds) {
      var oldSC = resentment;

      increaseResentment(deltaSeconds * this.resentmentPerSecond());

      if(oldSC != resentment)
          this.trigger("change");
  }.bind(this))


  actions.on(actions.SELL_CCTV, function() {
    increaseResentment(0.2);
  }.bind(this))

  var resentment = 0.15;
  this.get = function() {
      return resentment;
  }
  function increaseResentment(delta) {
      resentment += delta;
      resentment = Math.min(Math.max(resentment, 0.0), 1.0);
  }


  var BASE_LEVEL = 0.15
  this.resentmentPerSecond = function() {
    // strong regen if it barely goes over the base_level, the regen lessens
    // at higher levels, close to the protest line (1.0)
    //return - 0.05 - 0.25 * (1 - (resentment - BASE_LEVEL) / (1 - BASE_LEVEL))
    //0.05 to 0.3

    if(resentment < BASE_LEVEL)
      return 0.01;
    else
      return -0.01;
  }
}
