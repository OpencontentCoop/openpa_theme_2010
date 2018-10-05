{ezpagedata_set( 'extra_menu', false() )}
{def $sortString = 'published-desc'
     $default_filters = array( concat( solr_meta_subfield('argomento','main_parent_node_id'),':', $node.node_id ) )
     $facets = array(        
        hash( 'field', 'meta_class_identifier_ms', 'name', 'Tipologia_di_contenuto', 'limit', 100, 'sort', 'alpha' ),
        hash( 'field', solr_meta_subfield('argomento','id'), 'name', 'Argomento', 'limit', 100, 'sort', 'alpha' ),
        hash( 'field', solr_meta_subfield('evento_vita','id'), 'name', 'Evento_della_vita', 'limit', 100, 'sort', 'alpha' )
     )
}

{include name=folder_facet
         uri='design:content/facetsearch.tpl'
         node=$node
         subtree=array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )
         facets=$facets
         classes=false()
         default_filters=$default_filters
         useDateFilter=true()
         view_parameters=$view_parameters
         sortString=$sortString}