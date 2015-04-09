{if $fields}
  {def $fieldsParts = $fields|explode( '|' )
	   $class = fetch( content, class, hash( 'class_id', $fieldsParts[0]|trim() ) )
	   $identifiers = $fieldsParts[1]|explode( ',' )}
  {if $class}
  
  <table cellspacing="0" class="list" summary="Elenco di oggetti di tipo {$class.name|wash()}">
	  <thead>
		  <tr>
			  {foreach $identifiers as $identifier}
				{if is_set( $class.data_map[$identifier] )}
				  <th>{$class.data_map[$identifier].name|wash()}</th>
				{/if}
			  {/foreach}
			  <th>Data di pubblicazione</th>
		  </tr>
	  </thead>
	  <tbody>
		  {foreach $nodes as $item}
		  {if $item.class_identifier|eq( $class.identifier )}
		  <tr>
			  {foreach $identifiers as $i => $identifier}
				{if is_set( $item.data_map[$identifier] )}
				  <td>
					{if $i|eq(0)}<a href={$item.url_alias|ezurl()}>{/if}
					{attribute_view_gui attribute=$item.data_map[$identifier]}
					{if $i|eq(0)}</a>{/if}
				  </td>
				{/if}
			  {/foreach}
			  <td>{$item.object.published|l10n(date)} {if $item.object.modified|gt(sum($item.object.published,86400))}<br /><small>Ultima modifica: <strong>{$item.object.modified|l10n(date)}</small>{/if}</td>
		  </tr>
		  {/if}
		  {/foreach}            
	  </tbody>
  </table>
  
  <div class="square-box-soft-gray float-break">    
    <img style="vertical-align: middle" src="data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwODxAPDgwTExQUExMcGxsbHCAgICAgICAgICD/2wBDAQcHBw0MDRgQEBgaFREVGiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICD/wAARCAASAGEDAREAAhEBAxEB/8QAGwAAAQUBAQAAAAAAAAAAAAAAAAEDBAUHAgb/xAA2EAABAwIDBAgEBQUAAAAAAAACAQMEBREABhITFCHRBxUWIjFBVZMyUVSUI0JW0tNSYWJxc//EABkBAQADAQEAAAAAAAAAAAAAAAABAgMEBf/EACcRAAICAQIFBQADAAAAAAAAAAABAhEDBBITITFRkRQVMkFhcYGh/9oADAMBAAIRAxEAPwDU8l5O6PzyDSqxWqYw488zd54hMjM9S+AhdSWyeCJi0YOTpEN0W0jKfRDHZivHS45BM1JG2bbzhEoJcu6Gok0+d04YusMn/RG9HT2T+iNmRFjrSo5uzR2kZGm3XdQXQdV29SIl1TiuIWGXgbkK5k7ohbCcZU2IiU00bnJY7tkVtN08eN+GHCly5deg3IrukDJuTcvZZeqdPoMJZLZtiO2AzCxmiLwQk8sa6XEsk6fQrllSsz+U3Jiwm5r+V6OMZ0BcA9kpLoP4TIEeUhFfmqY71o8Ddc7MHlmNvE6wy087likA28qCKqyV0Uvh2ibW7d/LXbErQ4X3HGmPSo8uLUAp7+V6MMtwdojaN6kQF/MRi8oin9yXELR4Gr50OLMhyZ7cV8mJGW6QDo+KbA14L4Kio7ZUXyVOGLrQYn3I48hrrmH+nqP9u5/JifbsX75I9RIOuYf6eo/27n8mHt2L98j1EibRnaXVJbsJ+hUxpsoktxHGGTBwTaYIwUSU18CT5Yw1OihDG5K7NMeZt0JvD/8AWuPKOk1TIlIWpdGmXNm7u8qKKSYjyjrEXRUxRSC46ksa8L40xz2/wyslZbLkOnON05qQ4TzMJ2RIdDiO1dk3UluKooohEqomNfUvn+1/hXhjtXyg3OrFPqDToMBADZjGVpVG2sT7ug29K923mmIx56i13EoWxioZEjTGqgm9E1InSd424CiKgLs7snx74Lsk8cWjqWq/EHjI3S3FlSskyWYrDkh1XWbNsgplbaJfujdcW0DSycyM/wATKagVdk09Y7WXZrMp6CzTZUlWnjQ2GC1Dpb0JpLUicbrj1YqKfyVXZyu+w/XKlm+sQZkF+izBjySjEyO7ufhbuGlUujaKev8AyXhiMcMcGna+/vuTKTf0NNyM0s1iRVI9DmNPvQ9zBN3cXQuyFpHOIKhfBeypidsNu1yXWyLd3RErjGaKxNbmP0eaLwx2Y5ru7neVkdOvgCImr5J4Ytj2QVWuvciVsr+z+YfSZ32zv7cacSPdeSu1h2fzD6TO+2d/bhxI915G1lrlij1mPVXXpFOlMMjBnanXWXABLxTtciRExy62cXifNGuFPcRceEdp4Q6rVGS2TMx9tseAgDhoKf6RFwAnXda+vk+6fPAB13Wvr5PunzwAdd1r6+T7p88ACV2tot0qElF/7Oc8Addoa/6lK99znhQDtDX/AFKV77nPCgHaGv8AqUr33OeFAO0Nf9Sle+5zwoB2hr/qUr33OeFAO0Nf9Sle+5zwoB17W3Pw3KhJMC4EBPOKip8lS+ANQ0D8kwB//9k="/>
    Ottieni questi contenuti in <a href={concat("exportas/csv/",$class.identifier,"/",$node.node_id)|ezurl()}>formato <abbr title="Comma-separated values">CSV</abbr></a> o in <a href="{concat("/api/opendata/v1/content/node/",$node.node_id,"/list")}">formato <abbr title="JavaScript Object Notation">JSON</abbr></a>
  </div>
  
  {elseif fetch( 'user', 'has_access_to', hash( 'module', 'openpa', 'function', 'editor_tools' ) )}
	<div class="alert alert-warning message-warning warning">
	  Classe {$fieldsParts[0]} non trovata
	</div>
  {/if}
{/if}