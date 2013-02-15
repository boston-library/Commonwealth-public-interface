/* have to change '$' to 'jQuery' to avoid conflict with Prototype in image show view */
jQuery(document).ready(function() {

    /* Stuff for handling the checkboxes */
    /* When you click a checkbox, update readout */


    /* Pass in a jquery obj holding the "selected facet element" spans,  get back
     a string for display representing currently checked things. */
    function checkboxesToString(checkbox_elements) {
        var selectedLabels = new Array();
        checkbox_elements.each(function() {
            if (jQuery(this).is(":checked")) {
                selectedLabels.push( jQuery(this).next('.facet-value').text());
            }
        });
        return selectedLabels.join(" OR ");
    }

    //Pass in JQuery object of zero or more <div class="facet_item"> blocks,
    //that contain an h3, some checkboxes, and a span.adv_facet_selections for
    //display of current selections. Will update the span.
    function updateSelectedDisplay(facet_item) {
        var checkboxes = jQuery(facet_item).find("input:checkbox");
        var displaySpan = jQuery(facet_item).find("span.adv_facet_selections");
        var displayStr = checkboxesToString( checkboxes );

        displaySpan.text( displayStr );
        if (displayStr == "") {
            displaySpan.hide();
        } else {
            displaySpan.show();
        }


    }

    // on page load, set initial properly
    jQuery(".facet_item").each(function() {
        updateSelectedDisplay(this);
    });

    //change on checkbox change
    jQuery(".facet_item input:checkbox").change( function() {
        updateSelectedDisplay( jQuery(this).closest(".facet_item"));
    });


});
