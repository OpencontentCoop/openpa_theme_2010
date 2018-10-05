{def $header_logo_background_style = fetch( 'openpa', 'header_logo_background_style' )}
<div id="logo">
    <h1 {if $header_logo_background_style}style="margin:0"{/if}><a style="{$header_logo_background_style}" href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}">{ezini('SiteSettings','SiteName')}</a></h1>
</div>