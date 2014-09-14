{*
	BLOCCO DI RICERCA AUTOMATICA MORE LIKE THIS
	funziona solo con ezfind

	node		nodo su cui applicare la ricerca moreLikeThis
	title		titolo del box
	
	SE si vuole filtrare per classe:
	class_filter	identificatore di classe per cui filtrare
	excluded_class_filter	identificatore di classe per cui filtrare (escludendo il valore passato)

*}

{if is_set($excluded_class_filter)|not()}
	{def $excluded_class_filter = false()}
{/if}

{if is_set($class_filter)|not()}
	{def $class_filter = false()}
{/if}

{def 	$threshold=15 
	$class=fetch( 'content', 'class', hash( 'class_id', $class_filter ) )
	$classi_con_oggetto = openpaini( 'GestioneClassi', 'classi_con_oggetto' )
}
{set-block variable=$open}
<div class="extrainfo-box">
{/set-block}
{set-block variable=$close}
</div>
{/set-block}

{ezscript_require(array( 'ezjsc::jquery', 'ui-widgets.js' ) )}

<script type="text/javascript">
{literal}
$(function() {
	$("#{/literal}{concat('MoreLikeThis',$title)|slugize()}{literal}").accordion({
		autoHeight: false,
		event: "mouseover",
		change: function(event, ui) { 
			$('a', ui.newHeader ).addClass('active'); 
			$('a', ui.oldHeader ).removeClass('active');  
		}
	}); 
});
{/literal}
</script>


{if $classi_con_oggetto|contains($node.class_identifier)}
    {if $class}
	{def $related_content=fetch( 'ezfind', 'moreLikeThis', 
				      hash( 'query_type', 'text',
                            'query', $node.data_map.oggetto.content,
                            'class_id', $class.id,
                            'subtree_array', array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ),
                            'limit', 6))}
   {else}
	{def $related_content=fetch( 'ezfind', 'moreLikeThis', 
				      hash( 'query_type', 'text',
                            'subtree_array', array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ),
                            'query', $node.data_map.oggetto.content,
                            'limit', 12))}
   {/if}

{else}

   {if $class}
	{def $related_content=fetch( 'ezfind', 'moreLikeThis', 
				      hash( 'query_type', 'nid',
                            'query', $node.node_id,
                            'subtree_array', array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ),
                            'class_id', $class.id,
                            'limit', 6))}
   {else}
	{def $related_content=fetch( 'ezfind', 'moreLikeThis', 
				      hash( 'query_type', 'nid',
                            'query', $node.node_id,
                            'subtree_array', array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) ),
                            'limit', 12))}
   {/if}
{/if}

{if $related_content['SearchCount']|gt(0)}

{def $child_counter=0}
{set $related_content=$related_content['SearchResult']}

{foreach $related_content as $index => $child}
	{if $child.class_identifier|ne($excluded_class_filter)}
	{if $child.node_id|ne($node.node_id)}
	{set $child_counter=$child_counter|sum(1)}
	{/if}
	{/if}
{/foreach}	

{if $child_counter|gt(0)}
{$open}   
   <div class="block-type-lista block-lista_accordion block-morelikethis">
	<h2 class="block-title">{$title|wash()}</h2>
        <div id="{concat('MoreLikeThis',$title)|slugize()}" class="ui-accordion">
		{set $child_counter=0}
		{foreach $related_content as $index => $child}
			{if and($child.class_identifier|ne($excluded_class_filter), $child_counter|lt(6))}
			{if $child.node_id|ne($node.node_id)}
				{set $child_counter=$child_counter|sum(1)}
				
				<div id="doc_{$child.name|slugize()}_{$index}" class="border-box box-gray box-accordion ui-accordion-header {if $index|eq(0)}no-js-ui-state-active{/if}">
				<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
				<div class="border-content">
					<h3 class="attribute-small">
							<a href={$child.object.main_node.url_alias|ezurl()}>{concat($child.name)|wash()}</a>
					</h3>
				</div>
				</div></div></div>
				<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
				</div>
				<div id="doc_{$child.node_id|slugize()}-detail_{$index}" class="border-box box-gray box-accordion ui-accordion-content {if $index|eq(0)}ui-accordion-content-active{/if} {if $index|gt(0)}no-js-hide{/if}">
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
					<div class="border-content">
						{node_view_gui content_node=$child.object.main_node view="simplified_line"}						
					</div>
				</div></div></div>
				<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>              
				</div>
				
				{/if}
			{/if}
		{/foreach}

        </div>

   </div>
{$close}
{/if}
{/if}
