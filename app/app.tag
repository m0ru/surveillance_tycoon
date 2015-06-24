require('./leaflet.tag');
require('./social-capital-meter.tag');
var actions = new (require('./actions.js'))();
ProfitStore = require('./profit-store')
var utils = require('./utils')

<app>
    <social-capital-meter></social-capital-meter>
    <br><br><br>
    <h1>Profit so far: <b>{ utils.numberWithCommas(profit) }$</b></h1>
    <leaflet class="screen-sized"></leaflet>

    var profitStore = new ProfitStore();
    this.profit = 0;
    profitStore.on("change", function(){
      this.update({profit: Math.floor(profitStore.get())});
    }.bind(this));
</app>
