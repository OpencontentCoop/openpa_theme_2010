    <div id="sidemenu-position">
      <div id="sidemenu">
        {if is_array( $left_menu )}
            {foreach $left_menu as $menu}
                {include uri=concat('design:menu/', $menu, '.tpl')}
                {delimiter}<div class="hr"></div>{/delimiter}
            {/foreach}
        {else}
            {include uri=concat('design:menu/', $left_menu, '.tpl')}
        {/if}
       </div>
    </div>
