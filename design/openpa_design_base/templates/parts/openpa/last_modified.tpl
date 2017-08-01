{def $show = true()}
{if openpaini( 'GestioneClassi', 'NascondiTuttiUltimaModifica', '' )|eq( 'enabled' )}
    {set $show = false()}
{/if}
{if openpaini( 'GestioneClassi', 'NascondiUltimaModifica', array() )|contains( $node.class_identifier )}
    {set $show = false()}
{/if}
{if find_first_parent('trasparenza')}{set $show = true()}{/if}
{if $show}
<div class="last-modified">di {$node.object.published|l10n(date)} {if $node.object.modified|gt(sum($node.object.published,86400))}- Ultima modifica: <strong>{$node.object.modified|l10n(date)}</strong>{/if}</div>
{/if}

{def $node_languages = $node.object.languages}
{if $node_languages|count()|gt(1)}
    <p>
    {foreach $node_languages as $language}
        {def $is_current = cond( $language.locale|eq($node.object.current_language), true(), false())}
        <span class="language-link">
            {if $is_current|not()}
            <a href="{concat( $node.url_alias, '/(language)/', $language.locale )|ezurl(no)}">
            {/if}
                <img src="{$language.locale|flag_icon}" width="18" height="12" alt="{$language.locale}" />
                <span>{$language.name|wash()}</span>
            {if $is_current|not()}
            </a>
            {/if}
        </span>
        {undef $is_current}
    {/foreach}
    </p>
{/if}
{undef $node_languages}
