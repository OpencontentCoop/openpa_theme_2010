    <div class="columns-blog float-break">
        <div class="main-column-position">
            <div class="main-column float-break">
                <div class="border-box">
                    <div class="content-data"></div>
                </div>
            </div>
        </div>

        <div class="extrainfo-column-position">
            <div class="extrainfo-column">
                <div class="border-box" style="padding: 10px;">
                    <div class="content-filters" style="display: none"></div>
                </div>
            </div>
        </div>
    </div>

{ezscript_require( array(
    'moment.min.js',
    'jquery.opendataTools.js',
    'chosen.jquery.js',
    'jquery.dataTables.js',
    'jquery.opendataDataTable.js'
))}
{ezcss_require( array(
    'jquery.dataTables.css',
    'chosen.css'
))}

<script type="text/javascript" language="javascript" class="init">
    var mainQuery = "classes [affissione_albo]";
    {literal}
    var facets = [
        {field: 'anno_affissione', 'limit': 300, 'sort': 'alpha', name: 'Anno di affissione'},
        {field: 'tipo_atto', 'limit': 300, 'sort': 'alpha', name: 'Tipo di atto'},
        {field: 'anno_atto', 'limit': 300, 'sort': 'alpha', name: 'Anno dell\' atto'},
        {field: 'descrizione_settore_atto', 'limit': 300, 'sort': 'alpha', name: 'Struttura'}
    ];
    $(document).ready(function () {
        var tools = $.opendataTools;
        mainQuery += ' facets ['+tools.buildFacetsString(facets)+']';
        var datatable;
        datatable = $('.content-data').opendataDataTable({
            "builder":{
                "query": mainQuery
            },
            "datatable":{
                "ajax": {
                    url: "/opendata/api/datatable/search/"
                },
                "order": [[ 0, 'desc' ],[ 1, 'desc' ]],
                "columns": [
                    {"data": "data."+tools.settings('language')+".anno_affissione", "name": 'anno_affissione', "title": 'Anno Aff.'},
                    {"data": "data."+tools.settings('language')+".numero_affissione", "name": 'numero_affissione', "title": 'N.Aff.'},
                    {"data": "data."+tools.settings('language')+".tipo_atto", "name": 'tipo_atto', "title": 'Tipologia'},
                    {"data": "data."+tools.settings('language')+".oggetto_affissione", "name": 'oggetto_affissione', "title": 'Oggetto'}
                ],
                "columnDefs": [
                    {
                        "render": function ( data, type, row ) {
                            return '<a href="/content/view/full/'+row.metadata.mainNodeId+'">'+data+'</a>';
                        },
                        "targets": [3]
                    }
                ],
                "oLanguage": {
                    "sProcessing": "Caricamento",
                    "sLengthMenu": "_MENU_ elementi per pagina",
                    "sZeroRecords": "Oooops! Nessun risultato...",
                    "sInfo": "Da _START_ a _END_ di _TOTAL_ elementi",
                    "sInfoEmpty": "",
                    "sSearch": "Cerca",
                    "oPaginate": {
                        "sFirst":    "Primo",
                        "sPrevious": "Precedente",
                        "sNext":     "Successivo",
                        "sLast":     "Ultimo"
                    }
                }
            }
        })
        .on('xhr.dt', function ( e, settings, json, xhr ) {
            //console.log(datatable.settings.builder.filters);
            var builder = JSON.stringify({
                'builder': datatable.settings.builder,
                'query': datatable.buildQuery()
            });

            $.each(json.facets, function(index,val){
                var facet = this;
                tools.refreshFilterInput(facet, function(select){
                    select.trigger("chosen:updated");
                });
            });
        })
        .data('opendataDataTable');


        tools.find(mainQuery + ' limit 1', function(response){
            datatable.loadDataTable();
            var form = $('<form class="form-inline">');
            $.each(response.facets, function(){
                tools.buildFilterInput(facets, this, datatable, function(selectContainer){
                    form.append(selectContainer);
                });
            });
            $('.content-filters').append(form).show();
        });

    });

    {/literal}
</script>
{literal}
    <style>
        .chosen-search input, .chosen-container-multi input{height: auto !important;}
        label{font-weight: bold;}
        .form-group{margin-left:5px;}
    </style>
{/literal}