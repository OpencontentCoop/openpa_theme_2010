    <div id="extrainfo-position">
      <div id="extrainfo">
        {if is_array( $extra_menu )}
            {foreach $extra_menu as $item}
                {include uri=concat('design:parts/', $item, '.tpl')}
                {delimiter}<div class="hr"></div>{/delimiter}
            {/foreach}
        {else}
            {include uri=concat('design:parts/', $extra_menu, '.tpl')}
        {/if}
      </div>
    </div>
