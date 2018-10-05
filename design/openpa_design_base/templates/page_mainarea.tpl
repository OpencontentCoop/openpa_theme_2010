{if is_set($module_result.content_info.persistent_variable.has_container)|not()}
<div id="columns-position" class="width-layout">
    <div id="columns" class="float-break">
        <div id="main-position">
            <div id="main" class="float-break">
                <div class="overflow-fix">
{/if}

                    {$module_result.content}

{if is_set($module_result.content_info.persistent_variable.has_container)|not()}
                </div>
            </div>
        </div>
    </div>
</div>
{/if}