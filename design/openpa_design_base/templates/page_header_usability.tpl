{def $widthlayout = openpaini( 'Stili', 'LarghezzaLayout', '1000px' )}
{literal}
<script type="text/javascript">
$(document).ready(function(){
	var prefix = '{/literal}{ezini( 'CookiesSettings', 'CookieKeyPrefix', 'cookieoperator.ini' )}{/literal}';
	var readLocalStorage = function(name, defaultValue){
	    if (typeof(Storage) !== "undefined") {
            var item = localStorage.getItem(prefix+name);
            return item ? item : defaultValue;
        } else {
            console.log("Sorry! No Web Storage support..");
            $('#links .accessibilita').hide();
        }
	};
	var writeLocalStorage = function(name, value){
	    if (typeof(Storage) !== "undefined") {
	        localStorage.setItem(prefix+name, value);
	    }
	};

	switchSize('dimensione',readLocalStorage('dimensione','normale'));
	switchSize('layout',readLocalStorage('layout','rigido'));
	
	function switchSize(tipo,valore){
		if (tipo == 'dimensione'){
			if (valore == 'normale'){
				$('body').css('font-size', '0.8em');
			}else{
				$('body').css('font-size', '1em');
			}
			writeLocalStorage( tipo, valore);
		}
		if (tipo == 'layout'){
			if (valore == 'fluido'){
				$('div.width-layout').css('width', '100%');
				$('#header').css('background-position', 'left center');
				$('#header').css('background-size', 'cover');
                $('body').addClass('fluido');
			}else{
				$('div.width-layout').css('width', '{/literal}{$widthlayout}{literal}');
                $('body').removeClass('fluido');
			}
			writeLocalStorage( tipo, valore);
		}
	}
    
    $(document).bind('switchSize', function(event, param1, param2) {switchSize(param1, param2);} );
	
	$("#riduci-caratteri").click( function(e){
        switchSize('dimensione','normale');
		$("#aumenta-caratteri").removeClass("access_selected");
		$(this).addClass("access_selected");
		e.preventDefault();
    });
	$("#aumenta-caratteri").click( function(e){
        switchSize('dimensione','grande');
		$("#riduci-caratteri").removeClass("access_selected");
		$(this).addClass("access_selected");		
		e.preventDefault();
    });
	$("#layout-rigido").click( function(e){
        switchSize('layout','rigido');
		$("#layout-fluido").removeClass("access_selected");
		$(this).addClass("access_selected");
		e.preventDefault();
    });
	$("#layout-fluido").click( function(e){
        switchSize('layout','fluido');
		$("#layout-rigido").removeClass("access_selected");
		$(this).addClass("access_selected");
		e.preventDefault();
    });
	
});
</script>
{/literal}


<div class="accessibilita" style="width: 92px">
<h2 class="hide">Strumenti di accessibilit&agrave;</h2>

<a rel="alternate" id="riduci-caratteri" href="#" title="Visualizza caratteri normali">Visualizza caratteri normali</a>

<span class="hide"> - </span>

<a rel="alternate" id="aumenta-caratteri" href="#" title="Visualizza caratteri grandi">Visualizza caratteri grandi</a>

<span class="hide"> - </span>
{*
<a rel="alternate" {if $cookies.contrasto|eq('alto')}class="access_selected"{/if} id="alto-contrasto" href="?contrasto=alto" title="Visualizzazione ad alto contrasto">Visualizzazione ad alto contrasto</a>

<span class="hide"> - </span>

<a rel="alternate" id="normale" class="ac-show" href="#" title="Visualizzazione normale">Visualizzazione normale</a>

<span class="hide"> - </span>
*}
<a rel="alternate" id="layout-rigido" href="#" title="Comprimi pagina a dimensione fissa">Comprimi pagina a dimensione fissa</a>

<a rel="alternate" id="layout-fluido" href="#" title="Espandi pagina alla dimensione della finestra">Espandi pagina alla dimensione della finestra</a>

</div>