{*ezcss_load( array( 'altocontrasto.css', 'debug.css', 'websitetoolbar.css'), 'screen' )*}

{* DEFINIZIONE DELLO STILE PERSONALIZZATO DELLE AREE TEMATICHE *}
{def $area_tematica_css = false()}
{if is_set(openpacontext().area_tematica_css_file)}
	{set $area_tematica_css = openpacontext().area_tematica_css_file}
{/if}

{* DEFINIZIONE DELLO STILE PERSONALIZZATO DEI FORM DI EDIT DI FRONTEND *}
{def $style_edit_css = false()}
{if or( openpacontext().is_edit, eq($ui_context, 'browse') )}
	{set $style_edit_css = 'style_edit.css'}
{/if}

{if is_unset( $load_css_file_list )}
	{def $load_css_file_list = true()}
{/if}
{if $load_css_file_list}
  {ezcss_load( array( 'core.css',
					  'debug.css',
					  'pagelayout.css',
					  'content.css',
					  'websitetoolbar.css',
					  'bullet.css',
					  'calendar.css',
					  'carousel.css',
					  'ezfind.css',
					  'block.css',
					  'forum.css',
					  'table.css',
					  'borders.css',
					  'arrows.css',
					  ezini( 'StylesheetSettings', 'CSSFileList', 'design.ini' ),
					  $area_tematica_css,
					  $style_edit_css,
					  'custom.css' ), 'screen' ) }
{else}
  {ezcss_load( array( 'core.css',
					  'debug.css',
					  'pagelayout.css',
					  'content.css',
					  'websitetoolbar.css',
					  'bullet.css',
					  'calendar.css',
					  'carousel.css',
					  'ezfind.css',
					  'block.css',
					  'forum.css',
					  'table.css',
					  'borders.css',
					  'arrows.css',
					  $area_tematica_css,
					  $style_edit_css,
					  'custom.css' ), 'screen' ) }
{/if}

<link rel="stylesheet" type="text/css" href={"stylesheets/print.css"|ezdesign} media="print" />
<!--[if IE 5]>     <style type="text/css"> @import url({"stylesheets/browsers/ie5.css"|ezdesign(no)});    </style> <![endif]-->
<!--[if lte IE 6]> <style type="text/css"> @import url({"stylesheets/browsers/ie6lte.css"|ezdesign(no)}); </style> <![endif]-->
<!--[if lte IE 7]> <style type="text/css"> @import url({"stylesheets/browsers/ie7lte.css"|ezdesign(no)}); </style> <![endif]-->
<!--[if IE]> <style type="text/css"> @import url({"stylesheets/browsers/ie.css"|ezdesign(no)}); </style> <![endif]-->