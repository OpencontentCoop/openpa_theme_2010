{def $valid_node = $block.valid_nodes[0]
     $collegamento = null()}

{if is_set($valid_node.data_map.location)}
    {if $valid_node.data_map.location.has_content}
        {set $collegamento = $valid_node.data_map.location.content}
    {/if}
{elseif is_set($valid_node.data_map.location_applicativo)}
    {if $valid_node.data_map.location_applicativo.has_content}
        {set $collegamento = $valid_node.data_map.location_applicativo.content}
    {/if}
{/if}

<div class="block-type-singolo block-{$block.view}">
    <div class="attribute-image">
        {attribute_view_gui attribute=$valid_node.data_map.image image_class='singolo' href=$collegamento}
    </div>
</div>
{undef $valid_node $collegamento}