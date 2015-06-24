require('./app.tag');
var riot = require('riot');
var actions = new (require('./actions.js'))();

SocialCapitalStore = require('./social-capital-store');
ProfitStore = require('./profit-store');

global.window.riot = riot; //TODO deletme; for testing
//require('../node_modules/leaflet/dist/leaflet.css');
//require('../node_modules/riot/riot+compiler.js');


var oldMs = Date.now();
var tick = setInterval(function() {
    var newMs = Date.now();
    var deltaSeconds = (newMs - oldMs) / 1000.0;
    oldMs = newMs;

    actions.trigger(actions.TICK, deltaSeconds);
}, 200);

riot.mount('*');

riot.update(); // TODO this should not be necessary, but the markers won't appear otherwise


// <END-OF-GAME-CHECK> ----------------------------------------
var scs = new SocialCapitalStore();
var ps = new ProfitStore();
scs.on('change', function(){
  if(scs.get() >= 0.98) {
    alert(
      "Your advances were so overt and aggravating that the " +
      "populace actually got off their bums to sanction you " +
      "and your elected buddies via their votes. You probably " +
      "should have minded their protests. Still, you have " +
      "managed to extract a fine profit of: \n\n" + ps.get() + "€");
    global.window.document.location.reload();
  }
});
// </END-OF-GAME-CHECK> ----------------------------------------
