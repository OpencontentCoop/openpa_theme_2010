<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
<head>

{def $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )
     $is_login_page = cond( and( module_params()['module_name']|eq( 'user' ), module_params()['function_name']|eq( 'login' ) ), true(), false() )
     $cookies = check_and_set_cookies()}


{if is_set( $extra_cache_key )|not}
    {def $extra_cache_key = ''}
{/if}
{cache-block expiry=86400 keys=array( $module_result.uri, $access_type.name, $user_hash, $extra_cache_key, $cookies|implode(',') )}
{def $browser          = checkbrowser('checkbrowser')
     $pagedata         = openpapagedata()
     $pagestyle        = $pagedata.css_classes
     $locales          = fetch( 'content', 'translation_list' )
     $pagedesign       = $pagedata.template_look
     $current_node_id  = $pagedata.node_id
     $main_style       = get_main_style()}

{include uri='design:page_head_google-site-verification.tpl'}
{include uri='design:page_head.tpl'}

<!-- Site: {ezsys( 'hostname' )} -->
{if ezsys( 'hostname' )|contains( 'opencontent' )}
<META name="robots" content="NOINDEX,NOFOLLOW" />
{/if}

{include uri='design:page_head_style.tpl'}
{include uri='design:page_head_script.tpl'}

</head>
<body class="no-js">
<script type="text/javascript">{literal}
//<![CDATA[
var UiContext = {/literal}"{$ui_context}"{literal};
var UriPrefix = {/literal}{'/'|ezurl()}{literal};
var PathArray = [{/literal}{if is_set( $pagedata.path_array[0].node_id )}{foreach $pagedata.path_array|reverse as $path}{$path.node_id}{delimiter},{/delimiter}{/foreach}{/if}{literal}];

(function(){var c = document.body.className;
c = c.replace(/no-js/, 'js');
document.body.className = c;
})();
//]]>{/literal}
</script>
{/cache-block}

{include uri='design:page_browser_alert.tpl'}

{cache-block expiry=86400 keys=array( $module_result.uri, $access_type.name, $user_hash, $extra_cache_key )}
{if is_set($pagedata)|not()}{def $pagedata = openpapagedata()}{/if}
{if is_set($pagestyle)|not()}{def $pagestyle = $pagedata.css_classes}{/if}
{if is_set($main_style)|not()}{def $main_style = get_main_style()}{/if}
<div id="page" class="{$pagestyle} {$main_style}">

    {if and( is_set( $pagedata.persistent_variable.extra_template_list ), $pagedata.persistent_variable.extra_template_list|count() )}
        {foreach $pagedata.persistent_variable.extra_template_list as $extra_template}
            {include uri=concat('design:extra/', $extra_template)}
        {/foreach}
    {/if}

    {include uri='design:page_header.tpl'}

    {if and( $pagedata.top_menu, $is_login_page|not() )}
        {include uri='design:page_topmenu.tpl'}
    {/if}
{/cache-block}

<div id="links">
{cache-block expiry=86400 keys=array( $module_result.uri, $user_hash, $access_type.name, $extra_cache_key, $cookies|implode(',') )}
    {if $is_login_page|not()}
        {include uri='design:page_header_usability.tpl'}
    {/if}
{/cache-block}

{cache-block keys=array( $module_result.uri, $current_user.contentobject_id, $access_type.name, $extra_cache_key )}
    {if $is_login_page|not()}
      {if is_set($pagedata)|not()}
        {def $pagedata = openpapagedata()
           $pagedesign = $pagedata.template_look}
      {/if}
      {include uri='design:page_header_links.tpl'}
    {/if}
{/cache-block}
</div>

{cache-block expiry=86400 keys=array( $module_result.uri, $user_hash, $access_type.name, $extra_cache_key )}
    {if is_set($pagedata)|not()}{def $pagedata = openpapagedata()}{/if}
    {if is_set($current_node_id)|not()}{def $current_node_id = $pagedata.node_id}{/if}
    {if and( $pagedata.show_path,
             $current_node_id|ne(ezini( 'NodeSettings', 'RootNode', 'content.ini' )),
             $module_result.uri|ne('/content/advancedsearch'),
             $module_result.uri|ne('/content/search'),
             $module_result.uri|ne('/content/advancedsearch/'),
             $module_result.uri|ne('/content/search/'),
             is_set( $module_result.content_info )
            )}
        {include uri='design:page_toppath.tpl'}
    {/if}

    {if and( $pagedata.website_toolbar, $pagedata.is_edit|not)}
        {include uri='design:page_toolbar.tpl'}
    {/if}

    <div id="columns-position" class="width-layout{if $pagedata.class_identifier|eq('frontpage')} frontpage{/if}">
    <div id="columns" class="float-break">

    {if $pagedata.left_menu}
        {include uri='design:page_leftmenu.tpl'}
    {/if}

{/cache-block}

    {include uri='design:page_mainarea.tpl'}

{cache-block expiry=86400 keys=array( $module_result.uri, $user_hash, $access_type.name, $extra_cache_key )}

    {if is_unset($pagedesign)}
        {def $pagedata   = openpapagedata()
             $pagedesign = $pagedata.template_look}
    {/if}

    {if and($pagedata.extra_menu, $module_result.content_info)}
        {include uri='design:page_extramenu.tpl'}
    {/if}

    </div>
    </div>
<!-- {$ui_context} -->
    {if and( $ui_context|ne( 'edit' ), $ui_context|ne( 'browse' ) )}
        {if and( $current_node_id|ne(2), $pagedata.class_identifier|ne('frontpage'), $pagedata.class_identifier|ne('') ) }
            {include name=valuation node_id=$current_node_id uri='design:parts/openpa/valuation.tpl'}
        {/if}
    {/if}
    {include uri='design:page_footer.tpl'}
</div>

{if and( $ui_context|ne( 'edit' ), $ui_context|ne( 'browse' ), is_set( $pagedata.homepage.data_map.sensor_footer_banner ) )}
{include uri='design:parts/sensor_footer_banner.tpl' url=$pagedata.homepage.data_map.sensor_footer_banner.content banner=$pagedata.homepage.data_map.sensor_footer_banner name=sensor_ad}
{/if}

{include uri='design:page_footer_script.tpl'}
{/cache-block}

{* modal window and AJAX stuff
<div id="overlay-mask" style="display:none;"></div>
<img src={'loading.gif'|ezimage()} id="ajaxuploader-loader" style="display:none;" alt="{'Loading...'|i18n( 'design/admin/pagelayout' )}" />
*}

<!--DEBUG_REPORT-->
</body>
</html>
