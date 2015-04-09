{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

<div class="content-view-full">
    <div class="class-frontpage">

    <div class="attribute-page">
    {if is_set($node.object.data_map.page)}
    {attribute_view_gui attribute=$node.object.data_map.page}
    {elseif is_set($node.object.data_map.layout)}
    {attribute_view_gui attribute=$node.object.data_map.layout}
    {/if}
    </div>

    </div>
</div>