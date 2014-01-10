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

    // validate date field input
    jQuery("#advanced_search_form").find(".advanced_submit").click(function(event){
        var date_start_input = jQuery("#date_range_start").val();
        var date_end_input = jQuery("#date_range_end").val();
        if ((date_start_input) || (date_end_input)) {
            var date_input = new Array(date_start_input,date_end_input);
            var date_error = false;
            jQuery.each(date_input, function(key,val) {
                if ((val.length != 0) && (!val.match(/[12]+\d\d\d/))) {
                    date_error = true;
                }
            });
            if (date_error == false) {
                if (((date_input[0].length != 0) && (date_input[1].length != 0)) && (parseInt(date_input[1]) < parseInt(date_input[0]))) {
                    date_error = true;
                }
            }
            if (date_error == true) {
                alert("You entered an invalid date range in the 'Year' section.\nPlease change the dates and try again.");
                event.preventDefault();
            }
        }
    });


});
