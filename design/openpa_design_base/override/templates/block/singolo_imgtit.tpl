{def $valid_node = $block.valid_nodes[0]}

<div class="block-type-singolo block-{$block.view}">
    <div class="attribute-image">
        {attribute_view_gui href=$valid_node.url_alias|ezurl() attribute=$valid_node.data_map.image image_class='large'}
    </div>

    <div class="trans-background">&nbsp;</div>

    <div class="attribute-link">
        {if $valid_node.class_identifier|eq('link')}
                <a href={$valid_node.data_map.location.content|ezurl()} target="_blank" title="Apri il link '{$valid_node.name|wash()}' in una pagina esterna (si lascerà il sito)">
                    {$valid_node.name|wash()}
                </a>
        {else}
            <a href="{$valid_node.url_alias|ezurl(no)}">{$valid_node.name}</a>
        {/if}
    </div>
</div>