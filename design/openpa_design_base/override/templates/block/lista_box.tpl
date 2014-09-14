{*
	Vista blocco simile a numerini che però visualizza uno sotto l'altro gli elementi
	Questa vista ammette UNICAMENTE OGGETTI DI TIPO AVVISO, per aggiungere altri tipi di oggetti implementare l'array $class_filter
*}

{def $customs=$block.custom_attributes
     $errors=false()
     $sort_array=array()
     $classes=array()
     $classi_senza_data_inline = openpaini( 'GestioneClassi', 'classi_senza_data_inline', array())
     $classi_con_data_inline = openpaini( 'GestioneClassi', 'classi_con_data_inline', array())
     $classi_blocco_particolari = openpaini( 'GestioneClassi', 'classi_blocco_particolari', array())
     $classi_senza_correlazioni_inline = openpaini( 'GestioneClassi', 'classi_senza_correlazioni_inline', array())
     $attributes_to_show=array('organo_competente', 'circoscrizione')
     $attributes_with_title=array('servizio','argomento')
     $curr_ts = currentdate()
}

{if $customs.limite|gt(0)}
    {def $limit=$customs.limite}
{else}
    {def $limit=10}
{/if}

{if $customs.livello_profondita|eq('')}
    {def $depth=10}
{else}
    {def $depth=$customs.livello_profondita}
{/if}

{def $nodo=fetch(content,node,hash(node_id,$customs.node_id))}

{switch match=$customs.ordinamento}
{case match=''}
    {set $sort_array=$nodo.sort_array}
{/case}
{case match='priorita'}
    {set $sort_array=array('priority', true())}
{/case}
{case match='pubblicato'}
    {set $sort_array=array('published', false())}
{/case}
{case match='modificato'}
    {set $sort_array=array('modified', false())}
{/case}
{case match='nome'}
    {set $sort_array=array('name', true())}
{/case}
{/switch}

{* se la sorgente è virtualizzata restituisce i risultati della virtualizzazione *}
{if and( is_set( $nodo.data_map.classi_filtro ), $nodo.data_map.classi_filtro.has_content )}        
	{set $classes = $nodo.data_map.classi_filtro.content|explode(',')}
	{def $virtual_classes = array()
		 $virtual_subtree = array()}
	{foreach $classes as $class}
		{set $virtual_classes = $virtual_classes|append( $class|trim() )}
	{/foreach}
	{if $nodo.data_map.subfolders.has_content}
		{foreach $nodo.data_map.subfolders.content.relation_list as $relation}
			{set $virtual_subtree = $virtual_subtree|append( $relation.node_id )}
		{/foreach}
	{else}
		{set $virtual_subtree = array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )}
	{/if}
	
	{switch match=$customs.ordinamento}
	{case match='priorita'}
		{set $sort_array=hash('priority', 'asc')}
	{/case}
	{case match='pubblicato'}
		{set $sort_array=hash('published', 'desc' )}
	{/case}
	{case match='modificato'}
		{set $sort_array=hash('modified', 'desc')}
	{/case}
	{case match='nome'}
		{set $sort_array=hash('name', 'asc')}
	{/case}            
	{case}
		{set $sort_array=hash('published', 'desc' )}
	{/case}
	{/switch}
	
	{def $search_hash = hash( 'subtree_array', $virtual_subtree,                                  
							  'limit', $limit,
							  'class_id', $virtual_classes,
							  'sort_by', $sort_array
							  )
		 $search = fetch( ezfind, search, $search_hash )             
		 $children_count = $search['SearchCount']}
{/if}

{if and( is_set( $children_count ), $children_count|gt(0) )}
	{def $children = $search['SearchResult']}
{elseif $customs.escludi_classi|ne('')}
    {set $classes=$customs.escludi_classi|explode(',')}
    {set $classes = merge($classes, openpaini( 'GestioneClassi', 'classi_da_escludere_dai_blocchi_ezflow', array())) }
        {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                                                        'class_filter_type', 'exclude',
                                                        'class_filter_array', $classes,
                                                        'depth', $depth,
                                                        'limit', $limit,
                                                        'sort_by', $sort_array) )}
{elseif $customs.includi_classi|ne('')}
    {set $classes=$customs.includi_classi|explode(',')}

    {if $customs.includi_classi|ne('news')}
         {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                            'class_filter_type', 'include', 'class_filter_array', $classes,
                            'depth', $depth, 'limit', $limit, 'sort_by', $sort_array) )}
    {else}
        {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                                                        'attribute_filter', array( 'and',
                                                             array( 'news/data_inizio_pubblicazione_news', '<=', $curr_ts  ),
                                                             array( 'news/data_fine_pubblicazione_news', '>=', $curr_ts  )),
                                                        'class_filter_type', 'include', 'class_filter_array', array('news'),
                                                        'depth', $depth,
                                                        'limit', $limit,
                                                        'sort_by', array('published', false())) )}
    {/if}
{else}
    {set $classes = openpaini( 'GestioneClassi', 'classi_da_escludere_dai_blocchi_ezflow', array())}
        {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                                                        'class_filter_type', 'exclude',
                                                        'class_filter_array', $classes,
                                                        'depth', $depth,
                                                        'limit', $limit,
                                                        'sort_by', $sort_array) )}
{/if}


<div class="block-type-lista block-{$block.view}">

	{if $block.name}
		<h2 class="block-title">
		<a href={$nodo.url_alias|ezurl()} title="Vai a {$block.name|wash()}">{$block.name}</a>
		</h2>
	{/if}

	<div class="border-box box-gray box-numeri">
	<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
	<div class="border-ml"><div class="border-mr"><div class="border-mc">
	<div class="border-content">
        
        {foreach $children as $index => $child}
        <div id="{$child.name|slugize()}-{$child.node_id}">

        {if $child.class_identifier|eq('news')}
        
            <div class="attribute-header">
                <h3>
                   <a{if $index|eq(0)} class="active"{/if} href={$child.parent.url_alias|ezurl()} title="{$child.parent.name|wash()}">{$child.parent.name|wash()}</a>
                </h3>
            </div>
            
            <div class="attribute-small">	
            {if $classi_con_data_inline|contains($child.class_identifier)}
                di {$child.object.published|l10n(date)}
            {/if}
            </div>
            
            {if $child.parent.data_map.image.has_content}
                <div class="attribute-image no-js-hide">
                    {attribute_view_gui attribute=$child.parent.data_map.image image_class=lista_accordion}
                </div>
            {else}
                {include node=$child.parent uri='design:parts/common/class_icon.tpl' css_class="image-medium"}                         
            {/if}
            
            <div class="no-js-hide">
            {if and( is_set($child.data_map.testo_news), $child.data_map.testo_news.has_content )}
                    {attribute_view_gui attribute=$child.data_map.testo_news}
                
            {elseif $child|has_abstract()}
                <p>{$child|abstract()}</p>
            
            {/if}
            </div>

            {* mostro gli altri attributi *}
            {foreach $child.parent.data_map as $attribute}
        
            {if $attributes_to_show|contains($attribute.contentclass_attribute_identifier)}
                {if $attribute.has_content}
                 <div class="no-js-hide">{attribute_view_gui attribute=$attribute}</div>
                {/if}
            {elseif $attributes_with_title|contains($attribute.contentclass_attribute_identifier)}
        
                {if $attribute.has_content}
                {if $classi_senza_correlazioni_inline|contains($child.class_identifier)|not}
                    <div class="no-js-hide">
                        <strong>{$attribute.contentclass_attribute_name}: </strong>
                        {attribute_view_gui href=nolink attribute=$attribute}
                    </div>
                {/if}
                {/if}
            {/if}			
            {/foreach}

        {else}

    
            <div class="attribute-header">
                <h3>
                {if $child.class_identifier|eq('link')}
                        <a href={$child.data_map.location.content|ezurl()} title="Apri il link in una pagina esterna (si lascerà il sito)">{$child.name|wash()}</a>
                {else}
                    <a{if $index|eq(0)} class="active"{/if} href={$child.url_alias|ezurl()}>{$child.name|wash()}</a>
                {/if}
                </h3>
            </div>

            					
            {if $classi_con_data_inline|contains($child.class_identifier)}
                <div class="attribute-small">
                di {$child.object.published|l10n(date)}
                </div>
            {/if}            

            {if and(is_set($child.data_map.image), $child.data_map.image.has_content)}
                <div class="attribute-image no-js-hide">
                    {attribute_view_gui attribute=$child.data_map.image image_class=lista_accordion}
                </div>
            {else}
                {include node=$child uri='design:parts/common/class_icon.tpl' css_class="image-medium"}                           
            {/if}
            
            <div class="no-js-hide">
            {if and( is_set($child.data_map.abstract), $child.data_map.abstract.has_content)}
                {attribute_view_gui attribute=$child.data_map.abstract}

            {elseif and( is_set($child.data_map.oggetto), $child.data_map.oggetto.has_content)}
                <div class="attribute-object">
                    {attribute_view_gui attribute=$child.data_map.oggetto}
                </div>

            {elseif $child|has_abstract()}
                <p>{$child|abstract()|openpa_shorten(300)}</p>                
            {/if}	
            </div>					
        
        
            {* mostro gli altri attributi *}
            {foreach $child.data_map as $attribute}
                {if $attributes_to_show|contains($attribute.contentclass_attribute_identifier)}
                    {if $attribute.has_content}
                     <div class="no-js-hide">{attribute_view_gui attribute=$attribute}</div>
                    {/if}
                {elseif $attributes_with_title|contains($attribute.contentclass_attribute_identifier)}
                    {if $attribute.has_content}
                        {if $classi_senza_correlazioni_inline|contains($child.class_identifier)|not}
                            <div class="no-js-hide">
                                <strong>{$attribute.contentclass_attribute_name}: </strong>
                                {attribute_view_gui href=nolink attribute=$attribute}
                            </div>
                        {/if}
                    {/if}
                {/if}			
            {/foreach}
        
        {/if}

        </div>
        {delimiter}<hr class="clear" />{/delimiter}
        {/foreach}


	</div>
	</div></div></div>
	<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
	</div>	

</div>