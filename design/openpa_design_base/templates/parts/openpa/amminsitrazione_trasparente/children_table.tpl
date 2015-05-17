{* template per visualizzazione tabellare per i figli di pagina_trasparenza
   le variabili attese sono:
   - nodes: array di ezcontentobjectrenode
   - nodes_count: intero conteggio totale (in caso di fetch con parametro limit)
   - class: stringa o array classi da visualizzare
*}

{if count( $nodes )}
    
    {if $class|is_array()}
        
        {* tabella generica di oggetti di classi di vario tipo *}
        <table cellspacing="0" class="list" summary="Elenco di {$node.name|wash()}">
            <thead>
                <tr>
                    <th>Link al dettaglio</th>
                    <th>Data di pubblicazione</th>
                </tr>
            </thead>
            <tbody>
                {foreach $nodes as $item}
                <tr>
                    <td><a href={$item.url_alias|ezurl()} title="Vai al dettaglio di {$item.name|wash()}">{$item.name|wash()}</a></td>
                    <td>{$item.object.published|l10n(date)} {if $item.object.modified|gt(sum($item.object.published,86400))}<br /><small>Ultima modifica: <strong>{$item.object.modified|l10n(date)}</small>{/if}</td>
                </tr>
                {/foreach}            
            </tbody>
        </table>
    
    {elseif $class|is_string()}
    
        {* tabelle orientate alle classi *}
        {switch match=$class}
            
            {* dipendente *}
            {case match='dipendente'}
                <table cellspacing="0" class="list" summary="Elenco di {$node.name|wash()}">
                    <thead>
                        <tr>
                            <th>Nominativo</th>
                            <th>Qualifica</th>
                            <th>Data di pubblicazione</th>                         
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $nodes as $item}
                        <tr>
                            <td><a href={$item.url_alias|ezurl()} title="Vai al dettaglio di {$item.name|wash()}">{$item.name|wash()}</a></td>
                            <td>
                                {def $roles = fetch( 'openpa', 'ruoli', hash( 'dipendente_object_id', $item.contentobject_id ) )}
                                {foreach $roles as $role}
                                    {$role.name|wash()}
                                    {delimiter}<br />{/delimiter}
                                {/foreach}
                                {undef $roles}
                            </td>
                            <td>{$item.object.published|l10n(date)} {if $item.object.modified|gt(sum($item.object.published,86400))}<br /><small>Ultima modifica: <strong>{$item.object.modified|l10n(date)}</small>{/if}</td>                           
                        </tr>
                        {/foreach}            
                    </tbody>
                </table>             
            {/case}
            
            {* generica mostra gli attributi principali *}
            {case}
                <table cellspacing="0" class="list" summary="Elenco di {$node.name|wash()}">
                    <thead>
                        <tr>
                            <th>Link al dettaglio</th>
                            <th>Data di pubblicazione</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $nodes as $item}
                        <tr>
                            <td><a href={$item.url_alias|ezurl()} title="Vai al dettaglio di {$item.name|wash()}">{$item.name|wash()}</a></td>
                            <td>{$item.object.published|l10n(date)} {if $item.object.modified|gt(sum($item.object.published,86400))}<br /><small>Ultima modifica: <strong>{$item.object.modified|l10n(date)}</small>{/if}</td>
                        </tr>
                        {/foreach}            
                    </tbody>
                </table>        
            {/case}
            
        {/switch}
    {/if}

{/if}