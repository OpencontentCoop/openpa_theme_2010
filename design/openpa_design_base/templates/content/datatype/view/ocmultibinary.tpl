{if and(openpaini( 'GestioneAttributi', 'oggetti_senza_label', array() )|contains($attribute.contentclass_attribute_identifier), $attribute.object.class_identifier|eq('politico'))}
<p><strong>{$attribute.contentclass_attribute_name}</strong></p>
{/if}
{if $attribute.has_content}

{foreach $attribute.content as $file}
  <p class="attribute-{$file.mime_type|slugize()}">
    <a href={concat( 'ocmultibinary/download/', $attribute.contentobject_id, '/', $attribute.id,'/', $attribute.version , '/', $file.filename ,'/file/', $file.original_filename|urlencode )|ezurl}>      
      {$file.original_filename|explode('+')|implode(' ')|wash( xhtml )}
      <br /><small>(File di tipo {$file.mime_type_part} di {$file.filesize|si( byte )})</small>
    </a>
  </p>
{/foreach}

{/if}
