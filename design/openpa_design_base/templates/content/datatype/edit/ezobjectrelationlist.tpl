{let class_content=$attribute.class_content
     class_list=fetch( class, list, hash( class_filter, $class_content.class_constraint_list ) )
     can_create=true()
     current_user = fetch( 'user', 'current_user' )
     servizio_utente = fetch( 'content', 'related_objects',  hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier', openpaini( 'ControlloUtenti', 'user_servizio_attribute_ID', 909 ),'all_relations', false() ))
     ufficio_utente = fetch( 'content', 'related_objects',  hash( 'object_id', $current_user.contentobject_id, 'attribute_identifier', openpaini( 'ControlloUtenti', 'user_ufficio_attribute_ID', 911 ),'all_relations', false() ))
     new_object_initial_node_placement=false()
     browse_object_start_node=false()
}

{if $class_content.selection_type|ne( 0 )} {* If current selection mode is not 'browse'. *}
        {default attribute_base=ContentObjectAttribute}
        {let parent_node=cond( and( is_set( $class_content.default_placement.node_id ),
                               $class_content.default_placement.node_id|eq( 0 )|not ),
                               $class_content.default_placement.node_id, ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )
         nodesList=cond( and( is_set( $class_content.class_constraint_list ), $class_content.class_constraint_list|count|ne( 0 ) ),
                         fetch( content, tree,
                                hash( parent_node_id, $parent_node,
                                      class_filter_type,'include',
                                      class_filter_array, $class_content.class_constraint_list,
                                      sort_by, array( 'name',true() ),
                                      main_node_only, true() ) ),
                         fetch( content, list,
                                hash( parent_node_id, $parent_node,
                                      sort_by, array( 'name', true() )
                                     ) )
                        )
        }
        {switch match=$class_content.selection_type}

        {case match=1} {* Dropdown list *}
        <div class="buttonblock">
            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
    
        {if ne( count( $nodesList ), 0)}

            {if $view_parameters|contains('disabled')}
                {def $relazioni_trovate=0}
                <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
    
                {if $attribute.contentclass_attribute.is_required|not}
                    {if eq( $attribute.content.relation_list|count, 0 )} 
                    <option value="no_relation" selected="selected">
                        {'No relation'|i18n( 'design/standard/content/datatype' )}
                    </option>
                    {/if}
                {/if}

        		{section var=node loop=$nodesList}
                    {foreach $attribute.content.relation_list as $item}
                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                           	<option value="{$node.contentobject_id}" selected="selected">{$node.name|wash}</option>
                            {set $relazioni_trovate=1}
                        {/if}
                    {/foreach}
       	    	{/section}
{*
				{if $relazioni_trovate|gt(0)} 
				<option value="no_relation" selected="selected">
					{'No relation'|i18n( 'design/standard/content/datatype' )}
				</option>
			    	{/if}	
*}
        	    </select>
                {undef $relazioni_trovate}
    	    {else}

    		{* controlla che sia un servizio *}

                {if and( is_set( $servizio_utente[0] ), $servizio_utente[0].id|gt(0), $attribute.contentclass_attribute_identifier|eq('servizio') )}

        		{* SERVIZIO *}
		
                    <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" id="selectservizio"> 
                        {if $attribute.contentclass_attribute.is_required|not}
                            <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}</option>
                        {/if}
                        
                        {section var=node loop=$nodesList}
                            <option value="{$node.contentobject_id}"
                                {if ne( count( $attribute.content.relation_list ), 0)}
                                    {foreach $attribute.content.relation_list as $item}
                                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                                        selected="selected"
                                        {break}
                                        {/if}
                                    {/foreach}
                                {else}
                                    {if $servizio_utente[0].id|eq($item.contentobject_id)}
                                    selected="selected"
                                    {/if}
                                {/if}
                                >
                            {$node.name|wash}</option>
                        {/section}
                    </select>
                
                {elseif and($servizio_utente[0].id|gt(0), $attribute.contentclass_attribute_identifier|eq('ufficio'))}

                {* UFFICIO *}

                    {def $ufficio_selezionato=''}
                    {if ne( $attribute.content.relation_list|count, 0 )}
                        {set $ufficio_selezionato = $attribute.content.relation_list[0].contentobject_id}
                    {/if}

	                {def $uffici=fetch( 'content', 'reverse_related_objects', hash('object_id', $servizio_utente[0].id, 'attribute_identifier', 'ufficio/servizio'))}
                    <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" id="selectufficio" size=10  multiple>
                	{if $attribute.contentclass_attribute.is_required|not}
	                    <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}</option>
                        {literal}
                        <script>
                            var $ufficio_selezionato = '';
                        </script>
                        {/literal}
        	        {/if}
                    </select>


{ezscript_require( array('ezjsc::jquery') )}
{literal}
<script>
$("#selectservizio").change(function () {
    var str = "";
    $("#selectservizio option:selected").each(function () {
        str += $(this).val();
        $.post(
            //"/ezjscore/run/content/view/struttura/(classe)/servizio/(object_id)/"+str+"/(inverso)/ufficio/(selezionato)/{/literal}{$ufficio_selezionato}{literal}", 
            "/ezjscore/call/ezjsctemplate::selectstruttura::servizio::"+str+"::ufficio::{/literal}{$ufficio_selezionato}{literal}?ContentType=json", 
            function(data){
                $('#selectufficio').html(data.content);
            });
    });
})
.change();
</script>
{/literal}


                {else}
                {* NON E' NE' SERVIZIO NE' UFFICIO *}
                    {if $attribute.contentclass_attribute_identifier|eq('argomento')}                    
                        {include uri='design:content/datatype/edit/lista_argomenti.tpl' attribute_base=$attribute_base attribute_id=$attribute.id relation_list=$attribute.content.relation_list}
                    {else}
    		            <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
        		        {if $attribute.contentclass_attribute.is_required|not}
        		            <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}> {'No relation'|i18n( 'design/standard/content/datatype' )}</option>
		                {/if}
                        {section var=node loop=$nodesList}
        		            <option value="{$node.contentobject_id}"
        		            {if ne( count( $attribute.content.relation_list ), 0)}
        		            {foreach $attribute.content.relation_list as $item}
        		                 {if eq( $item.contentobject_id, $node.contentobject_id )}
        		                    selected="selected"
        		                    {break}
        		                 {/if}
        		            {/foreach}
        		            {/if}
        		            >
        		            {$node.name|wash}</option>
                        {/section}
                        </select>
                    {/if}
            	{/if}
            {/if}
        {/if}
        </div>
        {/case}

        {case match=2} {* radio buttons list *}
            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
            {if $attribute.contentclass_attribute.is_required|not}
                <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation"
                {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />{/if}
            {section var=node loop=$nodesList}
                <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                {foreach $attribute.content.relation_list as $item}
                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                     {/if}
                {/foreach}
                {/if}
                >
                {$node.name|wash} <br/>
            {/section}
        {/case}

        {case match=3} {* check boxes list *}
            {section var=node loop=$nodesList}
                <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                {foreach $attribute.content.relation_list as $item}
                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                     {/if}
                {/foreach}
                {/if}
                />
                {$node.name|wash} <br/>
            {/section}
        {/case}

        {case match=4} {* Multiple List *}
            <div class="buttonblock">
            {if ne( count( $nodesList ), 0)}
            <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" size="10" multiple>
                {section var=node loop=$nodesList}
                    <option value="{$node.contentobject_id}"
                    {if ne( count( $attribute.content.relation_list ), 0)}
                    {foreach $attribute.content.relation_list as $item}
                         {if eq( $item.contentobject_id, $node.contentobject_id )}
                            selected="selected"
                            {break}
                         {/if}
                    {/foreach}
                    {/if}
                    >
                    {$node.name|wash}</option>
                {/section}
            </select>
            {/if}
            </div>
        {/case}

        {case match=5} {* Template based, multi *}
            <div class="buttonblock">
            <div class="templatebasedeor">
                <ul>
                {section var=node loop=$nodesList}
                   <li>
                        <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                        {if ne( count( $attribute.content.relation_list ), 0)}
                        {foreach $attribute.content.relation_list as $item}
                           {if eq( $item.contentobject_id, $node.contentobject_id )}
                               checked="checked"
                               {break}
                           {/if}
                        {/foreach}
                        {/if}
                        >
                        {node_view_gui content_node=$node view=objectrelationlist}
                   </li>
                {/section}
                </ul>
            </div>
            </div>
        {/case}

        {case match=6} {* Template based, single *}
            <div class="buttonblock">
            <div class="templatebasedeor">
            <ul>
                {if $attribute.contentclass_attribute.is_required|not}
            <li>
                         <input value="no_relation" type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />
                    </li>
                {/if}
                {section var=node loop=$nodesList}
                    <li>
                        <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                        {if ne( count( $attribute.content.relation_list ), 0)}
                        {foreach $attribute.content.relation_list as $item}
                           {if eq( $item.contentobject_id, $node.contentobject_id )}
                               checked="checked"
                               {break}
                           {/if}
                        {/foreach}
                        {/if}
                        >
                        {node_view_gui content_node=$node view=objectrelationlist}
                    </li>
                {/section}
           </ul>
           </div>
           </div>
        {/case}
        {/switch}

        {if eq( count( $nodesList ), 0 )}
            {def $parentnode = fetch( 'content', 'node', hash( 'node_id', $parent_node ) )}
            {if is_set( $parentnode )}
                <p>{'Parent node'|i18n( 'design/standard/content/datatype' )}: {node_view_gui content_node=$parentnode view=text_linked} </p>
            {/if}
            <p>{'Allowed classes'|i18n( 'design/standard/content/datatype' )}:</p>
            {if ne( count( $class_content.class_constraint_list ), 0 )}
                 <ul>
                 {foreach $class_content.class_constraint_list as $class}
                       <li>{$class}</li>
                 {/foreach}
                 </ul>
            {else}
                 <ul>
                       <li>{'Any'|i18n( 'design/standard/content/datatype' )}</li>
                 </ul>
            {/if}
            <p>{'There are no objects of allowed classes'|i18n( 'design/standard/content/datatype' )}.</p>
        {/if}

        {* Create object *}
        {section show = and( is_set( $class_content.default_placement.node_id ), ne( 0, $class_content.default_placement.node_id ), ne( '', $class_content.object_class ) )}
            {def $defaultNode = fetch( content, node, hash( node_id, $class_content.default_placement.node_id ))}
            {if and( is_set( $defaultNode ), $defaultNode.can_create )}
                <div id='create_new_object_{$attribute.id}' style="display:none;">
                     <p>{'Create new object with name'|i18n( 'design/standard/content/datatype' )}:</p>
                     <input name="attribute_{$attribute.id}_new_object_name" id="attribute_{$attribute.id}_new_object_name"/>
                </div>
                <input class="button" type="button" value="Create New" name="CustomActionButton[{$attribute.id}_new_object]"
                       onclick="var divfield=document.getElementById('create_new_object_{$attribute.id}');divfield.style.display='block';
                                var editfield=document.getElementById('attribute_{$attribute.id}_new_object_name');editfield.focus();this.style.display='none';return false;" />
           {/if}
        {/section}

        {/let}
        {/default}
{else}    {* Standard mode is browsing *}
    <div class="block" id="ezobjectrelationlist_browse_{$attribute.id}">
    {if is_set( $attribute.class_content.default_placement.node_id )}
         {set browse_object_start_node = $attribute.class_content.default_placement.node_id}
    {/if}

    {* Optional controls. *}
    {include uri='design:content/datatype/edit/ezobjectrelationlist_controls.tpl'}

    {* Advanced interface. *}
    {if eq( ezini( 'BackwardCompatibilitySettings', 'AdvancedObjectRelationList' ), 'enabled' )}

            {if $attribute.content.relation_list}
                <table class="list" cellspacing="0">
                <tr class="bglight">
                    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" onclick="ezjs_toggleCheckboxes( document.editform, '{$attribute_base}_selection[{$attribute.id}][]' ); return false;" title="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" /></th>
                    <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
                    <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
                    <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
                    <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
                </tr>
                {section name=Relation loop=$attribute.content.relation_list sequence=array( bglight, bgdark )}
                    <tr class="{$:sequence}">
                    {if $:item.is_modified}
                        {* Remove. *}
                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_remove_{$Relation:index}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" /></td>
                        <td colspan="3">

                        {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )
                             version=fetch( content, version, hash( object_id, $:item.contentobject_id, version_id, $:item.contentobject_version ) )}
                        <fieldset>
                        <legend>{'Edit <%object_name> [%object_class]'|i18n( 'design/standard/content/datatype',, hash( '%object_name', $Relation:object.name, '%object_class', $Relation:object.class_name ) )|wash}</legend>

                        {section name=Attribute loop=$:version.contentobject_attributes}
                            <div class="block">
                            {if $:item.display_info.edit.grouped_input}
                                <fieldset>
                                <legend>{$:item.contentclass_attribute.name}</legend>
                                {attribute_edit_gui attribute_base=concat( $attribute_base, '_ezorl_edit_object_', $Relation:item.contentobject_id ) html_class='half' attribute=$:item}
                                </fieldset>
                            {else}
                                <label>{$:item.contentclass_attribute.name}:</label>
                                {attribute_edit_gui attribute_base=concat( $attribute_base, '_ezorl_edit_object_', $Relation:item.contentobject_id ) html_class='half' attribute=$:item}
                            {/if}
                            </div>
                        {/section}
                        {/let}
                        </fieldset>
                        </td>

                        {* Order. *}
                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_order" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" /></td>
                    {else}
                        {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )}
                        {* Remove. *}
                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_remove_{$Relation:index}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" /></td>

                        {* Name *}
                        <td>{$Relation:object.name|wash()}</td>

                        {* Type *}
                        <td>{$Relation:object.class_name|wash()}</td>

                        {* Section *}
                        <td>{fetch( section, object, hash( section_id, $Relation:object.section_id ) ).name|wash()}</td>

                        {* Order. *}
                        <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" /></td>
                        {/let}
                    {/if}
                    </tr>
                {/section}
                </table>
            {else}
                <p>{'There are no related objects.'|i18n( 'design/standard/content/datatype' )}</p>
            {/if}

            {if $attribute.content.relation_list}
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" />&nbsp;
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit selected'|i18n( 'design/standard/content/datatype' )}" />
            {else}
                <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />&nbsp;
                <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
            {/if}

            {if array( 0, 2 )|contains( $class_content.type )}
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" />
                {if $browse_object_start_node}
                <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
                {/if}                
            {else}
               <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
            {/if}

            {section show=and( $can_create, array( 0, 1 )|contains( $class_content.type ) )}
                <div class="block">
                <select id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" class="combobox" name="{$attribute_base}_new_class[{$attribute.id}]">
                {section name=Class loop=$class_list}
                   <option value="{$:item.id}">{$:item.name|wash}</option>
                {/section}
                </select>
                {if $new_object_initial_node_placement}
                    <input type="hidden" name="{$attribute_base}_object_initial_node_placement[{$attribute.id}]" value="{$new_object_initial_node_placement|wash}" />
                {/if} 
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_new_class]" value="{'Create new object'|i18n( 'design/standard/content/datatype' )}" />
                </div>
            {/section}

    {* Simple interface. *}
    {else}

        
        <table class="list{if $attribute.content.relation_list|not} hide{/if}" cellspacing="0">
        <thead>
        <tr>
            <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" onclick="ezjs_toggleCheckboxes( document.editform, '{$attribute_base}_selection[{$attribute.id}][]' ); return false;" title="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" /></th>
            <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Published'|i18n( 'design/standard/content/datatype' )}</th>
            <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
        </tr>
        </thead>
        <tbody>
        {if $attribute.content.relation_list}
            {foreach $attribute.content.relation_list as $item sequence array( 'bglight', 'bgdark' ) as $style}
              {def $object = fetch( content, object, hash( object_id, $item.contentobject_id ) )}
              <tr class="{$style}">
                {* Remove. *}
                <td><input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$item.contentobject_id}" />
                <input type="hidden" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$item.contentobject_id}" /></td>

                {* Name *}
                <td>{$object.name|wash()}</td>

                {* Type *}
                <td>{$object.class_name|wash()}</td>

                {* Section *}
                <td>{fetch( section, object, hash( section_id, $object.section_id ) ).name|wash()}</td>

                {* Published. *}
                <td>{if $item.in_trash}
                        {'No'|i18n( 'design/standard/content/datatype' )}
                    {else}
                        {'Yes'|i18n( 'design/standard/content/datatype' )}
                    {/if}
                </td>

                {* Order. *}
                <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$item.priority}" /></td>

              </tr>
              {undef $object}
            {/foreach}
        {else}
          <tr class="bgdark">
            <td><input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="--id--" />
            <input type="hidden" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation" /></td>
            <td>--name--</td>
            <td>--class-name--</td>
            <td>--section-name--</td>
            <td>--published--</td>
            <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="0" /></td>
          </tr>
        {/if}
        </tbody>
        </table>
        {if $attribute.content.relation_list|not}
            <p class="ezobject-relation-no-relation">{'There are no related objects.'|i18n( 'design/standard/content/datatype' )}</p>
        {/if}

        <div class="block inline-block ezobject-relation-browse">
        <div class="left">
                {if $attribute.content.relation_list}
                    <input class="button ezobject-relation-remove-button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" />&nbsp;
                {else}
                    <input class="button-disabled ezobject-relation-remove-button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />&nbsp;
                {/if}

                {if $browse_object_start_node}
                    <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
                {/if}

            {if is_set( $attribute.class_content.class_constraint_list[0] )}
                <input type="hidden" name="{$attribute_base}_browse_for_object_class_constraint_list[{$attribute.id}]" value="{$attribute.class_content.class_constraint_list|implode(',')}" />
            {/if}

                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" />
        </div>
        <div class="right">
            <input type="text" class="halfbox ezobject-relation-search-text" />
            <input type="submit" class="button ezobject-relation-search-btn" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Find objects'|i18n( 'design/standard/content/datatype' )}" />
            {*include uri='design:content/datatype/edit/ezobjectrelationlist_ajaxuploader.tpl'*}
        </div>
        <div class="break"></div>
        <div class="block inline-block ezobject-relation-search-browse"></div>
        </div>
        {include uri='design:content/datatype/edit/ezobjectrelation_ajax_search.tpl'}
        {/if}
    </div><!-- /div class="block" id="ezobjectrelationlist_browse_{$attribute.id}" -->
{/if}
{/let}

{*
{/if}
*}
