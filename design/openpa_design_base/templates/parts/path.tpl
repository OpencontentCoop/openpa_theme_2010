<h2 class="hide">Ti trovi in:</h2>
<p>
{def $indexNode = ezini( 'SiteSettings', 'IndexPage', 'site.ini' )|explode( 'content/view/full/' )|implode('')|explode( '/' )|implode('')}
{foreach openpacontext().path_array as $path}
{def $do = true()}
{if and( $indexNode|ne( 2 ), $path.node_id|eq( 2 ) )}
    {set $do = false()}
{/if}
{if openpacontext().is_area_tematica}
    {if openpacontext().area_tematica_path_array|contains( $path.node_id )}
        {set $do = false()}
    {/if}
    {if openpacontext().area_tematica_node_id|eq( $path.node_id )}
        {set $do = true()}
    {/if}
    {if openpacontext().area_tematica_node_id|eq( $module_result.content_info.node_id )}
        {set $do = false()}
    {/if}
{/if}
{if $do}
    {if $path.url}
        <a href={cond( is_set( $path.url_alias ), $path.url_alias, $path.url )|ezurl}>
            {if $path.node_id|eq(ezini( 'NodeSettings', 'RootNode', 'content.ini' ))}
                Home
            {else}
                {$path.text|wash}
            {/if}
        </a>
         <span class="path-separator">&raquo;</span>
      {else}
        <span class="path-text"> {$path.text|wash} </span>
      {/if}
{/if}
{undef $do}
{/foreach}
</p>
