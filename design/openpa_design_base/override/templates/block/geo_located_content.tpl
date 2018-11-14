{if and( is_set( $block.custom_attributes.limit ), 
            ne( $block.custom_attributes.limit, '' ) )}
    {def $limit = $block.custom_attributes.limit}
{else}
    {def $limit = '5'}
{/if}

{if and( is_set( $block.custom_attributes.width ), 
            ne( $block.custom_attributes.width, '' ) )}
    {def $width = $block.custom_attributes.width}
{else}
    {def $width = '460'}
{/if}

{if or( $width|ends_with('px'), $width|ends_with('%') )|not()}
    {set $width = concat( $width, 'px' )}
{/if}

{if and( is_set( $block.custom_attributes.height ), 
            ne( $block.custom_attributes.height, '' ) )}
    {def $height = $block.custom_attributes.height}
{else}
    {def $height = '600'}
{/if}

{if or( $height|ends_with('px'), $height|ends_with('%') )|not()}
    {set $height = concat( $height, 'px' )}
{/if}


<h2 class="block-title">{$block.name|wash()}</h2>
<div class="float-break">
    <div id="block-map-{$block.id}" class="block-map" style="float: left; width: {$width}; height: {$height}"></div>
    <div class="block-markers" style="float: left; width: 30%; margin-right:5px"><ul id="block-markers-{$block.id}"></ul></div>
</div>

<script>
{run-once}
{literal}
var loadMap = function(mapId,markersId,geoJson){
    var tiles = L.tileLayer('//{s}.tile.osm.org/{z}/{x}/{y}.png', {maxZoom: 18,attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'});
    var map = L.map(mapId).addLayer(tiles);
    map.scrollWheelZoom.disable();
    var markers = L.markerClusterGroup();
    var markerMap = {};
    $.getJSON(geoJson, function(data) {
        $.each(data.features, function(i,v){
            var markerListItem = $("<li data-id='"+v.id+"'><a href='"+v.properties.url+"'><small style='display:none'>"+v.properties.className+"</small> "+v.properties.name+"</a></li>");
            markerListItem.bind('click',markerListClick);
            $('#'+markersId).append(markerListItem);
        });
        var geoJsonLayer = L.geoJson(data, { pointToLayer: function (feature, latlng) {
                var customIcon = L.MakiMarkers.icon({icon: "star", color: "#f00", size: "l"});
                var marker = L.marker(latlng, {icon: customIcon});
                markerMap[feature.id] = marker;
                return marker;
            } });
        markers.addLayer(geoJsonLayer);
        map.addLayer(markers);
        map.fitBounds(markers.getBounds());
    });
    markers.on('click', function (a) {
        $.getJSON("{/literal}{'/openpa/data/map_markers'|ezurl(no)}{literal}?contentType=marker&view=line&id="+a.layer.feature.id, function(data) {
            var popup = new L.Popup({maxHeight:360});
            popup.setLatLng(a.layer.getLatLng());
            popup.setContent(data.content);
            map.openPopup(popup);
        });
    });
    markerListClick = function(e){
        var id = $(e.currentTarget).data('id');
        var m = markerMap[id];
        markers.zoomToShowLayer(m, function() { m.fire('click');});
        e.preventDefault();
    }
};
{/literal}
{/run-once}
loadMap(
    'block-map-{$block.id}',
    'block-markers-{$block.id}',
    "{concat('/openpa/data/map_markers'|ezurl(no), '?parentNode=',$block.custom_attributes.parent_node_id, '&classIdentifiers=', $block.custom_attributes.class )}&contentType=geojson"
);
</script>