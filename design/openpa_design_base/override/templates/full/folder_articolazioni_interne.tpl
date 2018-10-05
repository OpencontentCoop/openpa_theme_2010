{def $extra_info = 'extra_info'
     $left_menu = ezini('SelectedMenu', 'LeftMenu', 'menu.ini')
     $openpa = object_handler($node)
     $homepage = fetch('openpa', 'homepage')
     $current_user = fetch('user', 'current_user')
     $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )}
{include uri='design:parts/openpa/wrap_full_open.tpl'}

<div class="border-box">
<div class="global-view-full content-view-full">
<div class="class-folder">

    <h1>{$node.name|wash()}</h1>

	<div class="abstract">
		{attribute_view_gui attribute=$node.data_map.abstract}
	</div>

	{def $children_remote_folder = fetch(content,list,hash(parent_node_id, openpaini( 'Nodi', 'TipiStrutture', 53949 ), sort_by, array(priority, true())))}
	{foreach  $children_remote_folder as $child}
        {def $objects=fetch( 'content', 'reverse_related_objects', hash( 'object_id', $child.object.id, 'attribute_identifier',openpaini( 'IDAttributi', 'StrutturaTipologiaStruttura', 796 ) ) )
             $objects_count=fetch( 'content', 'reverse_related_objects_count', hash( 'object_id', $child.object.id, 'attribute_identifier', openpaini( 'IDAttributi', 'StrutturaTipologiaStruttura', 796 ) ) )}
		{if $objects_count|gt(0)}
			<h2>{$child.name}</h2>
			<div class="main-image left">
				{if $child.data_map.image.has_content}
					{attribute_view_gui attribute=$child.data_map.image image_class='medium'}
				{else}
					{include node=$node uri='design:parts/common/class_icon.tpl' css_class="image-default"}
				{/if}
			</div>
			<p>{attribute_view_gui attribute=$child.data_map.abstract}</p>

			{if $objects_count|gt(0)}
			<ul>
				{foreach $objects as $object}
				     	<li><a href={$object.main_node.url_alias|ezurl()}>{$object.main_node.name}</a></li>
				{/foreach}
			</ul>			
            {/if}
            <div class="break"></div>
		{/if}
	{/foreach}	

</div>
</div>
</div>

{include uri='design:parts/openpa/wrap_full_close.tpl'}
