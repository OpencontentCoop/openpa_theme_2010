{def $header_logo_background_style = fetch( 'openpa', 'header_logo_background_style' )}
<div id="logo">
{*
{if $pagedesign.data_map.image.content.is_valid|not()}
    <h1><a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}">{ezini('SiteSettings','SiteName')}</a></h1>
{else}
    <a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}"><img src={$pagedesign.data_map.image.content[original].full_path|ezroot} alt="{$pagedesign.data_map.image.content[original].text}" width="{$pagedesign.data_map.image.content[original].width}" height="{$pagedesign.data_map.image.content[original].height}" /></a>
{/if}
*}
<h1 {if $header_logo_background_style}style="margin:0"{/if}><a style="{$header_logo_background_style}" href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}">{ezini('SiteSettings','SiteName')}</a></h1>
</div>