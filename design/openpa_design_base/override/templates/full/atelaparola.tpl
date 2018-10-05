{def $extra_info = 'extra_info'
     $left_menu = ezini('SelectedMenu', 'LeftMenu', 'menu.ini')
     $openpa = object_handler($node)
     $homepage = fetch('openpa', 'homepage')
     $current_user = fetch('user', 'current_user')
     $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )}
{include uri='design:parts/openpa/wrap_full_open.tpl'}

{def $link = openpaini( 'LinkSpeciali', 'ATeLaParolaDistrictID', '6542690' )}
<iframe src="http://www.sensorcivico.it/startup?districtId={$link}" width="100%" height="855px" frameborder="0" scrolling="no">
  Impossibile leggere la pagina come iframe... Si prega di connettersi alla pagina esterna http://www.sensorcivico.it/startup?districtId={$link}
</iframe>

{include uri='design:parts/openpa/wrap_full_close.tpl'}