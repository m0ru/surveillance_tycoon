var riot = require('riot');
var actions = new (require('./actions.js'))();

module.exports = SocialCapitalStore
function SocialCapitalStore() {
  if ( arguments.callee._singletonInstance )
      return arguments.callee._singletonInstance;
  arguments.callee._singletonInstance = this;

  // Make instances observable
  riot.observable(this);

  var socialCapital = 0.0;
  actions.on(actions.TICK, function(deltaSeconds) {
      var oldSC = socialCapital;

      socialCapital += 0.1 * deltaSeconds;
      socialCapital = Math.min(Math.max(socialCapital, 0.0), 1.0)

      if(oldSC != socialCapital)
          this.trigger("change");
  }.bind(this))

  var CHANGE_EVENT = 'change'
  /*this.emitChange = function() {
    this.trigger(CHANGE_EVENT)
  }
  this.addChangeListener = function(callback) {
    this.on(CHANGE_EVENT, callback)
  }
  this.removeChangeListener = function(callback) {
    this.off(CHANGE_EVENT, callback)
}*/

  var socialCapital = 0.0;
  this.get = function() {
      return socialCapital;
  }
}
