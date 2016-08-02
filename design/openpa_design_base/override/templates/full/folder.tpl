{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

<div class="border-box">
<div class="global-view-full content-view-full">
    <div class="class-folder">

        <h1>{$node.name|wash()}</h1>
    
		{* DATA e ULTIMAMODIFICA *}
		{include name = last_modified
				 node = $node             
				 uri = 'design:parts/openpa/last_modified.tpl'}	
		
        {* EDITOR TOOLS *}
        {include name = editor_tools
                 node = $node             
                 uri = 'design:parts/openpa/editor_tools.tpl'}
    
        {* ATTRIBUTI : mostra i contenuti del nodo *}
        {include name = attributi_principali
                 uri = 'design:parts/openpa/attributi_principali.tpl'
                 node = $node}

        {* ATTRIBUTI BASE: mostra i contenuti del nodo *}
        {include name = attributi_base
                 uri = 'design:parts/openpa/attributi_base.tpl'
                 node = $node}

        {if $node|find_first_parent( 'pagina_trasparenza' )}

            {def $nota = fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,'class_filter_type', 'include','class_filter_array', array( 'nota_trasparenza' ),'sort_by', array( 'published', false() ),'limit', 1 ) )}

            {* Nota: una sola nota *}
            {if $nota|count()|gt(0)}
                <div class="block">
                    {include name=edit node=$nota[0] uri='design:parts/openpa/edit_buttons.tpl'}
                    <em>{attribute_view_gui attribute=$nota[0].data_map.testo_nota}</em>
                </div>
            {/if}

            {include uri='design:parts/openpa/amminsitrazione_trasparente/children_table.tpl' nodes=fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,'class_filter_type', 'exclude','class_filter_array', array( 'nota_trasparenza' ),'sort_by', $node.sort_array, 'load_data_map', false() ) ) nodes_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id ) ) class=''}
        
        {else}
          {def $children_count = fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id ) )
               $page_limit = openpaini( 'GestioneFigli', 'limite_paginazione', 25 )}
          
          {if $children_count|gt(0)}
              {foreach fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                      'offset', $view_parameters.offset,
                                                      'sort_by', $node.sort_array,
                                                      'limit', $page_limit ) ) as $child max $page_limit sequence array( 'col-odd', 'col-even' ) as $style}                
                  <div class="{$style} col col-notitle float-break">
                      <div class="col-content"><div class="col-content-design {$child|access_style()}">
                          {node_view_gui view='line' show_image='no' content_node=$child}
                      </div></div>
                  </div>
              {/foreach}
              {include name=navigator
                       uri='design:navigator/google.tpl'
                       page_uri=$node.url_alias
                       item_count=$children_count
                       view_parameters=$view_parameters
                       item_limit=$page_limit}
          {/if} 
        {/if} 

        
        {* TIP A FRIEND *}
        {include name=tipafriend node=$node uri='design:parts/common/tip_a_friend.tpl'}

    </div>
</div>
</div>