require('./app.tag');
var riot = require('riot');
var actions = new (require('./actions.js'))();
var utils = require('./utils')

SocialCapitalStore = require('./social-capital-store');
ProfitStore = require('./profit-store');
UsStateStore = require('./us-state-store');

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

// <START-TEXT> -----------------------------------------------
    alert("You're playing a surveillance tycoon. Due to good contacts to the ruling parties and their willingness to increase surveillance, you can sell your products (CCTV, IMSI-catchers,...) to them and make good profit. The only hindrance to you and your elected buddies is a reluctant populace (expressed by the bar in the top right) that might sanction your network on the next voting day. Make sure not to push your products to strongly or they might revolt (red marker). Good luck and good profit!");
// </START-TEXT> -----------------------------------------------

// <END-OF-GAME-CHECK> ----------------------------------------
var scs = new SocialCapitalStore();
var ps = new ProfitStore();
var stateStore = new UsStateStore();
scs.on('change', function(){
    if(scs.get() >= 0.98) {
        alert(
            "Your advances were so overt and aggravating that the " +
            "populace actually got off their bums to sanction you " +
            "and your elected buddies with their votes at the urn. You probably " +
            "should have minded their protests. Still, you have " +
            "managed to extract a fine profit of: \n\n" + utils.numberWithCommas(ps.get()) + "$");
        global.window.document.location.reload();
    }
});

coverAchievmentEarned = false;
firstLv1AchievmentEarned = false;
stateStore.on('change', function(){
    console.log("Checking for victory - min: " +
        stateStore.minCctvLevel());
    console.log("Checking for victory - max: " +
        stateStore.maxCctvLevel());
    if (stateStore.maxCctvLevel() == 1 && !firstLv1AchievmentEarned) {
        firstLv1AchievmentEarned = true;
        alert("Your first surveillance-sytem! The first-step of your corporate empire.");
    }
    if (stateStore.minCctvLevel() >= 1 && !coverAchievmentEarned) { //TODO should be higher
        coverAchievmentEarned = true;
        alert("You've covered the US with your surveillance systems! (" +
            "And made fine profit while doing so: " +
            utils.numberWithCommas(ps.get()) + "$)");
    }
});
// </END-OF-GAME-CHECK> ----------------------------------------
