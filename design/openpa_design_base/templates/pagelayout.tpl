<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
<head>

{if is_set( $extra_cache_key )|not}
    {def $extra_cache_key = ''}
{/if}

{if openpacontext().is_edit}
    {set $extra_cache_key = concat($extra_cache_key, 'edit')}
{/if}

{if openpacontext().is_browse}
    {set $extra_cache_key = concat($extra_cache_key, 'browse')}
{/if}

{if openpacontext().is_area_tematica}
    {set $extra_cache_key = concat($extra_cache_key, 'areatematica_', openpacontext().is_area_tematica)}
{/if}

{debug-accumulator id=page_head_style name=page_head_style}
{include uri='design:page_head_style.tpl'}
{/debug-accumulator}

{debug-accumulator id=page_head_script name=page_head_script}
{include uri='design:page_head_script.tpl'}
{/debug-accumulator}

{include uri='design:page_head_google-site-verification.tpl'}

{include uri='design:page_head.tpl'}
{no_index_if_needed()}

</head>
<body class="no-js">
<script type="text/javascript">
//<![CDATA[
var CurrentUserIsLoggedIn = {cond(fetch('user','current_user').is_logged_in, 'true', 'false')};
var UiContext = "{$ui_context}";
var UriPrefix = {'/'|ezurl()};
var PathArray = [{if is_set( openpacontext().path_array[0].node_id )}{foreach openpacontext().path_array|reverse as $path}{$path.node_id}{delimiter},{/delimiter}{/foreach}{/if}];
(function(){ldelim}var c = document.body.className;c = c.replace(/no-js/, 'js');document.body.className = c;{rdelim})();
//]]>
</script>

{include uri='design:page_browser_alert.tpl'}

<div id="page" class="{openpacontext().css_classes} {openpacontext().current_main_style}">

    {debug-accumulator id=page_header name=page_header}
    {include uri='design:page_header.tpl'}
    {/debug-accumulator}

    {if and(openpacontext().top_menu, openpacontext().is_login_page|not())}
    {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name, $extra_cache_key )}
        {include uri='design:page_topmenu.tpl'}
    {/cache-block}
    {/if}

    <div id="links">

    {if openpacontext().is_login_page|not()}
        {debug-accumulator id=page_header_usability name=page_header_usability}
        {include uri='design:page_header_usability.tpl'}
        {/debug-accumulator}
    {/if}

    {if openpacontext().is_login_page|not()}
    {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name, $extra_cache_key )}
      {include uri='design:page_header_links.tpl'}
    {/cache-block}
    {/if}

    </div>

    {if openpacontext().show_breadcrumb}
        {debug-accumulator id=page_toppath name=page_toppath}
        {include uri='design:page_toppath.tpl'}
        {/debug-accumulator}
    {/if}

    {debug-accumulator id=page_toolbar name=page_toolbar}
    {include uri='design:page_toolbar.tpl'}
    {/debug-accumulator}

    {include uri='design:page_mainarea.tpl'}

    {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name )}
        {debug-accumulator id=page_footer name=page_footer}
        {include uri='design:page_footer.tpl'}
        {/debug-accumulator}
    {/cache-block}

</div>

{if and( $ui_context|ne( 'edit' ), $ui_context|ne( 'browse' ), is_set($module_result.content_info.persistent_variable.has_footer_banner) )}
{debug-accumulator id=page_footer_banner name=page_footer_banner}
{include uri='design:parts/sensor_footer_banner.tpl'
         url=$module_result.content_info.persistent_variable.footer_banner_url
         banner=$module_result.content_info.persistent_variable.footer_banner_text
         name=sensor_ad}
{/debug-accumulator}
{/if}

{debug-accumulator id=page_footer_script name=page_footer_script}
{include uri='design:page_footer_script.tpl'}
{/debug-accumulator}

<!--DEBUG_REPORT-->
</body>
</html>
