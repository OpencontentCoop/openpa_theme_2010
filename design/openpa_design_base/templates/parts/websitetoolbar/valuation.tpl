{*
	TEMPLATE  per la valutazione delle pagine da parte degli utenti
	node_id	nodo di riferimento
*}

{def $valuations=fetch( 'content', 'class', hash( 'class_id', 'valuation' ) )}

<div id="valutazione-position">

{def $valutazione=$valuations.object_list[0]
	 $node = fetch(content,node,hash(node_id,$node_id))
	 $data_map=$valutazione.data_map}

  <div id="valutazione" class="float-break">
	<form action="/content/action" method="post">
	  <fieldset>
		<legend>{$valutazione.name|wash()}</legend>
		
		{if is_set($data_map.useful)}
		<div class="block">
		  <input type="hidden" value="" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.useful.id}" />
		  <span class="grouplabel">{$data_map.useful.contentclass_attribute_name|wash()}</span>
		  <label for="utilita1"><input id="utilita1" type="radio" value="0" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.useful.id}[]" />per nulla</label>
		  <label for="utilita2"><input id="utilita2" type="radio" value="1" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.useful.id}[]" />poco</label>
		  <label for="utilita3"><input id="utilita3" type="radio" value="2" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.useful.id}[]" />abbastanza</label>
		  <label for="utilita4"><input id="utilita4" type="radio" value="3" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.useful.id}[]" />molto</label>
		</div>
		{/if}
		
		{if is_set($data_map.easy)}
		<div class="block">
		  <span class="grouplabel">{$data_map.easy.contentclass_attribute_name|wash()}</span>
		  <input type="hidden" value="" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.easy.id}" />
		  <label for="semplicita1"><input id="semplicita1" type="radio" value="0" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.easy.id}[]" />per nulla</label>
		  <label for="semplicita2"><input type="radio" id="semplicita2" value="1" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.easy.id}[]" />poco</label>
		  <label for="semplicita3"><input type="radio" id="semplicita3" value="2" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.easy.id}[]" />abbastanza</label>
		  <label for="semplicita4"><input type="radio" id="semplicita4" value="3" name="ContentObjectAttribute_ezselect_selected_array_{$data_map.easy.id}[]" />molto</label>
		</div>
		{/if}
		
		{if is_set($data_map.comment)}
		<div class="block">
		  <label for="helpcomment" class="grouplabel">{$data_map.comment.contentclass_attribute_name|wash()}</label>
		  <input id="helpcomment" class="halfbox left" type="text" value="" name="ContentObjectAttribute_ezstring_data_text_{$data_map.comment.id}"  />
		</div>
		{/if}
		
		{if is_set($data_map.email_aiutaci)}
		<div class="block">
		  <label for="helpemail_aiutaci" class="grouplabel">{$data_map.email_aiutaci.contentclass_attribute_name|wash()}</label>
		  <input id="helpemail_aiutaci" class="halfbox left" type="text" value="" name="ContentObjectAttribute_ezstring_data_text_{$data_map.email_aiutaci.id}"  />
		</div>
		{/if}
		
		<input class="box" type="hidden" value="Nodo: {$node.node_id}; Oggetto:{$node.contentobject_id}; Versione: {$node.contentobject_version}; Titolo: {$node.name|wash()}" name="ContentObjectAttribute_ezstring_data_text_{$data_map.nodo.id}" />
		<input class="box" type="hidden" value="/{$node.url_alias}" name="ContentObjectAttribute_ezstring_data_text_{$data_map.link.id}" />
		<input type="hidden" value="{$valutazione.main_node.node_id}" name="TopLevelNode"/>
		<input type="hidden" value="{$valutazione.main_node.node_id}" name="ContentNodeID"/>
		<input type="hidden" value="{$valutazione.id}" name="ContentObjectID"/>
		<div class="right">

			{if is_set($data_map.antispam)}
				{if $data_map.antispam.data_type_string|eq('ocrecaptcha')}
					<div class="block float-break">
						<label class="grouplabel">{$data_map.antispam.contentclass_attribute_name|wash()}</label>
						<div style="float: left">{attribute_view_gui attribute=$node.data_map.antispam}</div>
					</div>
				{else}
					{ezcss_require( array( 'nxc.captcha.css' ) )}
					{ezscript_require( array( 'nxc.captcha.js' ) )}

					{def $attribute = $data_map.antispam
					$class_content = $attribute.contentclass_attribute.content
					$regenerate = 1}

					<div class="block float-break">
						<label class="grouplabel">
							<img id="nxc-captcha-{$attribute.id}" alt="{'Secure code'|i18n( 'extension/nxc_captcha' )}" title="{'Secure code'|i18n( 'extension/nxc_captcha' )}" src="{concat( 'nxc_captcha/get/', $attribute.contentclass_attribute.id, '/nxc_captcha_collection_attribute_', $attribute.id, '/', $regenerate )|ezurl( 'no' )}" />
							<br /><a href="{concat( 'nxc_captcha/get/', $attribute.contentclass_attribute.id, '/nxc_captcha_collection_attribute_', $attribute.id, '/1' )|ezurl( 'no' )}" class="nxc-captcha-regenerate" id="nxc-captcha-regenerate-{$attribute.id}">Ricarica</a>
						</label>
						<input class="captcha-input halfbox" id="nxc-captcha-collection-input-{$attribute.id}" type="text" name="nxc_captcha_{$attribute.id}" value="" size="{$class_content.length.value}" maxlength="{$class_content.length.value}" />
						<br ><em>Inserisci il codice di sicurezza che vedi nell'immagine per proteggere il sito dallo spam</em>
					</div>
				{/if}


				{undef $attribute $class_content $regenerate}
			{/if}
		  
		  <input class="defaultbutton" type="submit" value="Invia la valutazione" name="ActionCollectInformation"/>
		</div>
	  </fieldset>	
	</form>
  </div>
</div>
