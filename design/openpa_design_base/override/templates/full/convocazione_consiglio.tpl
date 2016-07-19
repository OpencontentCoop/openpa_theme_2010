{ezpagedata_set( 'extra_menu', false() )}

{def $attributi_da_evidenziare = openpaini( 'GestioneAttributi', 'attributi_da_evidenziare' )
	 $attributi_a_destra = openpaini( 'GestioneAttributi', 'attributi_a_destra' )
	 $classes_parent_to_edit = openpaini( 'GestioneClassi', 'classi_figlie_da_editare' )}

<div class="border-box">
<div class="border-content">

 <div class="global-view-full content-view-full">
  <div class="class-{$node.object.class_identifier}">

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
    
    {def $children_count = fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id ) )
         $page_limit = openpaini( 'GestioneFigli', 'limite_paginazione', 25 )}
        
    {if $children_count|gt(0)}
        
        
        <div class="oggetti-correlati allegati-e-annessi">
          <div class="border-header border-box box-trans-blue box-allegati-header">
              <div class="border-tl">
                  <div class="border-tr">
                      <div class="border-tc"></div>
                  </div>
              </div>
              <div class="border-ml">
                  <div class="border-mr">
                      <div class="border-mc">
                          <div class="border-content">
                              <h2>Proposte</h2>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
          <div class="border-body border-box box-violet box-allegati-content">
              <div class="border-ml">
                  <div class="border-mr">
                      <div class="border-mc">
                          <div class="border-content">
                            {foreach fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                      'offset', $view_parameters.offset,
                                                      'sort_by', array('priority',true()),
                                                      'limit', $page_limit ) ) as $child max $page_limit sequence array( 'col-odd', 'col-even' ) as $style}                
                              <div class="{$style} col col-notitle float-break">
                                <div class="col-content"><div class="col-content-design">                                
                                  <h3><a href="{$child.url_alias|ezurl(no)}">{$child.data_map.oggetto.content|wash()}</a></h3>
                                </div></div>
                              </div>
                            {/foreach}
                            
                            {include name=navigator
                                    uri='design:navigator/google.tpl'
                                    page_uri=$node.url_alias
                                    item_count=$children_count
                                    view_parameters=$view_parameters
                                    item_limit=$page_limit}
                            
                          </div>
                      </div>
                  </div>
              </div>
              <div class="border-bl">
                  <div class="border-br">
                      <div class="border-bc"></div>
                  </div>
              </div>
          </div>
      </div>
        
      
    {/if}   
	
    </div>
</div>

</div>
</div>


