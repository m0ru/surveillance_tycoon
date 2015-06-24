
var riot = require('riot');
var actions = new (require('./actions.js'))();

module.exports = ProfitStore
function ProfitStore() {
  if ( arguments.callee._singletonInstance )
      return arguments.callee._singletonInstance;
  arguments.callee._singletonInstance = this;

  // Make instances observable
  riot.observable(this);

  var profit = 0;
  this.get = function() {      return profit;  }  actions.on(actions.SELL_CCTV, function() {    console.log("selling; profit store");    profit += 100000 * ( 1 + Math.random());    this.trigger("change")  }.bind(this));}