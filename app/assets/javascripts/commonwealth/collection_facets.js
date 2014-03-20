$(document).ready(function() {
    /* remove the institution facet from the sidebar */
    var facet_div = $('#facets');
    facet_div.find('div.blacklight-physical_location_ssim').remove();
    facet_div.find('div.blacklight-collection_name_ssim').remove();
});
