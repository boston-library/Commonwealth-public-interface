/* disable nav item dropdowns for nav-collapse */
jQuery(document).ready(function() {
    jQuery('#nav_collapse_button').click( function () {
        $('#header_main_nav').find('a.dropdown-toggle').addClass('disabled');
    });
});