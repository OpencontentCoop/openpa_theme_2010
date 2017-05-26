{def $permission_array = $attribute.content.permission_array}
{def $builder = 'Default'}
{if $attribute.contentclass_attribute.data_text1}
    {set $builder = $attribute.contentclass_attribute.data_text1}
{/if}

{default attribute_base=ContentObjectAttribute}
    <div class="eztags-wrapper">
        <div id="eztags{$attribute.id}" class="tagselection"
             data-eztags
             data-base-url="{'/opendata/api/tags_tree/'|ezurl(no)}/"
             data-builder="{$builder|wash}"
             data-max-results="{ezini( 'GeneralSettings', 'MaxResults', 'eztags.ini' )}"
             data-has-add-access="{cond( $permission_array.can_add, 'true', true(), 'false' )}"
             data-subtree-limit="{$attribute.contentclass_attribute.data_int1}"
             data-hide-root-tag="{$attribute.contentclass_attribute.data_int3}"
             data-max-tags="{if $attribute.contentclass_attribute.data_int4|gt( 0 )}{$attribute.contentclass_attribute.data_int4}{else}0{/if}"
             data-locale="{$attribute.language_code}"
             data-icon-path="{'eng-GB'|flag_icon()|explode('src="')|extract_right(1)|implode('')|explode('eng-GB')|extract_left(1)|implode('')}"
        >
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="tagnames" type="hidden" name="{$attribute_base}_eztags_data_text_{$attribute.id}" value="{$attribute.content.keyword_string|wash}"  />
            <input id="ezcoa2-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="tagpids" type="hidden" name="{$attribute_base}_eztags_data_text2_{$attribute.id}" value="{$attribute.content.parent_string|wash}"  />
            <input id="ezcoa3-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="tagids" type="hidden" name="{$attribute_base}_eztags_data_text3_{$attribute.id}" value="{$attribute.content.id_string|wash}"  />
            <input id="ezcoa4-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="taglocales" type="hidden" name="{$attribute_base}_eztags_data_text4_{$attribute.id}" value="{$attribute.content.locale_string|wash}"  />
        <div class="formdata">Attendere caricamento...</div>
        </div>
    </div>

{run-once}{literal}
    <script>
        $(document).ready(function(){
            var getCurrentTags = function($element){
                var tagnamesInput = $element.find('.tagnames');
                var tagpidsInput = $element.find('.tagpids');
                var tagidsInput = $element.find('.tagids');
                var taglocalesInput = $element.find('.taglocales');
                var tagnames = tagnamesInput.val().split('|#');
                var tagpids = tagpidsInput.val().split('|#');
                var tagids = tagidsInput.val().split('|#');
                var taglocales = taglocalesInput.val().split('|#');
                var tags = [];
                $.each(tagnames, function(index, value){
                    if (value != ''){
                        tags.push({
                            name: value,
                            id: tagids[index],
                            parentId: tagpids[index],
                            locale: taglocales[index]
                        });
                    }
                });

                return tags;
            };
            var setCurrentTags = function(tags, $element){
                var tagnamesInput = $element.find('.tagnames');
                var tagpidsInput = $element.find('.tagpids');
                var tagidsInput = $element.find('.tagids');
                var taglocalesInput = $element.find('.taglocales');
                var tagnames = [];
                var tagpids = [];
                var tagids = [];
                var taglocales = [];
                $.each(tags, function(index, value){
                    tagnames[index] = value.name;
                    tagpids[index] = value.parentId;
                    tagids[index] = value.id;
                    taglocales[index] = value.locale;
                });
                tagnamesInput.val(tagnames.join('|#'));
                tagpidsInput.val(tagpids.join('|#'));
                tagidsInput.val(tagids.join('|#'));
                taglocalesInput.val(taglocales.join('|#'));
            };
            var addTag = function($element, tag, parentTag){
                var config = $element.data();
                var tags = getCurrentTags($element);
                tags.push({
                    name: tag.keywordTranslations[config.locale],
                    id: tag.id,
                    parentId: parentTag.id,
                    locale: config.locale
                });
                setCurrentTags(tags, $element);
            };
            var removeTag = function($element, tag, parentTag){
                var tags = getCurrentTags($element);
                var newTags = [];
                $.each(tags, function(index, value){
                    if (value.id + '' != tag.id + '') {
                        newTags.push(value);
                    }
                });
                setCurrentTags(newTags, $element);
            };
            var onChangeCheckbox = function(e, $element){
                var input = $(e.currentTarget);
                var tag = input.data('tag');
                var parentTag = input.data('parentTag');
                if($(e.currentTarget).is(':checked')){
                    addTag($element, tag, parentTag);
                }else{
                    removeTag($element, tag, parentTag);
                }
            };
            var writeCheckbox = function(tag, parentTag, $container, recursion, $element, selected){
                var config = $element.data();
                var checkbox = $('<input type="checkbox" />');
                if($.inArray(tag.id+'', selected) > -1){
                    checkbox.attr('checked', 'checked');
                }
                checkbox.data('tag', tag);
                checkbox.data('parentTag', parentTag);
                checkbox.bind('change', function(e){onChangeCheckbox(e, $element)});
                var margin = (recursion > 0 && config.hideRootTag == 1) ? (recursion-1) * 20 : recursion * 20;
                var label = $('<label style="font-weight: normal; margin-left: '+margin+'px"></label>')
                        .append(checkbox)
                        .append(tag.keywordTranslations[config.locale]);
                if (recursion == 0 && config.hideRootTag == 1) label.hide();

                $container.append(label);

                if (tag.hasChildren){
                    recursion++;
                    $.each(tag.children, function(index,child) {
                        writeCheckbox(child, tag, $container, recursion, $element, selected);
                    });
                }
            };
            $('.tagselection').each(function(){
                var $element = $(this);
                var $container = $element.find('.formdata');
                var selected = $element.find('.tagids').val().split('|#');
                $.getJSON($element.data('base-url') + $element.data('subtree-limit'), function(data) {
                    $container.html('');
                    writeCheckbox(data, null, $container, 0, $element, selected);
                });
            });
        });
    </script>
{/literal}{/run-once}

{/default}
