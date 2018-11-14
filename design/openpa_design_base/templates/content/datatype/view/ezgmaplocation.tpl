<div id="map-{$attribute.id}" style="width: 100%; height: 280px;"></div>
{run-once}
{literal}
<script type="text/javascript">
  var drawMap = function(latlng,id){
    var map = new L.Map('map-'+id);
    map.scrollWheelZoom.disable();
    var customIcon = L.MakiMarkers.icon({icon: "star", color: "#f00", size: "l"});
    var postMarker = new L.marker(latlng,{icon:customIcon});
    postMarker.addTo(map);
    map.setView(latlng, 18);
    L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
  }
</script>
{/literal}
{/run-once}

<script type="text/javascript">
drawMap([{$attribute.content.latitude},{$attribute.content.longitude}],{$attribute.id});
</script>
