{* file personalizzato per area intranet: oggetti correlati *}

{* attributi richiesti: 
$attribute_base
$attribute_id
$relation_list *}

{def $argomenti=array()}
<select name="{$attribute_base}_data_object_relation_list_{$attribute_id}[]">
	<option value="">Nessun argomento</option>
{def $macroargomenti=fetch(content,list,hash(parent_node_id, openpaini( 'Nodi', 'MacroArgomenti', 809 ), sort_by, array(name, true())))}
{if count($macroargomenti)|gt(0)}
{foreach $macroargomenti as $macroargomento}
	{set $argomenti=fetch(content,list,hash(parent_node_id, $macroargomento.node_id, sort_by, array(name, true())))}
	{if $argomenti|count()|gt(0)}
		<optgroup label="{$macroargomento.name}">
		{foreach $argomenti as $argomento}
			<option
			 value="{$argomento.object.id}"
			{if ne( count( $relation_list ), 0)}
			{foreach $relation_list as $item}
					   {if eq( $item.contentobject_id, $argomento.contentobject_id )}
							selected="selected"
						  {break}
					   {/if}
					{/foreach}
			{/if}
			 >{$argomento.name}</option>
		{/foreach}
		</optgroup>
	{else}
		<option
				value="{$macroargomento.object.id}"
				{if ne( count( $relation_list ), 0)}
					{foreach $relation_list as $item}
						{if eq( $item.contentobject_id, $macroargomento.contentobject_id )}
							selected="selected"
							{break}
						{/if}
					{/foreach}
				{/if}
		>{$macroargomento.name}</option>
	{/if}
{/foreach}
{else}
	{foreach $nodesList as $argomento}
		<option
				value="{$argomento.object.id}"
				{if ne( count( $relation_list ), 0)}
					{foreach $relation_list as $item}
						{if eq( $item.contentobject_id, $argomento.contentobject_id )}
							selected="selected"
							{break}
						{/if}
					{/foreach}
				{/if}
		>{$argomento.name}</option>
	{/foreach}
{/if}
</select>
{undef $macroargomenti $argomenti}
