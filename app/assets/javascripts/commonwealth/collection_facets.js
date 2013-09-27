$(document).ready(function() {
    /* remove the series and institution facet from the sidebar */
    $('#facets').find('div.blacklight-related_item_series_ssim').remove();
    $('#facets').find('div.blacklight-physical_location_ssim').remove();
});
