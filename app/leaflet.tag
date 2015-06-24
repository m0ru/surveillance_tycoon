require('leaflet');
require('./state-info-box.tag');
var utils = require('./utils');
var statesData = require('./us-states-data');
var actions = new (require('./actions.js'))();
var personas = require('./personas');
UsStateStore = require('./us-state-store');

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

    var usStateStore = new UsStateStore();
    statesData = usStateStore.get();


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
    function getColorByCctvLevel(lvl) {
      return lvl < 1 ? '#c6dbef' :
             lvl < 2 ? '#9ecae1' :
             lvl < 3 ? '#6baed6' :
             lvl < 4 ? '#3182bd' :
                       '#08519c';
/*
        return lvl < 1 ? '#d9d9d9' :
               lvl < 2 ? '#bdbdbd' :
               lvl < 3 ? '#969696' :
               lvl < 4 ? '#636363' :
                         '#252525';
                         */
    }

    function styleState(feature) {
        return {
            fillColor: getColorByCctvLevel(feature.properties.cctvCount),
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.8
        };
    }

    var info;

    var displayedState;
    var activeLayer;
    function highlightFeature(e) {
        var layer = e.target;

        layer.setStyle({
            weight: 5,
            dashArray: '',
            fillOpacity: 0.7
        });

        if (!L.Browser.ie && !L.Browser.opera) {
            layer.bringToFront();
        }

        displayedState = layer.feature.properties;
        activeLayer = layer;
        info.update(displayedState);
    }

    var geojson;
    function resetHighlight(e) {
        geojson.resetStyle(e.target);
        displayedState = undefined;
        activeLayer = undefined;
        info.update(displayedState);
    }

    var sellToState = function(e) {
        var state = e.target.feature.properties.name;
        //info.update();
        actions.trigger(actions.SELL_CCTV, state);
    }

    function onEachFeature(feature, layer) {
        layer.on({
            mouseover: highlightFeature,
            mouseout: resetHighlight,
            click: sellToState
        });
    }


    usStateStore.on("change", function(){
        activeLayer.setStyle({});
        geojson.resetStyle(activeLayer);
        info.update(displayedState);
    });

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


        var personalStoryHTML = function(props){
            var p = props.persona;
            // TODO adapt by number of cctv cams in that country.
            var level = (props.cctvCount < p.criticalCount)?
                "baseSurveillance" : "totalSurveillance"

            return '\
                <p>In this state lives:</p> \
                <h4>' + p.name + '</h4> \
                <p>' + p.text[level] + '</p> \
                <div><img class="portrait" src="./app/' + p.image + '"></img></div> '
        }
        var cctvHTML = function(props) {
            return '<p>Surveillance-Level: <b>' + props.cctvCount + '</b></p>';
        }

        // method that we will use to update the control based on feature properties passed
        info.update = function (props) {
            this._div.innerHTML = (props ?
                '<b>' + props.name + '</b><br />' + props.density + ' people / mi<sup>2</sup><br/>' + cctvHTML(props) + personalStoryHTML(props)
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
