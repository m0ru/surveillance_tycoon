require('leaflet');

<leaflet>
     <div id="mapcanvas" class="fill-parent"></div>

      //Webpack/Browserify fix:
      L.Icon.Default.imagePath = '../node_modules/leaflet/dist/images/';

    this.on('mount', function() {
      // create a map in the "mapcanvas" div, set the v iew to a given place and zoom
      this.map = L.map(this.mapcanvas)
                 .setView([48.19803, 16.35466], 13);

      // add an OpenStreetMap tile layer
      L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
          attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map);

      // Force it to adapt to actual size
      // for some reason this doesn't happen by default
      // when the map is within a tag.
      // this.map.invalidateSize();
      // ^ doesn't work (needs to be done manually atm);

    });

    // there's a map.locate!!!
    // and fitBounds that fit allow fitting an area
    // eachLayer(m) / hasLayer(m) for diffing?


    //--- restaurant-markers to map ----------

    var markers = [];
    this.on('update', function() {
      // TODO find a way to do react/riot style diffing (instead of readding a lot of markers)
      // remove all current markers
      for (var i = 0; i < markers.length; i++) {
        this.map.removeLayer(markers[i]);
      }
      markers = [];

      //TODO add markers here
    });
</leaflet>
