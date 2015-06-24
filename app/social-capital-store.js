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


  actions.on(actions.SELL_CCTV, function(state) {
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

  function chiSquaredK4(x) {
    if (x <= 0)
        return 0;
    else
        return 1 /  4 * x * Math.exp(-x / 2);
        //return 1 / 2 * Math.exp(- x / 2);
  }

  var BASE_LEVEL = 0.15;
  this.resentmentPerSecond = function() {
    // strong regen if it barely goes over the base_level, the regen lessens
    // at higher levels, close to the protest line (1.0)

    var delta = Math.abs(resentment - BASE_LEVEL);

    var rate = chiSquaredK4(delta * 12) / 3;

    if(delta < 0.002) {
      return 0;
    } else if (resentment < BASE_LEVEL) {
      return rate;
    } else { // resentment > BASE_LEVEL
      return -rate;
    }
  }
}
