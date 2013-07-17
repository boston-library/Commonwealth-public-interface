// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require blacklight_advanced_search/blacklight_advanced_search_javascript


//= require jquery_ujs
//= require jquery.ui.dialog
//
// Required by Blacklight
//= require blacklight/blacklight

//= require bootstrap-dropdown
// NOTE: unlinking bs-carousel because current bootstrap-sass gem version is not up-to-date
//       due to BL dependency. Will create local file instead. Relink once gem updated.
//= require bootstrap-carousel

//= require blacklight_google_analytics/blacklight_google_analytics

// WARNING: require tree has been disabled to avoid djatoka_viewer JS files being automatically included
//          since the viewer uses mooTools/Prototype, which causes namespace conflicts with jQuery
// WARNING: to require any further app-specific JS, you must use the 'require_directory' directive
// require_tree .
