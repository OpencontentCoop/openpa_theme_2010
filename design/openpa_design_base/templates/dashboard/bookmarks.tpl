<h2>{'Bookmarks'|i18n( 'design/admin/pagelayout' )}</h2>

{def $bookmark_list = fetch( 'content', 'bookmarks', hash( 'limit', 20 ) )
         $bookmark_node = 0}
{if $bookmark_list}
<form action={concat("content/bookmark/")|ezurl} method="post" >
<table class="list" width="100%" cellpadding="0" cellspacing="0" border="0">

	{foreach $bookmark_list as $bookmark}
	  {set $bookmark_node = $bookmark.node}            
	  <tr>
		 <td width="1"><input type="checkbox" name="DeleteIDArray[]" value="{$bookmark.id}" /></td>
		 <td><a href={$bookmark_node.url_alias|ezurl}>{$bookmark_node.name|wash}</a></td>
	  </tr>
	{/foreach}
	<tr>
    <td colspan="2" align="left">
        <input type="image" name="RemoveButton" value="{'Remove'|i18n('design/standard/content/view')}" src={"trash.png"|ezimage} alt="{'Remove'|i18n('design/standard/content/view')}" />
    </td>    
</tr>
</table>
</form>
{/if}
{undef $bookmark_list $bookmark_node}