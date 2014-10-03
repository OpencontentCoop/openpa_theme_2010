{def $valid_nodes = $block.valid_nodes
     $show_link = true()}
    
<div class="block-type-lista block-{$block.view} block-lista_tab">

  {if $block.name}
	  <h2 class="block-title">{$block.name}</h2>
  {else}
	  <h2 class="block-title">{$block.name|wash()}</h2>
  {/if}

  <div  class="ui-tabs">		
	<div class="tabs-panels">
	  <div class="border-box box-violet box-tabs-panel">
	  <div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
	  <div class="border-ml"><div class="border-mr"><div class="border-mc">
	  <div class="border-content">		  
		  <ul class="eventi-cycle">								
			  {foreach $valid_nodes as $index => $child}
				  <li class="evento-cycle">
				  {node_view_gui content_node=$child view='event'}
				  </li>
			  {/foreach}
		  </ul>		  
	  </div>
	  </div></div></div>
	  </div>
	  
	  <div class="border-box box-violet-gray box-tabs-footer tab-link">
	  <div class="border-ml"><div class="border-mr"><div class="border-mc">
	  <div class="border-content">				
		  <a class="calendar arrows" href={$valid_nodes[0].parent.url_alias|ezurl()} title="{$block.name}"><span class="arrows-blue-r">Vedi tutto il calendario</span></a>			
	  </div>
	  </div></div></div>
	  <div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
	  </div>
	</div>
  </div>
</div>
    
