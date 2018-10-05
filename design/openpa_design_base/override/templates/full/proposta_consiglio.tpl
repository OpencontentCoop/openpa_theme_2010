{def $extra_info = 'extra_info'
     $left_menu = ezini('SelectedMenu', 'LeftMenu', 'menu.ini')
     $openpa = object_handler($node)
     $homepage = fetch('openpa', 'homepage')
     $current_user = fetch('user', 'current_user')
     $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )}
{include uri='design:parts/openpa/wrap_full_open.tpl'}


{ezpagedata_set( 'extra_menu', false() )}

{def $attributi_da_evidenziare = openpaini( 'GestioneAttributi', 'attributi_da_evidenziare' )
	 $attributi_a_destra = openpaini( 'GestioneAttributi', 'attributi_a_destra' )
	 $classes_parent_to_edit = openpaini( 'GestioneClassi', 'classi_figlie_da_editare' )}

<div class="border-box">
<div class="border-content">

 <div class="global-view-full content-view-full">
  <div class="class-{$node.object.class_identifier}">

	
  <h1><a href="{$node.parent.url_alias|ezurl(no)}">{$node.parent.name|wash()}</a></h1>
  <h2>{$node.data_map.oggetto.content|wash()}</h2>
  
    
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
    
    
    {def $allegati=fetch( 'content', 'related_objects', hash( 'object_id', $node.object.id, 'attribute_identifier', concat( $node.object.class_identifier,'/allegati') ) ) }
    
    {if $allegati|count()|gt(0)}
        
        
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
                              <h2>Allegati</h2>
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
                            {foreach $allegati as $child sequence array( 'col-odd', 'col-even' ) as $style}
                            {if $child.data_map.file.has_content}
                              {def $file = $child.data_map.file}
                              <div class="{$style} col col-notitle float-break">
                                <div class="col-content"><div class="col-content-design">                                
                                  <h3>
                                  
                                      <a href={concat("content/download/", $file.contentobject_id, "/", $file.id, "/file/", $file.content.original_filename)|ezurl}>
                                        {$child.name|wash()}
                                        <small>File {$file.content.original_filename|wash("xhtml")} {$file.content.filesize|si(byte)}</small>
                                      </a>
    
                                  </h3>
                                </div></div>
                              </div>
                              {undef $file}
                            {/if}
                            {/foreach}
                            
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


{include uri='design:parts/openpa/wrap_full_close.tpl'}