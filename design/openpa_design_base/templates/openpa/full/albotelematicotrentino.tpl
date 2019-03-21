{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

{def $layout_attribute = cond(is_set($node.object.data_map.page), 'page', 'layout')}

<div class="content-view-full">
    <div class="class-frontpage">

        <div class="attribute-header">
            <h1>{$node.name|wash}</h1>
        </div>

        <div class="attribute-page">
            {if $node.object.data_map[$layout_attribute].has_content}
                {attribute_view_gui attribute=$node.object.data_map[$layout_attribute]}
            {/if}
        </div>

        {def $affissione_albo = fetch( 'content', 'class', hash( 'class_id', 'affissione_albo' ))}
        {if and($affissione_albo, $affissione_albo.object_count|gt(0))}
            {include name=affisioni_albo node=$node uri='design:parts/openpa/affisioni_albo.tpl'}
        {/if}
        {undef $affissione_albo}

    </div>
</div>

{undef $layout_attribute}