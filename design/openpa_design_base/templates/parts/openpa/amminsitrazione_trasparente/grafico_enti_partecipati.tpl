<script src="http://code.highcharts.com/highcharts.js"></script>
{*<script src="http://code.highcharts.com/modules/exporting.js"></script>*}
<div id="grafico_enti" style="min-width: 310px; height: 1000px; margin: 0 auto"></div>
<script>
{literal}
$(function () {
	$.getJSON( "/openpa/data/partecipazioni", function(response) {
	  var enti = [];
	  var series = [];	  
	  if (typeof response.enti != 'undefined') {		
		$.each( response.enti, function(i,v){ enti.push(v)});
		$.each( response.series, function(i,v){
		  series.push( {name:i,data:v} );
		});	  
		$('#grafico_enti').highcharts({
			chart: {
				type: 'bar'
			},
			title: {
				text: ''
			},
			xAxis: {
				categories: enti,
				title: {
					text: null
				}
			},
			yAxis: {
				min: 0,
				max: 100,
				title: {
					text: 'Percentuale di partcipazione',
					align: 'high'
				},
				labels: {
					overflow: 'justify'
				}
			},
			tooltip: {
				valueSuffix: ' %'
			},
			plotOptions: {
				bar: {
					dataLabels: {
						enabled: true
					}
				}
			},
			legend: {			  
				borderWidth: 1,
				backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
				shadow: true
			},
			credits: {
				enabled: false
			},
			series: series
		});
	  }else{
		$('#grafico_enti').hide();
	  }
	});
});
{/literal}
</script>