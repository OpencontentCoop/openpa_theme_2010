{def $uploadable_classes = array( 'file_pdf', 'file', 'image')
     $can_upload = false()}
{foreach $attribute.class_content.class_constraint_list as $class}
  {if $uploadable_classes|contains( $class )}{set $can_upload=true()}{break}{/if}
{/foreach}

{if and( ezmodule( 'ezjscore' ), $can_upload )}
    <input type="submit" value="{'Carica file'|i18n( 'openpa' )}"
            name="RelationUploadNew{$attribute.id}-{$attribute.version}"
            class="button relation-upload-new hide"
            title="{'Aggiungi un file da filesystem'|i18n( 'openpa' )}" />

    {run-once}
    {ezcss_require(array('modalwindow.css','yui_container.css'))}
    {ezscript_require( array( 'ezjsc::yui3', 'ezjsc::yui3io', 'ezmodalwindow.js', 'ezajaxuploader.js' ) )}
    <span id="ajaxuploader-loader"></span>
    <div id="relationlist-modal-window" class="modal-window" style="display:none;">
        <h2><a href="#" class="window-close">{'Chiudi'|i18n( 'openpa' )}</a><span></span></h2>
        <div class="window-content"></div>
    </div>
    <script type="text/javascript">
    {literal}
    (function () {
        YUI(YUI3_config).use('ezmodalwindow', 'ezajaxuploader', function (Y) {
            var uploaderConf = {
                target: {},
                open: {
                    action: 'ezajaxuploader::uploadform::ezobjectrelationlist'
                },
                upload: {
                    action: 'ezajaxuploader::upload::ezobjectrelationlist?ContentType=html',
                    form: 'form.ajaxuploader-upload'
                },
                location: {
                    action: 'ezajaxuploader::preview::ezobjectrelationlist',
                    form: 'form.ajaxuploader-location',
                    browse: 'div.ajaxuploader-browse',
        {/literal}
                    required: "{'Seleziona la collocazione'|i18n( 'openpa' )|wash( 'javascript' )}"
        {literal}
                },

                preview: {
                    form: 'form.ajaxuploader-preview',

                    // this is the eZAjaxUploader instance
                    callback: function () {
                        var box = Y.one('#ezobjectrelationlist_browse_' + this.conf.target.ObjectRelationsAttributeId),
                            table = box.one('table.list');
                            tbody = box.one('table.list tbody'),
                            last = tbody.get('children').slice(-1).item(0),
                            tr = false, priority = false, tds = false,
                            result = this.lastMetaData;

                        if ( !table.hasClass('hide') ) {
                            // table is visible, clone the last line
                            tr = last.cloneNode(true);
                            tbody.append(tr);
                            if ( last.hasClass('bgdark') ) {
                                tr.removeClass('bgdark').addClass('bglight');
                            } else {
                                tr.removeClass('bglight').addClass('bgdark');
                            }
                        } else {
                            // table is hidden, no related object yet
                            // the only line in the table is the "template line"
                            tr = last;
                            table.removeClass('hide');
                        }
                        tds = tr.get('children');
                        tds.item(0).all('input').set('value', result.object_info.id);
                        tds.item(1).setContent(result.object_info.name);
                        tds.item(2).setContent(result.object_info.class_name);
                        tds.item(3).setContent(result.object_info.section_name);
                        tds.item(4).setContent(result.object_info.published);
                        priority = tds.item(5).one('input');
                        priority.set('value', parseInt(priority.get('value')) + 1);

                        box.one('.ezobject-relation-remove-button').removeClass('button-disabled').addClass('button').set('disabled', false);
                        box.all('.ezobject-relation-no-relation').addClass('hide');

                        this.modalWindow.close();
                    }
                },
        {/literal}
                validationErrorText: "{'Alcuni campi obbligatori sono vuoti.'|i18n( 'openpa' )|wash( 'javascript' )}",
                parseJSONErrorText: "{'Errore di lettura del json di risposta.'|i18n( 'openpa' )|wash( 'javascript' )}",
                title: "{'Aggiungi un file da filesystem'|i18n( 'openpa' )|wash( 'javascript' )}"
        {literal}
            };

            var windowConf = {
                window: '#relationlist-modal-window',
                centered: false,
                xy: ['centered', 50],
                width: 650
            };

            Y.on('domready', function() {
                var win = new Y.eZ.ModalWindow(windowConf),
                    tokenNode = Y.one('#ezxform_token_js');

                Y.all('.relation-upload-new').each(function () {
                    var data = this.get('name').replace("RelationUploadNew", '').split("-"),
                        conf = Y.clone(uploaderConf, true),
                        uploader;

                    conf.target = {
                       ObjectRelationsAttributeId: data[0],
                       Version: data[1]
                    };
                    if ( tokenNode ) {
                        conf.token = tokenNode.get('title');
                    }
                    uploader = new Y.eZ.AjaxUploader(win, conf);
                    this.on('click', function (e) {
                        uploader.open();
                        e.halt();
                    });
                    this.removeClass('hide');
                });
            });
        });

    })();
    {/literal}
    </script>
    {/run-once}
{/if}
{undef $can_upload $uploadable_classes}
