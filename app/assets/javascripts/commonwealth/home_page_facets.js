$(document).ready(function() {
    /* use to auto-expand individual facets
    var facets_to_open = ['topic_facet', 'resource_decade_facet'];
    $.each(facets_to_open, function(index, value){
        $('div.blacklight-' + value + ' h5').addClass('twiddle-open');
        $('div.blacklight-' + value + ' ul').show();
    });
    */
    /* auto-expand all facets */
    $('#facets h5').addClass('twiddle-open');
    $('div.facet_limit ul').show();

    /* remove the institution facet */
    $('div.blacklight-physical_location_ssim').remove();

});