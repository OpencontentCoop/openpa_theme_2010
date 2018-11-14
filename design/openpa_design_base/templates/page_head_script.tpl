{* Load JavaScript dependencys + JavaScriptList *}
{ezscript_load( array(
    'ezjsc::jquery',
    'ezjsc::jqueryio',
    'cachedmenu.js',
    'ajaxmenu.js',
    'leaflet/leaflet.0.7.2.js',
    'leaflet/leaflet.markercluster.js',
    'leaflet/Leaflet.MakiMarkers.js',
    'leaflet/Control.Geocoder.js',
    ezini( 'JavaScriptSettings', 'JavaScriptList', 'design.ini' )
))}

<!--[if IE]>
{ezscript_load( array( 'jquery.placeholder.js' ) )}
{literal}<script type="text/javascript">$(function(){$('input, textarea').placeholder();});</script>{/literal}
<![endif]-->
