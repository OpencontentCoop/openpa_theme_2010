<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<form action={concat($module.functions.edit.uri,"/",$userID)|ezurl} method="post" name="Edit">

<div class="user-edit">

<div class="attribute-header">
  <h1 class="long">{"User profile"|i18n("design/ezwebin/user/edit")}</h1>
</div>

<div class="block">
  <label>{"Username"|i18n("design/ezwebin/user/edit")}</label>
  {*<div class="labelbreak"></div>*}
  {$userAccount.login|wash}
</div>

<div class="block">
  <label>{"Email"|i18n("design/ezwebin/user/edit")}</label>
  {*<div class="labelbreak"></div>*}
  <p class="box">{$userAccount.email|wash(email)}</p>
</div>

<div class="block">
  <label>{"Name"|i18n("design/ezwebin/user/edit")}</label>
  {*<div class="labelbreak"></div>*}
  <p class="box">{$userAccount.contentobject.name|wash}</p>
</div>

<div class="block">
<label>{"Impostazioni personali"|i18n("design/ezwebin/user/edit")}</label>
<ul>

{if fetch( 'user', 'has_access_to', hash( 'module', 'notification', 'function', 'use' ) )}
  <li><a href={"notification/settings"|ezurl}>{"My notification settings"|i18n("design/ezwebin/user/edit")}</a></li>
{/if}

{if fetch( 'user', 'has_access_to', hash( 'module', 'shop', 'function', 'administrate' ) )}
  <li><a href={concat("/shop/customerorderview/", $userID, "/", $userAccount.email)|ezurl}>{"My orders"|i18n("design/ezwebin/user/edit")}</a></li>
{/if}

{if fetch( 'user', 'has_access_to', hash( 'module', 'openpa_booking', 'function', 'book' ) )}
  {foreach fetch( 'openpa_booking', 'handlers' ) as $handler}
    <li><a href={concat("openpa_booking/view/", $handler.identifier)|ezurl}>{$handler.name}</a></li>
  {/foreach}
{/if}

</ul>
</div>

<div class="buttonblock">
<input class="button" type="submit" name="EditButton" value="{'Edit profile'|i18n('design/ezwebin/user/edit')}" />
<input class="button" type="submit" name="ChangePasswordButton" value="{'Change password'|i18n('design/ezwebin/user/edit')}" />
<a class="button" href={"user/logout"|ezurl}>Esci</a>
</div>

</div>

</form>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
