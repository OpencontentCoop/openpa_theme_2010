{include uri='design:page_header_languages.tpl'}

<h2 class="hide">Menu di utilit&agrave;</h2>

<ul>

	<li id="login" style="display: none"><a href={"/user/login"|ezurl} title="Login">Login</a></li>

	<li id="print" class="no-js-hide">
		<a href="javascript:window.print()" title="Stampa la pagina corrente">Stampa</a>
	</li>

{if is_area_tematica()}
	{def $area_tematica_links = fetch( 'content', 'related_objects', hash('object_id',is_area_tematica().contentobject_id, 'attribute_identifier', 'area_tematica/link'))}
    {if $area_tematica_links|count()}
        {foreach $area_tematica_links as $link}
        <li>
            {if $link.main_node.class_identifier|eq('link')}
                    <a href={$link.main_node.data_map.location.content|ezurl()} title="{$link.name|wash()}">{$link.name|wash()}</a>
            {else}
                <a href={$link.main_node.url_alias|ezurl()}>{$link.name}</a>
            {/if}
        </li>
        {/foreach}
    {/if}
{elseif openpaini( 'LinkSpeciali', 'NodoContattaci' )}
    {def $link_contatti = fetch('content','node',hash('node_id', openpaini('LinkSpeciali', 'NodoContattaci') ))}
	<li id="contatti" class="no-js-hide">
		<a href={$link_contatti.url_alias|ezurl()} title="Trova il modo migliore per contattarci">Contatti</a>
	</li>
    {/if}
	
	{def $homepage = fetch( 'openpa', 'homepage' )}
	{if and( is_set( $homepage.data_map.facebook ), $homepage.data_map.facebook.has_content )}
	<li>	  		
		<a href="{$homepage.data_map.facebook.content|wash( xhtml )}" title="{$homepage.data_map.facebook.data_text|wash( xhtml )}">
		  <img src={'icons/facebook.jpg'|ezimage} alt="Facebook" />
		</a>
	</li>
	{/if}
	{if and( is_set( $homepage.data_map.twitter ), $homepage.data_map.twitter.has_content )}
	<li>	  		
		<a href="{$homepage.data_map.twitter.content|wash( xhtml )}" title="{$homepage.data_map.twitter.data_text|wash( xhtml )}">
		  <img src={'icons/twitter.png'|ezimage} alt="Twitter" />
		</a>
	</li>
{/if}
</ul>	

<script>{literal}
$(document).ready(function(){
    var login = $('#login');
    login.find('a').attr('href', login.find('a').attr('href') + '?url='+ ModuleResultUri);
    var injectUserInfo = function(data){
		if(data.error_text || !data.content){
			login.show();
		}else{
            login.after('<li id="myprofile"><a href="/user/edit/" title="Visualizza il profilo utente">Il mio profilo</a></li><li id="logout"><a href="/user/logout" title="Logout">Logout ('+data.content.name+')</a></li>');
			if(data.content.has_access_to_dashboard){
                login.after('<li id="dashboard"><a href="/content/dashboard/" title="Pannello strumenti">Pannello strumenti</a></li>');
			}
		}
	};
	if(CurrentUserIsLoggedIn){
		$.ez('openpaajax::userInfo', null, function(data){
			injectUserInfo(data);
		});
	}else{
        login.show();
	}
});
{/literal}</script>