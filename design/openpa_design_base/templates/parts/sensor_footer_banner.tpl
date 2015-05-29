{if and( is_set( $url ), $url|ne('') )}
<div id="footer_sensor" style="text-align: center;cursor: pointer;position:fixed;bottom:0px;max-height:80px;width:100%;box-shadow: 0 -3px 5px #888888; background-image: url('{'sensor_banner/bg.png'|ezimage(no)}');z-index:999999;" onclick="window.location = '{$url}';">
  <div style="height: 79px;position: absolute;right: 0;top: 0;width: 20%;background-image:url('{'sensor_banner/bg_dark.png'|ezimage(no)}')"></div>    
  <div class="float-break width-layout" style="margin: 0 auto">
	  <div style="width: 250px; float: left;">
		  <img class="img-responsive" style="position: relative;top: -19px;" src="{'sensor_banner/logo.png'|ezimage(no)}"/>
	  </div>
	  <div style="width: 500px; float: left;">
		  <img class="img-responsive" style="margin-top: 10px" src="{'sensor_banner/fusione.png'|ezimage(no)}" />
	  </div>
	  <div style="padding-left: 0;background-image: url('{'sensor_banner/bg_dark.png'|ezimage(no)}');width: 250px; float: left;">
		  <a href="{$url}" class="clearfix" style="height: 80px;text-align:right;display:block;background-repeat:no-repeat;background-image:url('{'sensor_banner/a_bg.png'|ezimage(no)}')">
			  <img class="img-responsive pull-right" src='{'sensor_banner/informati.png'|ezimage(no)}' alt="Partecipa" style="display: block; float: right; z-index: 1000000; position: relative;"/>
		  </a>
	  </div>
  </div>
</div>
{/if}