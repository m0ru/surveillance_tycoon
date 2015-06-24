require('./leaflet.tag');
require('./social-capital-meter.tag');
var actions = new (require('./actions.js'))();
ProfitStore = require('./profit-store')

<app>
    <social-capital-meter></social-capital-meter>
    <br><br><br>
    <p>Profit so far: { profit }€</p>
    <leaflet class="screen-sized"></leaflet>

    var profitStore = new ProfitStore();
    this.profit = 0;
    profitStore.on("change", function(){
      this.update({profit: Math.floor(profitStore.get())});
    }.bind(this));
</app>
