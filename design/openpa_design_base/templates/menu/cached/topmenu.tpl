{* variabili attese:
    $root_node_id int
    $position array(first|last) array
*}

{def $item = fetch( 'content', 'node', hash( 'node_id', $root_node_id ) )
     
     $top_menu_class_filter = openpaini( 'TopMenu', 'IdentificatoriMenu', array() )
     $custom_menu = openpaini( 'TopMenu', 'NodiCustomMenu', false() )
     $custom_aree = openpaini( 'TopMenu', 'NodiAreeCustomMenu', array() )
     $main_styles = openpaini( 'Stili', 'Nodo_NomeStile', array() )
     $hide_children = openpaini( 'TopMenu', 'NodiSoloPrimoLivello', array() )
     
     $item_class = array()
     $level_2_items_count = 0    
     $level_2_items = 0
     $item_class_2 = array()
     $level_3_items= array()}
    
{* nel cached menu vengono mostate tutte le aree tematiche anche quelle non accessibili all'anonimo *}
{def $limitations = hash( 'limitation', false() )}
{if $custom_aree|contains( $item.node_id )}
    {set $limitations = hash( 'limitation', array() )}
{/if}
    
{if $hide_children|contains( $item.node_id )|not()}
    {set $level_2_items = fetch( 'content', 'list', hash( 'parent_node_id', $item.node_id,
                                                          'sort_by', $item.sort_array,
                                                          'limit', cond( $custom_aree|contains( $item.node_id ), 50, openpaini( 'TopMenu', 'LimiteSecondoLivello', 20 ) ),
                                                          'class_filter_type', 'include', 
                                                          'class_filter_array', $top_menu_class_filter )|merge( $limitations ) )}
{/if}

{set $item_class = $item_class|merge( $position)}

{foreach $main_styles as $style}
    {set $style = $style|explode(';')}
    {if $style[0]|eq($item.node_id)}
        {set $item_class = $item_class|append( $style[1]|slugize() )}
        {break}
    {/if}
{/foreach}

<li id="node_id_{$item.node_id}"{if $item_class} class="{$item_class|implode(" ")}"{/if}>
    <div>
        {include uri='design:menu/cached/topmenu_item.tpl' node=$item}
        {if $level_2_items|count()}
            <ul class="secondlevel">
                {foreach $level_2_items as $key => $item2}
                    {set $item_class_2 = array()
                         $level_2_items_count = $level_2_items|count()}
                    {if $key|eq(0)}
                        {set $item_class_2 = $item_class_2|append("subfirstli")}
                    {/if}
                    {if $level_2_items_count|eq( $key|inc )}
                        {set $item_class_2 = $item_class_2|append("sublastli")}
                    {/if}                        
                    {set $item_class_2 = $item_class_2|append($item2.name|slugize())}
                    <li id="node_id_{$item2.node_id}" class="count-{$level_2_items|count()}{if $item_class_2} {$item_class_2|implode(" ")}{/if}">
                        <div>
                            {include uri='design:menu/cached/topmenu_item.tpl' node=$item2}
                        </div>
                    {if $custom_aree|contains( $item.node_id )}
                        {set $level_3_items=array()}
                    {else}
                        {set $level_3_items = fetch( 'content', 'list', hash( 'parent_node_id', $item2.node_id, 
                                                                              'sort_by', $item2.sort_array,
                                                                              'limit', openpaini( 'TopMenu', 'LimiteTerzoLivello', 10 ), 
                                                                              'class_filter_type','include',
                                                                              'class_filter_array', $top_menu_class_filter ) )}
                    {/if}
                    {if $level_3_items|count()|gt(0)}
                    <ul class="thirdlevel float-break {$item2.name|slugize()}">
                        {foreach $level_3_items as $item3}
                            <li class="thirdlevel-count-{$level_3_items|count()}">
                                <div>
                                    {include uri='design:menu/cached/topmenu_item.tpl' node=$item3}
                                </div>
                            </li>
                        {/foreach}
                    </ul>
                    {/if}
                    </li>
                {/foreach}
            </ul>
        {/if}				
    </div>
</li>

{undef}

