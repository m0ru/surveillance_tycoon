require('leaflet');
require('./state-info-box.tag');
var utils = require('./utils');
var statesData = require('./us-states-data');
var actions = new (require('./actions.js'))();
var personas = require('./personas');

<leaflet>
    <div id="mapcanvas" class="fill-parent"></div>

    <style scoped>
        .info {
            width: 20em;
        }
        .info {
            padding: 6px 8px;
            font: 14px/16px Arial, Helvetica, sans-serif;
            background: white;
            background: rgba(255,255,255,0.8);
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
            border-radius: 5px;
        }
        .info h4 {
            margin: 0 0 5px;
            color: #777;
        }
        .info .portrait {
            width: 100px;
        }

        .legend {
            line-height: 18px;
            color: #555;
        }
        .legend i {
            width: 18px;
            height: 18px;
            float: left;
            margin-right: 8px;
            opacity: 0.7;
        }
    </style>

    //Webpack/Browserify fix:
    L.Icon.Default.imagePath = '../node_modules/leaflet/dist/images/';


    function getColor(d) {
        //colorscheme via http://colorbrewer2.org/
        return d > 1000 ? '#800026' :
               d > 500  ? '#BD0026' :
               d > 200  ? '#E31A1C' :
               d > 100  ? '#FC4E2A' :
               d > 50   ? '#FD8D3C' :
               d > 20   ? '#FEB24C' :
               d > 10   ? '#FED976' :
                          '#FFEDA0';
    }

    function styleState(feature) {
        return {
            fillColor: getColor(feature.properties.density),
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.7
        };
    }

    var info;

    function highlightFeature(e) {
        var layer = e.target;

        layer.setStyle({
            weight: 5,
            color: '#666',
            dashArray: '',
            fillOpacity: 0.7
        });

        if (!L.Browser.ie && !L.Browser.opera) {
            layer.bringToFront();
        }

        info.update(layer.feature.properties);
    }

    var geojson;
    function resetHighlight(e) {
        geojson.resetStyle(e.target);
        info.update();
    }

    var zoomToFeature = function (e) {
        this.map.fitBounds(e.target.getBounds());
    }.bind(this);

    var sellToState = function(e) {
      actions.trigger(actions.SELL_CCTV);
    }

    function onEachFeature(feature, layer) {
        layer.on({
            mouseover: highlightFeature,
            mouseout: resetHighlight,
            click: sellToState
        });
    }



    this.on('mount', function() {

        // based on tutorial: http://leafletjs.com/examples/choropleth.html

        // create a map in the "mapcanvas" div, set thev iew to a given place and zoom
        //US
        this.map = L.map(this.mapcanvas)
                   .setView([37.8, -96], 4);
        //Vienna: this.map = L.map(this.mapcanvas).setView([48.19803, 16.35466], 13);



        // add an OpenStreetMap tile layer
        L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this.map);

        /*
        //Alternative Layer
        L.tileLayer('http://{s}.tiles.mapbox.com/{id}/{z}/{x}/{y}.png', {
            id: 'examples.map-20v6611k',
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this.map);
        */

        geojson = L.geoJson(statesData, {
            style: styleState,
            onEachFeature: onEachFeature
        }).addTo(this.map);

        info = L.control();
        info.onAdd = function (map) {
            this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
            this.update();
            return this._div;
        };


        var personalStoryHTML = function(){
            var p = personas.randomPersona();

            // TODO adapt by number of cctv cams in that country.
            // TODO have second, pro cctv persona
            return '\
                <p>In this state lives:</p> \
                <h4>' + p.name + '</h4> \
                <p>' + p.text.baseSurveillance + '</p> \
                <div><img class="portrait" src="./app/' + p.image + '"></img></div> '
        }

        // method that we will use to update the control based on feature properties passed
        info.update = function (props) {
            this._div.innerHTML = '<state-info-box></state-info-box><h4>US Population Density</h4>' +  (props ?
                '<b>' + props.name + '</b><br />' + props.density + ' people / mi<sup>2</sup><br/>' + personalStoryHTML()
                : 'Hover over a state');

            riot.mount('state-info-box');//TODO doesn't mount :|
        };



        info.addTo(this.map);

        var legend = L.control({position: 'bottomright'});

        legend.onAdd = function (map) {

            var div = L.DomUtil.create('div', 'info legend'),
                grades = [0, 10, 20, 50, 100, 200, 500, 1000],
                labels = [];

            // loop through our density intervals and generate a label with a colored square for each interval
            for (var i = 0; i < grades.length; i++) {
                div.innerHTML +=
                    '<i style="background:' + getColor(grades[i] + 1) + '"></i> ' +
                    grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
            }

            return div;
        };

        legend.addTo(this.map);
    });

    /*
    Discrete or continous map?

    discrete:
      * easier to click
      * population density is discrete (e.g. per district)
      * need to visualise camera-density somehow
      * mouseover to ge stories of sample residents

    continous:
      * requires some sort of mechanic to spread out the placed items (e.g. bounding boxes / areas of effect)
      * requires placing houses / interface elements that show stories of sample residents

    */


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
