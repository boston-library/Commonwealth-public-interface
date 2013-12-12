//= require blacklight/core

Blacklight.setup_modal = function(link_selector, form_selector, launch_modal) {
    jQuery(link_selector).click(function(e) {
        link = jQuery(this)

        e.preventDefault();

        var jqxhr = jQuery.ajax({
            url: link.attr('href'),
            dataType: 'script'
        });

        jqxhr.always( function (data) {
            jQuery('#ajax-modal').html(data.responseText);
            Blacklight.setup_modal('.modal-footer a', '#ajax-modal form.ajax_form', false);

            if (launch_modal) {
                jQuery('#ajax-modal').modal();
            }
            BlacklightGoogleAnalytics.track_modal_facet_clicks();
            BlacklightGoogleAnalytics.track_modal_form();
            Blacklight.check_close_ajax_modal();
        });

    });


    jQuery(form_selector).submit(function(e) {
        var jqxhr = jQuery.ajax({
            url: jQuery(this).attr('action'),
            data: jQuery(this).serialize(),
            type: 'POST',
            dataType: 'script'
        });


        jqxhr.always (function (data) {
            jQuery('#ajax-modal').html(data.responseText);
            Blacklight.setup_modal('#ajax-modal .ajax_reload_link', '#ajax-modal form.ajax_form', false);
            Blacklight.check_close_ajax_modal();
        });


        return false;


    });
};

Blacklight.check_close_ajax_modal = function() {
    if (jQuery('#ajax-modal span.ajax-close-modal').length) {
        modal_flashes = jQuery('#ajax-modal .flash_messages');

        main_flashes = jQuery('#main-flashes .flash_messages:nth-of-type(1)');
        jQuery('#ajax-modal *[data-dismiss="modal"]:nth-of-type(1)').trigger('click');
        main_flashes.append(modal_flashes);
        modal_flashes.fadeIn(500);



    }

}

jQuery(document).ready( function() {
    Blacklight.setup_modal("a.lightboxLink,a.more_facets_link,.ajax_modal_launch", "#ajax-modal form.ajax_form", true);
});