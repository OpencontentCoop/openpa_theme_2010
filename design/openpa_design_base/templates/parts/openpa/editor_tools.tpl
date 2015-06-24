{*
	Variabili
	$logged_user
	$node
*}


{def $gruppo_dipendenti = openpaini( 'ControlloUtenti', 'gruppo_dipendenti' )
	 $gruppo_amministratori = openpaini( 'ControlloUtenti', 'gruppo_amministratori' )
     $editors = openpaini( 'ControlloUtenti', 'editors', array() )
     $is_dipendente = false()
     $logged_user = fetch( 'user', 'current_user' )}     

{if $logged_user.is_logged_in}
	
    {foreach $logged_user.groups as $key => $group}
		{if $group|eq($gruppo_dipendenti)}
			{set $is_dipendente = true()}            
		{/if}
        {if $group|eq($gruppo_amministratori)}
			{set $is_dipendente = true()}            
		{/if}
        {if $editors|contains($group)}
			{set $is_dipendente = true()}            
		{/if}
	{/foreach}
    
	{if or( $is_dipendente, fetch( 'user', 'has_access_to', hash( 'module', 'openpa', 'function', 'editor_tools' ) ) )}    
		<div class="square-box-soft-gray info-dipendente float-break" style="position: relative">
        <div style='position: absolute; right: 3px; top: 3px; font-family: sans-serif; font-weight: bold;'><a href='#' onclick='javascript:this.parentNode.parentNode.style.display="none"; return false;'>X</a></div>
		<ul>
            
            <li><strong>Ultima modifica di:</strong> <a href={$node.creator.main_node.url_alias|ezurl}>{$node.creator.name}</a> il {$node.object.modified|l10n(shortdatetime)}</li>            
            <li><strong>Creato da:</strong> <a href={$node.object.owner.main_node.url_alias|ezurl}>{$node.object.owner.name}</a> il {$node.object.published|l10n(shortdatetime)}</li>    		
    		
            <li><strong>Nodo:</strong> {$node.node_id} <strong>Oggetto</strong> {$node.contentobject_id} ({$node.object.remote_id})</li>
            
            {if count( $node.object.assigned_nodes )|gt(1)}
                <li><strong>Collocazioni:</strong> <ul>{foreach $node.object.assigned_nodes as $item}<li><a href={$item.url_alias|ezurl()}>{$item.path_with_names}</a> {if $item.node_id|eq($node.object.main_node_id)}(principale){/if}</li>{/foreach}</ul></li>
            {/if}
            
            {def $sezione = fetch( 'section', 'object', hash( 'section_id', $node.object.section_id ))}
			<li><strong>Sezione: </strong>{$sezione.name|wash}</li>
            
            <li><strong>Tipo: </strong> {include node=$node uri='design:parts/common/class_icon.tpl' width="24" height="24" css_class="class_identifier"} {$node.class_name} ({$node.class_identifier})</li>
            
            {if and( is_set( $node.data_map.classi_filtro ), $node.data_map.classi_filtro.content|ne('') )}
            <li>
                <strong>Folder virtuale:</strong> {$node.data_map.classi_filtro.content|explode(', ')|implode(', ')}
                {if $node.data_map.subfolders.has_content}
                (
                    {foreach $node.data_map.subfolders.content.relation_list as $relation}
                        <a href={concat( "content/view/full/", $relation.node_id)|ezurl()}>{$relation.node_id}</a>
                        {delimiter}, {/delimiter}
                    {/foreach}
                )
                {/if}
            </li>
            {/if}
            
            {if and( is_set( $node.data_map.subtree_array ), $node.data_map.subtree_array.content|ne('') )}
            <li>
                <strong>Calendario virtuale:</strong>
                {if $node.data_map.subtree_array.has_content}
                (
                    {foreach $node.data_map.subtree_array.content.relation_list as $relation}
                        <a href={concat( "content/view/full/", $relation.node_id)|ezurl()}>{$relation.node_id}</a>
                        {delimiter}, {/delimiter}
                    {/foreach}
                )
                {/if}
            </li>
            {/if}	
			
            {if and( is_set( $node.data_map.data_iniziopubblicazione ), $node.data_map.data_iniziopubblicazione, $node.data_map.data_iniziopubblicazione.has_content, $node.data_map.data_iniziopubblicazione|gt(0) )}
			<li><strong>{$node.data_map.data_iniziopubblicazione.contentclass_attribute_name}</strong>{attribute_view_gui attribute=$node.data_map.data_iniziopubblicazione}</li>
            {/if}
			
            {if and( is_set( $node.data_map.data_finepubblicazione ), $node.data_map.data_finepubblicazione, $node.data_map.data_finepubblicazione.has_content, $node.data_map.data_finepubblicazione|gt(0) )}
			<li><strong>{$node.data_map.data_finepubblicazione.contentclass_attribute_name}</strong>{attribute_view_gui attribute=$node.data_map.data_finepubblicazione}</li>
            {/if}
            
            {if and( is_set( $node.data_map.data_archiviazione ), $node.data_map.data_archiviazione, $node.data_map.data_archiviazione.has_content, $node.data_map.data_archiviazione|gt(0) )}
			<li><strong>{$node.data_map.data_archiviazione.contentclass_attribute_name}</strong>{attribute_view_gui attribute=$node.data_map.data_archiviazione}</li>
            {/if}
            
            {def $states = $node.object.allowed_assign_state_list}
            {if $states|count}
            <li><strong>Stati:</strong> {foreach $states as $allowed_assign_state_info}{foreach $allowed_assign_state_info.states as $state}{if $node.object.state_id_array|contains($state.id)}{$allowed_assign_state_info.group.current_translation.name|wash()}/{$state.current_translation.name|wash}{/if}{/foreach}{delimiter}, {/delimiter}{/foreach}</li>
            {/if}
            
            {if $node.object.can_translate}
            <li>            
              <strong>Traduzioni:</strong>
              <ul>
              {foreach $node.object.languages as $language}
                {if $node.object.available_languages|contains($language.locale)}
                  <li>
                    <a href="{concat( $node.url_alias, '/(language)/', $language.locale )|ezurl(no)}">
                      {if $language.locale|eq($node.object.current_language)}<strong>{/if}{$language.name|wash()}{if $language.locale|eq($node.object.current_language)}</strong>{/if}
                    </a>
                  </li>
                {/if}
              {/foreach}
              </ul>
              {def $can_create_languages = $node.object.can_create_languages
                   $languages = fetch( 'content', 'prioritized_languages' )}            
              <form method="post" action={"content/action"|ezurl}>
                <input type="hidden" name="HasMainAssignment" value="1" />
                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                <input type="hidden" name="NodeID" value="{$node.node_id}" />
                <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                
                {if and(eq( $languages|count, 1 ), is_set( $languages[0] ) )}
                    <input name="ContentObjectLanguageCode" value="{$languages[0].locale}" type="hidden" />
                {else}
                  <select name="ContentObjectLanguageCode">
                  {foreach $node.object.can_edit_languages as $language}
                    <option value="{$language.locale}"{if $language.locale|eq($node.object.current_language)} selected="selected"{/if}>{$language.name|wash}</option>
                  {/foreach}
                  {if $can_create_languages}
                    <option value="">{'New translation'|i18n( 'design/admin/node/view/full')}</option>
                  {/if}
                  </select>
                {/if}
                <input type="submit" name="EditButton" class="button defaultbutton" value="Modifica" />
              </form>
            </li>
            {/if}  
                  
        
        </ul>
		
		{* NEWSLETTER *}
		{def $newsletter_edition_hash = newsletter_edition_hash()}
		{if and( $node|can_add_to_newsletter(), $newsletter_edition_hash|count()|gt(0) )}
            <form action={concat("/openpa/addlocationto/",$node.contentobject_id)|ezurl} method="post">
			  <fieldset>
				<legend>Aggiungi alla prossima newsletter:</legend>
                <select name="SelectedNodeIDArray[]">
                {foreach $newsletter_edition_hash as $edition_id => $edition_name}
                    <option value="{$edition_id}">{$edition_name|wash()}</option>
                {/foreach}
                </select>
                <input class="defaultbutton" type="submit" name="AddLocation" value="Aggiungi" />
			  </fieldset>
            </form>            
        {/if}
		{undef $newsletter_edition_hash}

        {* TIENIMI AGGIORNATO *}
		{if and( $logged_user.is_logged_in, $node.object.content_class.is_container, fetch( 'user', 'has_access_to', hash( 'module', 'notification', 'function', 'use' ) ) )}
		  <form method="post" action={"/content/action/"|ezurl}>			   
			  <input class="defaultbutton" type="submit" name="ActionAddToNotification" value="{'Keep me updated'|i18n('design/retecivica/full/folder')}" />
			  <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
		  </form>            
		{/if}
		
		{*PREFERITI*}
		{if fetch( 'user', 'has_access_to', hash( 'module', 'content', 'function', 'bookmark' ) )}
		  <form method="post" action={'content/action'|ezurl}>
		  <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
		  <input class="defaultbutton" type="submit" name="ActionAddToBookmarks" value="Aggiungi ai Preferiti" title="{'Add the current item to your bookmarks.'|i18n( 'design/admin/pagelayout' )}" />
		  </form>	  
		{/if}
		
		</div>
	{/if}
{/if}
