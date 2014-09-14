{def $foldersClasses = array( 'folder', 'pagina_sito' )}

{if $block.custom_attributes.node_id|gt(0)}
    {def $node_id = $block.custom_attributes.node_id}
    {def $subtreearray = array( $block.custom_attributes.node_id )}
{else}
    {def $node_id = ezini( 'NodeSettings', 'RootNode', 'content.ini' )}
    {def $subtreearray = array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )}
{/if}

{if $block.custom_attributes.class|ne('')}    
    {def $class_filter = $block.custom_attributes.class|explode(',')}
{/if}

{def $limit=10}

{def $node = fetch(content,node,hash(node_id,$node_id))
     $attributi_da_escludere_dalla_ricerca = openpaini( 'GestioneAttributi', 'attributi_da_escludere_dalla_ricerca' )
     $anni = openpaini( 'MotoreDiRicerca', 'RicercaAvanzataSelezionaAnni', array())}


{set-block variable=$open}
<div class="border-box box-gray block-search">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc">
<div class="border-content">
{/set-block}

{set-block variable=$close}
</div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>					
</div>
{/set-block}

{ezscript_require(array( 'ezjsc::jquery', 'ui-widgets.js', 'ui-datepicker-it.js' ) )}
{ezcss_require( array( 'datepicker.css' ) )}
<script type="text/javascript">
{literal}
$(function() {
	$(".block-search-advanced-link p").click(function () {
		$(this).toggleClass('open');
		$(this).next().slideToggle("slow");		
    });
    $( ".from_picker" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        changeYear: true,
        dateFormat: "dd-mm-yy",
        numberOfMonths: 1

    });
    $( ".to_picker" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        changeYear: true,
        dateFormat: "dd-mm-yy",
        numberOfMonths: 1
    });
});
{/literal}
</script>

<form id="search-form-box-{$block.id}" action="{'content/search'|ezurl('no')}" method="get">
	<fieldset>
		<legend class="block-title"><span>{$block.name}</span></legend>

        {$open}
    
        <label for="search-string">Ricerca libera</label>
        <input id="search-string" type="text" name="SearchText" value="" />

        {if is_set( $class_filter[0] )}
            
            {def $class = fetch( 'content', 'class', hash( 'class_id', $class_filter[0] ) )}
            
            {def $sorters = array()
                 $filter_string = ''}
            
            {foreach $class.data_map as $attribute}
            {if and($attribute.is_searchable, $attribute.identifier|ne('errors'), $attributi_da_escludere_dalla_ricerca|contains($attribute.identifier)|not())}
                {switch match=$attribute.data_type_string}
                    {case in=array('ezstring','eztext')}
                           {set $sorters = $sorters|append( hash( 'name', $attribute.name, 'value', concat( 'attr_', $attribute.identifier, '_s' ) ) )}
                    {/case}
                    {case in=array('ezdate', 'ezdatetime')}
                        {set $filter_string = concat( 'attr_', $attribute.identifier, '_dt' )}
                        {set $sorters = $sorters|append( hash( 'name', $attribute.name, 'value', $filter_string ) )}
                    {/case}
                    {case in=array('ezinteger')}
                        {set $sorters = $sorters|append( hash( 'name', $attribute.name, 'value', concat( 'attr_', $attribute.identifier, '_si' ) ) )}
                    {/case}
                    {case}
                    {/case}
                {/switch}
            {/if}
            {/foreach}
        
            <label for="Sort">Ordina per</label>
            <select id="Sort" name="Sort">
                <option value=""> - Seleziona</option>
                <option value="published">Data di pubblicazione</option>
                <option value="score">Rilevanza</option>                
                {foreach $sorters as $sorter}
                    {if and( $sorter.name|ne( 'Nome' ), $sorter.name|ne( 'Rilevanza' ), $sorter.name|ne( 'Tipologia di contenuto' ), $sorter.name|ne( 'Data di pubblicazione' ) )}
                        <option value="{$sorter.value}">{$sorter.name}</option>
                    {/if}
                {/foreach}
            </select>

            <label for="Order">Ordinamento</label>
            <select name="Order" id="Order">
                <option value="desc">Discendente</option>
                <option value="asc">Ascendente</option>
                {foreach $sorters as $sorter}
                    {if and( $sorter.name|ne( 'Nome' ), $sorter.name|ne( 'Rilevanza' ), $sorter.name|ne( 'Tipologia di contenuto' ), $sorter.name|ne( 'Data di pubblicazione' ) )}
                        <option value="{$sorter.value}">{$sorter.name}</option>
                    {/if}
                {/foreach}
            </select>

            {def $facets = array()
                 $filterParameter = false()}            
            <div class="block-search-advanced-container square-box-soft-gray-2">
            <div class="block-search-advanced-link">
            
            <p>Ricerca avanzata</p>                
            
            <div class="block-search-advanced hide">
                
            {foreach $class.data_map as $attribute}
            {if and($attribute.is_searchable, $attribute.identifier|ne('errors'), $attributi_da_escludere_dalla_ricerca|contains($attribute.identifier)|not())}
                {switch match=$attribute.data_type_string}
                    
                    {case in=array('ezstring','eztext')}
                    {set $filterParameter = getFilterParameter( concat( 'attr_', $attribute.identifier, '_t' ) )}
                    {set $sorters = $sorters|append( hash( 'name', $attribute.name, 'value', concat( 'attr_', $attribute.identifier, '_t' ) ) )}
                        <label for="{$attribute.identifier}">{$attribute.name}</label>
                        <input id="{$attribute.identifier}" type="text" name="filter[{concat( 'attr_', $attribute.identifier, '_t' )}]" value="{if is_set($filterParameter[0])}{$filterParameter[0]}{/if}" />
                    {/case}
                    
                    {case in=array('ezobjectrelationlist')}
                        {set $facets = $facets|append( hash( 'field', concat( 'submeta_', $attribute.identifier, '___main_node_id_si' ), 'name', $attribute.name, 'limit', 10 ) )}
                    {/case}
                    
                    {case in=array('ezdate', 'ezdatetime')}
                        {set $filter_string = concat( 'attr_', $attribute.identifier, '_dt' )}
                        {set $sorters = $sorters|append( hash( 'name', $attribute.name, 'value', $filter_string ) )}
                        {if $attribute.identifier|eq('data_archiviazione')|not()}
                            <fieldset>
                                <legend>{$attribute.name}:</legend>
                                <label for="from">Dalla data: <small class="no-js-show"> (GG-MM-AAAA)</small>
                                <input type="text" class="from_picker" name="from_attributes[{$filter_string}]" title="Dalla data" value="" /></label>
                                <label for="to">Alla data: <small class="no-js-show"> (GG-MM-AAAA)</small>
                                <input class="to_picker" type="text" name="to_attributes[{$filter_string}]" title="Alla data" value="" /></label>
                            </fieldset>
                        {/if}                    
                    {/case}
                    
                    {case}
                    {/case}
                    
                    {case in=array('ezinteger')}
                        {if $attribute.identifier|eq('annoxxx')}
                        <label for="{$attribute.identifier}">{$attribute.name}</label>
                            <select id="{$attribute.identifier}" name="anno_s[]">
                                    <option value="">Qualsiasi anno</option>
                                    {foreach $anni as $anno}
                                    <option {if $anno|eq($anno_s[0])} class="marked" selected="selected"{/if} value="{$anno}">{$anno}</option>
                                    {/foreach}
                            </select>
                        {else}
                            {set $filterParameter = getFilterParameter( concat( 'attr_', $attribute.identifier, '_si' ) )}
                            <label for="{$attribute.identifier}">{$attribute.name}</label>
                            <input id="{$attribute.identifier}" size="5" type="text" name="filter[{concat( 'attr_', $attribute.identifier, '_si' )}]" value="{if is_set($filterParameter[0])}{$filterParameter[0]}{/if}" />
                        {/if}
                        {set $sorters = $sorters|append( hash( 'name', $attribute.name, 'value', concat( 'attr_', $attribute.identifier, '_si' ) ) )}
                    {/case}                
                {/switch}
            {/if}
            {/foreach}
            
            <fieldset>
                <legend>Data di pubblicazione:</legend>
                <label for="from">Dalla data: <small class="no-js-show"> (GG-MM-AAAA)</small>
                <input type="text" class="from_picker" name="from" title="Dalla data" value="" /></label>
                <label for="to">Alla data: <small class="no-js-show"> (GG-MM-AAAA)</small>
                <input class="to_picker" type="text" name="to" title="Alla data" value="" /></label>
            </fieldset>
            
            <input name="filter[]" value="contentclass_id:{$class.id}" type="hidden" />
            <input name="OriginalNode" value="{$node.node_id}" type="hidden" />
            {if is_array($subtreearray)}
                {set $subtreearray = $subtreearray|unique()} 
                {foreach $subtreearray as $sta}
                    <input name="SubTreeArray[]" type="hidden" value="{$sta}" />
                {/foreach}
            {else}
            <input name="SubTreeArray[]" type="hidden" value="{$subtreearray}" />
            {/if}
            
            {if count($facets)}
                {def $filters_parameters = getFilterParameters()
                     $cleanFilterParameters = array()
                     $tempFilter = false()}
                
                {def $query = cond( ezhttp( 'SearchText','get','hasVariable' ), ezhttp( 'SearchText', 'get' ), '' )}
                {if count( $subtreearray )|eq(0)}
                    {set $subtreearray = array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )}
                {/if}
                {def $filters_hash = hash( 'query', $query,
                                              'class_id', array( $class.id ),
                                              'limit', 1,
                                              'subtree_array', $subtreearray,
                                              'sort_by', hash( 'score', 'desc' ),
                                              'facet', $facets,
                                              'filter', $filters_parameters
                                             )
                     $filters_search = fetch( ezfind, search, $filters_hash )
                     $filters_search_extras = $filters_search['SearchExtras']
                }
                
                {def $nameList = array()}
                
                {def $baseURI=concat( '/content/advancedsearch?', 'OriginalNode=', $node.node_id, '&SubTreeArray[]=', $subtreearray|implode( '&SubTreeArray[]=' ) )}
                {def $uriSuffix = $filters_parameters|getFilterUrlSuffix()}
        
                {if $class}
                    {set $uriSuffix = concat( $uriSuffix, '&filter[contentclass_id]=', $class.id )}
                {/if}
        
                {def $activeFacetParameters = array()}
                {if ezhttp_hasvariable( 'activeFacets', 'get' )}
                    {set $activeFacetParameters = ezhttp( 'activeFacets', 'get' )}
                {/if}
                {foreach $activeFacetParameters as $facetField => $facetValue}
                    {set $uriSuffix = concat( $uriSuffix, '&activeFacets[', $facetField, ']=', $facetValue )}
                {/foreach}                
        
                {foreach $facets as $key => $facet}            
                    {if $filters_search_extras.facet_fields.$key.nameList|count()}
                        <fieldset>
                        <legend>{$facet['name']}</legend>
                        
                        {if count($filters_search_extras.facet_fields.$key.nameList)|gt(5)}
                            <select name="filter[]">
                                <option value=""> - Seleziona</option>
                            {foreach $filters_search_extras.facet_fields.$key.nameList as $key2 => $facetName}
                                {if ne( $key2, '' )}
                                    {def $filterName = $filters_search_extras.facet_fields.$key.queryLimit[$key2]|explode(':')
                                         $filterValue = getFilterParameter( $filterName[0] )}
                                    <option {if $filterValue|contains( $facetName )} selected="selected" {/if} value='{$filters_search_extras.facet_fields.$key.queryLimit[$key2]}'>{if fetch( 'content', 'node', hash( 'node_id', $facetName ))}{fetch( 'content', 'node', hash( 'node_id', $facetName )).name|wash()}{else}{$facetName}{/if} ({$filters_search_extras.facet_fields.$key.countList[$key2]})</option>
                                    {undef $filterName $filterValue}
                                {/if}
                            {/foreach}
                            </select>
                        {else}
                            {foreach $filters_search_extras.facet_fields.$key.nameList as $key2 => $facetName}
                                {if ne( $key2, '' )}
                                    {def $filterName = $filters_search_extras.facet_fields.$key.queryLimit[$key2]|explode(':')
                                         $filterValue = getFilterParameter( $filterName[0] )}                            
                                    <label>
                                        <input {if $filterValue|contains( $facetName )} checked="checked" {/if} class="inline" type="checkbox" name="filter[]" value='{$filters_search_extras.facet_fields.$key.queryLimit[$key2]}' /> {if fetch( 'content', 'node', hash( 'node_id', $facetName ))}{fetch( 'content', 'node', hash( 'node_id', $facetName )).name|wash()}{else}{$facetName}{/if} ({$filters_search_extras.facet_fields.$key.countList[$key2]})
                                    </label>
                                    {undef $filterName $filterValue}
                                {/if}
                            {/foreach}
                        {/if}
                        </fieldset>
                    {else}
                        {def $filterValue = getFilterParameter( $facet.field )} 
                        {if count( $filterValue )|gt(0)}
                        <fieldset>
                            <legend>{$facet['name']}</legend>
                            <label>
                                <input checked="checked" class="inline" type="checkbox" name="filter[]" value='{concat( $facet.field, ':', $filterValue[0] )}' /> {if fetch( 'content', 'node', hash( 'node_id', $filterValue[0] ))}{fetch( 'content', 'node', hash( 'node_id', $filterValue[0] )).name|wash()}{else}{$filterValue[0]}{/if}
                            </label>
                        </fieldset>
                        {/if}
                        {undef $filterValue}
                    {/if}
                    
                {/foreach}
                
            {/if}
            
            
            </div>
            
            </div>
            </div>
            {/if}
    
        <input id="search-button-button" class="defaultbutton" type="submit" name="SearchButton" value="Cerca" />
        {$close}
    
	</fieldset>
</form>
