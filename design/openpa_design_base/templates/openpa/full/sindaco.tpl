{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

{def $openpa = object_handler( $node )}
{def $booking_sindaco = false()}
{if and( is_set( $openpa.control_booking_appuntamento_sindaco ), $openpa.control_booking_appuntamento_sindaco.is_valid_sindaco )}
{ezpagedata_set( 'extra_menu', false() )}
{set $booking_sindaco = true()}
{/if}

{def $oggetti_classificazione = array('organo_politico')
     $oggetti_correlati_centro = array('struttura')
     $classes_parent_to_edit=array( 'file_pdf', 'news')
     $classi_da_non_commentare=array( 'news', 'comment')
     $current_user = fetch( 'user', 'current_user' )}

<div class="border-box">
    <div class="border-content">
        <div class="global-view-full content-view-full">
            <div class="class-{$node.object.class_identifier}">

                <h1>{$node.name|wash()}</h1>
                {* DATA e ULTIMAMODIFICA *}
                {include name = last_modified node = $node uri = 'design:parts/openpa/last_modified.tpl'}

                {* EDITOR TOOLS *}
                {include name = editor_tools node = $node uri = 'design:parts/openpa/editor_tools.tpl'}

                {* ATTRIBUTI : mostra i contenuti del nodo *}
                {include name = attributi_principali uri = 'design:parts/openpa/attributi_principali.tpl' node = $node}

                {def $sindaco=$node.data_map.sindaco.content.main_node}
                {if $sindaco}
                    <div class="square-box-soft-gray float-break" style="padding:20px">
                        <h3><a href="{$sindaco.url_alias|ezurl(no)}">{$sindaco.data_map.cognome.content|wash()} {$sindaco.data_map.nome.content|wash()}</a></h3>
                        {include name = attributi_principali uri = 'design:parts/openpa/attributi_principali.tpl' node = $sindaco}
                    </div>
                {/if}

                {* ATTRIBUTI BASE: mostra i contenuti del nodo *}
                {include name = attributi_base uri = 'design:parts/openpa/attributi_base.tpl' node = $node}

                {if $booking_sindaco}
                    {include uri=$openpa.control_booking_appuntamento_sindaco.template}
                {/if}

                {* FIGLI *}
                {include name = filtered_children
                         node = $node.object.main_node
                         object = $node.object
                         classes_figli = array('politico')
                         classes_figli_escludi = array()
                         classes_parent_to_edit = $classes_parent_to_edit
                         title='Membri'
                         classi_da_non_commentare = openpaini( 'GestioneClassi', 'classi_da_non_commentare', array( 'news', 'comment' ) )
                         oggetti_correlati = openpaini( 'DisplayBlocks', 'oggetti_correlati' )
                         uri = 'design:parts/filtered_children.tpl'}

                {include name = filtered_children
                         node = $node.object.main_node
                         object = $node.object
                         classes_figli = openpaini( 'GestioneClassi', 'classi_figlie_da_includere' )
                         classes_figli_escludi = openpaini( 'GestioneClassi', 'classi_figlie_da_escludere' )
                         classes_parent_to_edit = $classes_parent_to_edit
                         title='Allegati'
                         classi_da_non_commentare = openpaini( 'GestioneClassi', 'classi_da_non_commentare', array( 'news', 'comment' ) )
                         oggetti_correlati = openpaini( 'DisplayBlocks', 'oggetti_correlati' )
                         uri = 'design:parts/filtered_children.tpl'}

                {include name = filtered_children
                         node = $node.object.main_node
                         object = $node.object
                         classes_figli = array('news')
                         classes_figli_escludi = array()
                         classes_parent_to_edit = $classes_parent_to_edit
                         title='News'
                         classi_da_non_commentare = openpaini( 'GestioneClassi', 'classi_da_non_commentare', array( 'news', 'comment' ) )
                         oggetti_correlati = openpaini( 'DisplayBlocks', 'oggetti_correlati' )
                         uri = 'design:parts/filtered_children.tpl'}

                {* GALLERIA fotografica *}
                {def $galleries = fetch('content', 'list_count', hash( 'parent_node_id', $node.node_id, 'class_filter_type', 'include', 'class_filter_array', array('image') ) )}
                {if $galleries|gt(0)}
                    {include name=galleria node=$node uri='design:node/view/line_gallery.tpl'}
                {/if}

                {* TIP A FRIEND *}
                {include name=tipafriend node=$node uri='design:parts/common/tip_a_friend.tpl'}

            </div>
        </div>
    </div>
</div>
