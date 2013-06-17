/*
 IIPImage Javascript Viewer <http://iipimage.sourceforge.net>
 Version 1.1

 Copyright (c) 2007-2008 Ruven Pillay <ruven@users.sourceforge.net>

 Built using the Mootools 1.2 javascript framework <http://www.mootools.net>


 ---------------------------------------------------------------------------

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 ---------------------------------------------------------------------------


 Example:

 iip = new IIP( 'div_id', { server: '/fcgi-bin/iipsrv.fcgi',
 image: '/images/test.tif',
 credit: 'copyright me 2008',
 zoom: 2,
 render: 'random',
 showNavButtons: whether to show navigation buttons: true (default) or false
 scale: 100 } );

 where the arguments are:
 i) The id of the main div element in which to create the viewer window
 ii) A hash containting:
 image: the full image path (or array of paths) on the server (required)
 server: the iipsrv server full URL (defaults to "/fcgi-bin/iipsrv.fcgi")
 credit: image copyright or information (optional)
 zoom: the initial zoom level (optional - defaults to 1)
 render: tile rendering style - 'spiral' for a spiral from the centre or
 'random' for a rendering of tiles in a random order
 scale: pixels per mm

 Note: The new class instance must be assigned to the global variable "iip" in this version.
 : Requires mootools version 1.2 <http://www.mootools.net>
 : The page MUST have a standard-compliant XHTML declaration at the beginning

 */



// Global instance of our IIP object for use by the TargetDrag class
var iip;



/* Create our own class inherited from Drag for constrained dragging of
 the main target window
 */
var TargetDrag = new Class({

    Extends: Drag,

    // Simply copy the parent class initialize function
    initialize: function(){
        var params = Array.link(arguments, {
            'options': Type.isObject,
            'element': function(obj){
                return obj != null;
            }
        });

        this.element = document.id(params.element);
        this.document = this.element.getDocument();
        this.setOptions(params.options || {});
        var htype = typeOf(this.options.handle);
        this.handles = ((htype == 'array' || htype == 'collection') ? $$(this.options.handle) : document.id(this.options.handle)) || this.element;
        this.mouse = {'now': {}, 'pos': {}};
        this.value = {'start': {}, 'now': {}};

        this.selection = (Browser.ie) ? 'selectstart' : 'mousedown';


        if (Browser.ie && !Drag.ondragstartFixed){
            document.ondragstart = Function.from(false);
            Drag.ondragstartFixed = true;
        }

        this.bound = {
            start: this.start.bind(this),
            check: this.check.bind(this),
            drag: this.drag.bind(this),
            stop: this.stop.bind(this),
            cancel: this.cancel.bind(this),
            eventStop: Function.from(false)
        };
        this.attach();
    },

    // Create our own drag implementation
    drag: function(event){
        if (this.options.preventDefault) event.preventDefault();
        this.mouse.now = event.page;
        for (var z in this.options.modifiers){
            if (!this.options.modifiers[z]) continue;
            this.value.now[z] = this.mouse.now[z] - this.mouse.pos[z];

            if( z == 'x' ){
                if( iip.rgn_x - this.value.now[z] < 0 ){
                    this.value.now[z] = iip.rgn_x;
                    this.out = true;
                }
                if( iip.wid > iip.rgn_w ){
                    if( iip.rgn_x - this.value.now[z] > iip.wid - iip.rgn_w ){
                        this.value.now[z] = -(iip.wid - iip.rgn_w - iip.rgn_x);
                        this.out = true;
                    }
                }
                else{
                    this.value.now[z] = 0;
                    this.out = true;
                }
            }
            if( z == 'y' ){
                if( iip.rgn_y - this.value.now[z] < 0 ){
                    this.value.now[z] = iip.rgn_y;
                    this.out = true;
                }
                if( iip.hei > iip.rgn_h ){
                    if( iip.rgn_y - this.value.now[z] > iip.hei - iip.rgn_h ){
                        this.value.now[z] = -(iip.hei - iip.rgn_h - iip.rgn_y);
                        this.out = true;
                    }
                }
                else{
                    this.value.now[z] = 0;
                    this.out = true;
                }
            }

            if (this.options.grid[z]) this.value.now[z] -= (this.value.now[z] % this.options.grid[z]);
            if (this.options.style) this.element.setStyle(this.options.modifiers[z], this.value.now[z] + this.options.unit);
            else this.element[this.options.modifiers[z]] = this.value.now[z];
        }
        this.fireEvent('drag', this.element);
    }

});





/* IIP Javascript Class
 */
var IIP = new Class({


    /* Initialize some variables. The constructor takes 4 arguments:
     i) The id of the main div element in which to create the viewer window
     ii) A hash containting:
     image: the full image path (or array of paths) on the server (required)
     server: the iipsrv server full URL (defaults to "/fcgi-bin/iipsrv.fcgi")
     credit: image copyright or information (optional)
     zoom: the initial zoom level (optional - defaults to 1)
     render: tile rendering style - 'spiral' for a spiral from the centre or
     'random' for a rendering of tiles in a random order (default)
     showNavButtons: whether to show navigation buttons: true (default) or false
     scale: pixels per mm
     */
    initialize: function( main_id, options ) {

        var viewer_container = new Element("div",{'id': 'img_viewer'}).inject(main_id);

        this.source = viewer_container; // main_id || alert( 'No element ID given to IIP constructor' );

        this.server = options['server']; // || '/fcgi-bin/iipsrv.fcgi';

        this.render = options['render'] || 'random';

        this.images = new Array(options['image'].length);
        options['image'] || alert( 'Image location not set in IIP constructor options');
        if( $type(options['image']) == 'array' ){
            for( i=0; i<options['image'].length;i++ ){
                this.images[i] = { src:options['image'][i], sds:"0,90" };
            }
        }
        else this.images = [{ src:options['image'], sds:"0,90"} ];


        this.credit = options['credit'] || null;

        this.scale = options['scale'] || null;

        if( options['zoom'] == 0 ) this.initialZoom = 0;
        else this.initialZoom = options['zoom'] || 1;

        this.showNavButtons = true;
        if( options['showNavButtons'] == false ) this.showNavButtons = false;

        // If we want to assign a function for a click within the image
        // - used for multispectral curve visualization, for example
        this.targetclick = options['targetclick'] || null;

        this.max_width = options['max_width'] || alert('Image width not available!');
        this.max_height = options['max_height'] || alert('Image height not available!');
        this.min_x = 0;
        this.min_y = 0;
        this.sds = "0,90";
        this.contrast = 1.0;
        this.opacity = 0;
        this.wid = 0;
        this.hei = 0;
        this.rgn_x = 0;
        this.rgn_y = 0;
        this.rgn_w = this.wid;
        this.rgn_h = this.wid;
        this.xfit = 0;
        this.yfit = 0;
        this.navpos = [0,0];
        this.tileSize = [256,256];
        this.num_resolutions = options['levels'] || alert('Image levels not available!');
        this.res = this.num_resolutions;
        //this.res = 0;
        this.refresher = null;

        // Number of tiles loaded
        this.nTilesLoaded = 0;
        this.nTilesToLoad = 0;

        // start djatoka add
        this.max_zoom = 7;
        this.top_left_x = 0;
        this.top_left_y = 0;
        this.svc_val_fmt = "info:ofi/fmt:kev:mtx:jpeg2000";
        this.svc_id = "info:lanl-repo/svc/getRegion";
        this.openUrl = "";
        // end djatoka add


        /* Load us up when the DOM is fully loaded!
         */
        window.addEvent( 'domready', function(){ this.load() }.bind(this) );

        // debug
        this.debugImageViewer();

    },

    debugImageViewer: function () {
        alert(
            'initalZoom:' + this.initialZoom + '; \n' +
            'this.max_width:' + this.max_width + '; \n' +
            'this.max_height:' + this.max_height + '; \n' +
                'this.rgn_w:' + this.rgn_w + '; \n' +
                'this.rgn_h:' + this.rgn_h + '; \n' +
                'this.res:' + this.res + '; \n' +
                'this.min_x:' + this.min_x + '; \n' +
                'this.min_y:' + this.min_y + '; \n' +
                'this.wid:' + this.wid + '; \n' +
                'this.hei:' + this.hei + '; \n'

        );

    },

    /* Create the appropriate CGI strings and change the image sources
     */
    requestImages: function() {

        // Clear our tile refresher
        if( this.refresher ){
            $clear( this.refresher );
            this.refresher = null;
        }

        // Set our cursor
        document.id('target').setStyle( 'cursor', 'wait' );

        // Load our image mosaic
        this.loadGrid();

        // Create a tile refresher to check for unloaded tiles
        this.refresher = this.refresh.periodical( 500, this );

    },



    /* Create a grid of tiles with the appropriate JTL request and positioning
     */
    loadGrid: function(){

        var pos = document.id(this.source).getPosition();

        // Delete our old image mosaic
        document.id('target').getChildren().each( function(el){
            el.destroy();
        } );
        document.id('target').setStyles({
            left: 0,
            top: 0
        });


        // Get the start points for our tiles
        var startx = Math.floor( this.rgn_x / this.tileSize[0] );
        var starty = Math.floor( this.rgn_y / this.tileSize[1] );

        // If our size is smaller than the display window, only get these tiles!
        var len = this.rgn_w;
        if( this.wid < this.rgn_w ) len = this.wid;
        var endx =  Math.floor( (len + this.rgn_x) / this.tileSize[0] );


        len = this.rgn_h;
        if( this.hei < this.rgn_h ) len = this.hei;
        var endy = Math.floor( (len + this.rgn_y) / this.tileSize[1] );


        // Number of tiles is dependent on view width and height
        var xtiles = Math.ceil(this.wid / this.tileSize[0]);
        var ytiles = Math.ceil(this.hei / this.tileSize[1]);




        /* Calculate the offset from the tile top left that we want to display.
         Also Center the image if our viewable image is smaller than the window
         */
        var xoffset = Math.floor(this.rgn_x % this.tileSize[0]);
        if( this.wid < this.rgn_w ) xoffset -=  (this.rgn_w - this.wid)/2;

        var yoffset = Math.floor(this.rgn_y % this.tileSize[1]);
        if( this.hei < this.rgn_h ) yoffset -= (this.rgn_h - this.hei)/2;

        var tile;
        var i, j, k, n;
        var left, top;
        k = 0;
        n = 0;


        var centerx = startx + Math.round((endx-startx)/2);
        var centery = starty + Math.round((endy-starty)/2);

        var map = new Array((endx-startx)*(endx-startx));

        // Should put this into
        var ntiles=0;
        for( j=starty; j<=endy; j++ ){
            for (i=startx;i<=endx; i++) {

                map[ntiles] = {};
                if( this.render == 'spiral' ){
                    // Calculate the distance from the centre of the image
                    map[ntiles].n = Math.abs(centery-j)* Math.abs(centery-j) + Math.abs(centerx-i)*Math.abs(centerx-i);
                }
                // Otherwise do a random rendering
                else map[ntiles].n = Math.random();

                map[ntiles].x = i;
                map[ntiles].y = j;
                ntiles++;
            }
        }

        this.nTilesLoaded = 0;
        this.nTilesToLoad = ntiles*this.images.length;

        //map.sort(function s(a,b){return a.n - b.n;});

        // djatoka mods
        map.sort(function (a,b){return a > b;});
        var first = true;
        var r = this.num_resolutions - this.res;
        var f = this.getMultiplier(r, this.tileSize[0]);
        // end djatoka mods

        for( var m=0; m<ntiles; m++ ){

            var i = map[m].x;
            var j = map[m].y;

            // djatoka mods
            var djatoka_x = i * f;
            var djatoka_y = j * f;
            if (first) {
                top_left_x = (djatoka_x + this.getMultiplier(r, xoffset-2));
                top_left_y = (djatoka_y + this.getMultiplier(r, yoffset-2));
                if (top_left_x < 0)
                    top_left_x = 0;
                if (top_left_y < 0)
                    top_left_y = 0;
                this.setOpenURL();
                first = false;
            }
            // end djatoka mods


            // Sequential index of the tile in the tif image
            //k = i + (j*xtiles);

            // Iterate over the number of layers we have
            var n;
            if (djatoka_x < this.max_width && djatoka_y < this.max_height) {
                for(n=0;n<this.images.length;n++){

                    tile = new Element('img', {
                        'class': 'layer'+n,
                        'styles': {
                            left: (i-startx)*this.tileSize[0] - xoffset,
                            top: (j-starty)*this.tileSize[1] - yoffset
                        },
                        'events': {
                            load: function(){
                                this.nTilesLoaded++;
                                this.refreshLoadBar();
                            }.bind(this),
                            error: function(){ this.src=this.src; } // Try to reload if we have an error
                        }
                    });

                    // djatoka mods
                    var src = this.server + "?url_ver=Z39.88-2004&rft_id="
                        + this.images[n].src + "&svc_id=" + this.svc_id
                        + "&svc_val_fmt=" + this.svc_val_fmt
                        + "&svc.format=image/jpeg&svc.level="
                        + this.res + "&svc.rotate=0&svc.region="
                        + djatoka_y + "," + djatoka_x + ",256,256";
                    // end djatoka mods

                    // We set the source at the end so that the 'load' function is properly fired
                    //var src = this.server+"?FIF="+this.images[n].src+"&cnt="+this.contrast+"&sds="+this.images[n].sds+"&jtl="+this.res+"," + k;
                    tile.set( 'src', src );
                    tile.inject('target');
                }
            } else
                this.nTilesLoaded++
        }

        if( this.images.length > 1 ){
            var selector = 'img.layer'+(n-1);
            $$(selector).set( 'opacity', this.opacity );
        }

    },

    // djatoka mods
    /*
     * djatoka is based of the offset value of the max resolution, so we
     * need to apply the multiplier
     */
    getMultiplier : function(r, f) {
        var m = f;
        for (i = 0; i < r; i++) {
            m = m * 2;
        }
        return m;
    },

    /*
     * Create the OpenURL for the current viewport
     */
    setOpenURL : function() {
        var w = this.rgn_w;
        if (this.wid < this.rgn_w)
            w = this.wid;
        var h = this.rgn_h;
        if (this.hei < this.rgn_h)
            h = this.hei;
        this.openUrl = this.server + "?url_ver=Z39.88-2004&rft_id="
            + this.images[0].src + "&svc_id=" + this.svc_id + "&svc_val_fmt="
            + this.svc_val_fmt
            + "&svc.format=image/jpeg&svc.level=" + this.res
            + "&svc.rotate=0&svc.region=" + top_left_y + ","
            + top_left_x + "," + h + "," + w;
    },

    /*
     * Open the OpenURL for the current viewport in a new window
     */
    openOpenURL : function() {
        window.open(this.openUrl,'Snapshot URI','toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,copyhistory=yes,resizable=yes');
    },
    // end djatoka mods

    /* Refresh function to avoid the problem of tiles not loading
     properly in Firefox/Mozilla
     */
    refresh: function(){

        var unloaded = 0;

        document.id('target').getChildren().each( function(el){
            // If our tile has not yet been loaded, give it a prod ;-)
            if( el.width == 0 || el.height == 0 ){
                el.src = el.src;
                unloaded = 1;
            }
        });

        /* If no tiles are missing, destroy our refresher timer, fade out our loading
         animation and and reset our cursor
         */
        if( unloaded == 0 ){
            $clear( this.refresher );
            this.refresher = null;
        }
    },



    /* Allow us to navigate within the image via the keyboard arrow buttons
     */
    key: function(e){
        var d = 100;
        switch( e.code ){
            case 37: // left
                this.scrollTo(-d,0);
                break;
            case 38: // up
                this.scrollTo(0,-d);
                break;
            case 39: // right
                this.scrollTo(d,0);
                break;
            case 40: // down
                this.scrollTo(0,d);
                break;
            case 107: // plus
                if(!e.control) this.zoomIn();
                break;
            case 109: // minus
                if(!e.control) this.zoomOut();
                break;
        }
    },



    /* Scroll resulting from a drag of the navigation window
     */
    scrollNavigation: function( e ) {

        var xmove = 0;
        var ymove = 0;

        var zone_size = document.id("zone").getSize();
        var zone_w = zone_size.x;
        var zone_h = zone_size.y;

        if( e.event ){
            // From a mouse click
            var pos = document.id("navwin").getPosition();
            xmove = e.event.clientX - pos.x - zone_w/2;
            ymove = e.event.clientY - pos.y - zone_h/2;
        }
        else{
            // From a drag
            xmove = e.offsetLeft;
            ymove = e.offsetTop-10;
            if( (Math.abs(xmove-this.navpos[0]) < 3) && (Math.abs(ymove-this.navpos[1]) < 3) ) return;
        }

        if( xmove > (this.min_x - zone_w) ) xmove = this.min_x - zone_w;
        if( ymove > (this.min_y - zone_h) ) ymove = this.min_y - zone_h;
        if( xmove < 0 ) xmove = 0;
        if( ymove < 0 ) ymove = 0;

        this.rgn_x = Math.round(xmove * this.wid / this.min_x);
        this.rgn_y = Math.round(ymove * this.hei / this.min_y);

        this.requestImages();
        if( e.event ) this.positionZone();
    },



    /* Scroll from a target drag event
     */
    scroll: function() {
        var xmove =  - document.id('target').offsetLeft;
        var ymove =  - document.id('target').offsetTop;
        this.scrollTo( xmove, ymove );
    },



    /* Check our scroll bounds
     */
    checkBounds: function( dx, dy ) {

        var x = this.rgn_x + dx;
        var y = this.rgn_y + dy;

        if( x > this.wid - this.rgn_w ) x = this.wid - this.rgn_w;
        if( y > this.hei - this.rgn_h ) y = this.hei - this.rgn_h;
        if( x < 0 ) x = 0;
        if( y < 0 ) y = 0;

        this.rgn_x = x;
        this.rgn_y = y;

    },


    /* Scroll to a particular position
     */
    scrollTo: function( dx, dy ) {

        if( dx || dy ){
            // To avoid unnecessary redrawing ...
            if( (Math.abs(dx) < 3) && (Math.abs(dy) < 3) ) return;
            this.checkBounds(dx,dy)
            this.requestImages();
            this.positionZone();
        }
    },



    /* Generic zoom function
     */
    zoom: function( e ) {

        var event = new Event(e);

        // For mouse scrolls
        if( event.wheel ){
            if( event.wheel > 0 ) this.zoomIn();
            else if( event.wheel < 0 ) this.zoomOut();
        }

        // For double clicks
        else if( event.shift ){
            this.zoomOut();
        }
        else this.zoomIn();

    },



    /* Zoom in by a factor of 2
     */
    zoomIn: function (){

        if( (this.wid <= (this.max_width/2)) && (this.hei <= (this.max_height/2)) ){

            this.res++;
            this.wid = this.max_width;
            this.hei = this.max_height;
            for( var i=this.res; i<this.num_resolutions; i++ ){
                this.wid = Math.floor(this.wid/2);
                this.hei = Math.floor(this.hei/2);
            }

            if( this.xfit == 1 ){
                this.rgn_x = this.wid/2 - (this.rgn_w/2);
            }
            else if( this.wid > this.rgn_w ) this.rgn_x = 2*this.rgn_x + this.rgn_w/2;

            if( this.rgn_x > this.wid ) this.rgn_x = this.wid - this.rgn_w;
            if( this.rgn_x < 0 ) this.rgn_x = 0;

            if( this.yfit == 1 ){
                this.rgn_y = this.hei/2 - (this.rgn_h/2);
            }
            else if( this.hei > this.rgn_h ) this.rgn_y = this.rgn_y*2 + this.rgn_h/2;

            if( this.rgn_y > this.hei ) this.rgn_y = this.hei - this.rgn_h;
            if( this.rgn_y < 0 ) this.rgn_y = 0;

            this.requestImages();
            this.positionZone();
            if( this.scale ) this.setScale();

        }
    },



    /* Zoom out by a factor of 2
     */
    zoomOut: function(){

        if( (this.wid > this.rgn_w) || (this.hei > this.rgn_h) ){

            this.res--;
            this.wid = this.max_width;
            this.hei = this.max_height;
            for( var i=this.res; i<this.num_resolutions; i++ ){
                this.wid = Math.floor(this.wid/2);
                this.hei = Math.floor(this.hei/2);
            }

            this.rgn_x = this.rgn_x/2 - (this.rgn_w/4);
            if( this.rgn_x + this.rgn_w > this.wid ) this.rgn_x = this.wid - this.rgn_w;
            if( this.rgn_x < 0 ){
                this.xfit=1;
                this.rgn_x = 0;
            }
            else this.xfit = 0;

            this.rgn_y = this.rgn_y/2 - (this.rgn_h/4);
            if( this.rgn_y + this.rgn_h > this.hei ) this.rgn_y = this.hei - this.rgn_h;
            if( this.rgn_y < 0 ){
                this.yfit=1;
                this.rgn_y = 0;
            }
            else this.yfit = 0;

            this.requestImages();
            this.positionZone();
            if( this.scale ) this.setScale();
        }
    },



    /* Calculate some dimensions
     */
    calculateMinSizes: function(){

        var tx = this.max_width;
        var ty = this.max_height;
        var thumb = 100;
        var thumb_axis = tx;
        var thumb_lower_bound = 1;

        var target_size = document.id(this.source).getSize();
        var winWidth = target_size.x;
        var winHeight = target_size.y;

        if( tx > ty ){
            // For panoramic images, use a large navigation window
            if( tx > 2*ty ) thumb = winWidth / 2;
            else thumb = winWidth / 4;
        }
        else {
            thumb_axis = ty;
            thumb_lower_bound = 0;
            thumb = winHeight / 4;
        }
        alert('thumb:' + thumb);


        //alert('true res:' + this.res);

        while( thumb_axis > thumb ){
            tx = parseInt(tx / 2);
            ty = parseInt(ty / 2);
            // Make sure we don't set our navigation image too small!
            if( --r == thumb_lower_bound ) break;
        }
        this.min_x = tx;
        this.min_y = ty;
        //alert(this.min_x + ', ' + this.min_y + '; ' + this.max_width + ', ' + this.max_height);

        // Determine the resolution for this image view
        tx = this.max_width;
        ty = this.max_height;
        while( tx > winWidth || ty > winHeight ){
            tx = parseInt(tx / 2);
            ty = parseInt(ty / 2);
            this.res--;
        }
        this.wid = tx;
        this.hei = ty;
        // commenting out line below so images with full res smaller than window don't appear too small on load
        //this.res--;
    },



    /* Create our main and navigation windows
     */
    createWindows: function(){

        // Get our window size - subtract some pixels to make sure the browser never
        // adds scrollbars

        var target_size = document.id(this.source).getSize();
        var winWidth = target_size.x;
        var winHeight = target_size.y;
        // debug
        // alert(winWidth + ';' + winHeight);

        // Calculate some sizes and create the navigation window
        this.calculateMinSizes();
        this.createNavigationWindow();

        // Create our main window target div, add our events and inject inside the frame
        var el = new Element('div', {
            'id': 'target',
            morph: { transition: Fx.Transitions.Quad.easeInOut,
                onComplete: this.requestImages.bind(this)
            }
        } );
        new TargetDrag( el, {onComplete: this.scroll.bind(this)} );


        el.inject( this.source );
        el.addEvent( 'mousewheel', this.zoom.bind(this) );
        el.addEvent( 'dblclick', this.zoom.bind(this) );
        if( this.targetclick ) el.addEvent( 'click', this.targetclick.bindWithEvent(this) );

        this.rgn_w = winWidth;
        this.rgn_h = winHeight;

        this.reCenter();

        window.addEvent( 'resize', function(){ window.location=window.location; } );
        document.addEvent( 'keydown', this.key.bindWithEvent(this) );

        // Add our logo and a tooltip explaining how to use the viewer
        // new Element( 'a', {href: 'http://iipimage.sourceforge.net', id:'logo'} ).inject(this.source);
        // use custom viewerHelp.png image as help/info icon
        // hide for now, as tips don't show in jQuery modal
        // new Element('img', {src: '../assets/djatoka_viewer/viewerHelp.png', id: 'info'} ).inject('navbuttons');
        /*
         // Fix IE7 PNG transparency problem
         if( Browser.ie ){
         $('info').setStyle( 'filter', 'progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true,src="images/djatoka.32x32.png",sizingMethod=scale)' );
         }
         */
        // hide tips  for now as they don't work in jQuery modal
        /*
         new Tips( '#info, #toolbar', {
         className: 'tip', // We need this to force the tip in front of nav window
         // We have to first set opacity to zero to fix a bug in mootools 1.2
         // where the tip appears without any fade in the first time it is loaded
         onShow: function(t){ t.setStyle('opacity',0); t.fade(0.9); },
         onHide: function(t){ t.fade(0); }
         });
         $('info').store('tip:text', 'To navigate within an image:<ul><li>drag image within main window or</li><li>drag highlighted zone within the navigation thumbnail</li><li>click an area within the navigation thumbnail</li></ul>To zoom in:<ul><li>double click with the mouse or</li><li>use the mouse scroll wheel or</li><li>or simply press the "+" key</li></ul>To zoom out:<ul><li>shift double click with the mouse or</li><li>use the mouse wheel or</li><li>press the "-" key</li></ul>To move the navigation thumbnail:<ul><li>grab and drag the top of the navigation thumbnail</li></ul>To show / hide navigation buttons:<ul><li>double click the top of the navigation thumbnail</li></ul>');
         */

        // Add some info
        if( this.credit ){
            new Element( 'div', {id: 'credit', html: this.credit} ).inject(this.source);
        }

        // Add a scale if we have one
        if( this.scale ){
            new Element( 'div', {id: 'scale'} ).inject(this.source);
        }


        // Zoom in by the desired level
        for(var i=0;i<this.initialZoom;i++) this.zoomIn();
        this.zoomOut();
        this.requestImages();
        this.positionZone();

    },



    /* Create our navigation window
     */
    createNavigationWindow: function() {

        var navcontainer = new Element( 'div', {
            id: 'navcontainer',
            styles: {
                width: this.min_x /*,
                 height: 10 */
            }
        });

        var toolbar = new Element( 'div', {
            id: 'toolbar',
            styles: {
                width: this.min_x
            }//,
            /* removing this functionality, as tip w/instrux won't show in jQuery modal
             events: {
             dblclick:
             function(){
             $('navbuttons').slide('toggle');
             // hack to deal with weird error where 2nd dblclick does not restore navbuttons
             $('navbuttons').style.position = "relative";
             }
             } */
        });
        // removing tip as it won't show in jQuery modal
        // toolbar.store( 'tip:text', '* Drag to move<br/>* Double Click to show/hide navigation buttons' );
        toolbar.inject( navcontainer );

        // Create our navigation div and inject it inside our frame
        var navwin = new Element( 'div', {
            id: 'navwin',
            styles: {
                width: this.min_x,
                height: this.min_y
            }
        });
        navwin.inject( navcontainer );

        // Create our navigation image and inject inside the div we just created
        // djatoka mods
        var navimage = new Element('img', {
            id :'navigation',
            src :this.server + "?url_ver=Z39.88-2004&rft_id="
                + this.images[0].src + "&svc_id=" + this.svc_id
                + "&svc_val_fmt=" + this.svc_val_fmt
                + "&svc.format=image/jpeg&svc.scale=" + this.min_x + "," + this.min_y
            // end djatoka mods

            //var navimage = new Element( 'img', {
            //id: 'navigation',
            //src: this.server + '?FIF=' + this.images[0].src + '&SDS=' + this.images[0].sds + '&CNT=1.0' +
            //    '&WID=' + this.min_x + '&QLT=99&CVT=jpeg'

        });

        navimage.inject( navwin );

        // Create our navigation zone and inject inside the navigation div
        var zone = new Element( 'div', {
            id: 'zone',
            styles: {
                width: this.min_x/2,
                height: this.min_y/2,
                opacity: 0.4
            },
            morph: {
                duration: 500,
                transition: Fx.Transitions.Quad.easeInOut
            }
        });
        zone.inject( navwin );


        // Create our progress bar
        var loadBarContainer = new Element('div', {
            id: 'loadBarContainer',
            html: '<div id="loadBar"></div>',
            styles: {
                width: this.min_x - 2
            },
            tween: {
                duration: 1000,
                transition: Fx.Transitions.Sine.easeOut,
                link: 'cancel'
            }
        });



        // Create our nav buttons
        var navbuttons = new Element('div', {
            id: 'navbuttons'
        });

        var button_imgs = new Array('zoomIn','zoomOut','reset');
        for (var i = 0; i < button_imgs.length; i++) {
            var button_img = new Element('img',{
                id:button_imgs[i],
                src:'../assets/djatoka_viewer/' + button_imgs[i] + '.png'}
            );
            button_img.inject(navbuttons);
        }

        // inject navbuttons into container div rather than navcontainer
        navbuttons.inject( this.source );

        // navbuttons.set('slide', {duration: 300, transition: Fx.Transitions.Quad.easeInOut, mode:'horizontal'});

        loadBarContainer.inject(navcontainer);
        navcontainer.inject( this.source );

        // Hide our navigation buttons if requested
        // if( this.showNavButtons == false ) navbuttons.slide('out');

        // Needed as IE doesn't take CSS opacity into account
        if( Browser.ie ){
            $$('div#navbuttons, div#navbuttons img').setStyle( 'opacity', 0.75 );
        }

        navcontainer.makeDraggable( {container:this.source, handle:toolbar} );

        document.id('zoomIn').addEvent( 'click', this.zoomIn.bindWithEvent(this) );
        document.id('zoomOut').addEvent( 'click', this.zoomOut.bindWithEvent(this) );
        // need to fix reset function in JQuery modal context
        document.id('reset').addEvent( 'click', function(){ document.id('img_viewer').empty(); this.createWindows();}.bind(this)  );
        /* not using need these
         $('snapshot').addEvent('click', function() { this.openOpenURL();}.bind(this));
         $('shiftLeft').addEvent( 'click', function(){ this.scrollTo(-this.rgn_w/3,0); }.bind(this) );
         $('shiftUp').addEvent( 'click', function(){ this.scrollTo(0,-this.rgn_h/3); }.bind(this) );
         $('shiftDown').addEvent( 'click', function(){ this.scrollTo(0,this.rgn_h/3); }.bind(this) );
         $('shiftRight').addEvent( 'click', function(){ this.scrollTo(this.rgn_w/3,0); }.bind(this) );
         */

        document.id('zone').makeDraggable({
            container: 'navwin',
            // Take a note of the starting coords of our drag zone
            onStart: function() {
                this.navpos = [document.id('zone').offsetLeft, document.id('zone').offsetTop-10];
            }.bind(this),
            onComplete: this.scrollNavigation.bindWithEvent(this)
        });

        // Add our events
        document.id('navigation').addEvent( 'click', this.scrollNavigation.bindWithEvent(this) );
        document.id('navigation').addEvent( 'mousewheel', this.zoom.bindWithEvent(this) );
        document.id('zone').addEvent( 'mousewheel', this.zoom.bindWithEvent(this) );
        document.id('zone').addEvent( 'dblclick', this.zoom.bindWithEvent(this) );

    },



    refreshLoadBar: function() {

        // Update the loaded tiles number, grow the loadbar size
        var w = (this.nTilesLoaded / this.nTilesToLoad) * this.min_x;
        document.id('loadBar').setStyle( 'width', w );

        // Display the % in the progress bar
        document.id('loadBar').set( 'html', 'loading&nbsp;:&nbsp;'+Math.round(this.nTilesLoaded/this.nTilesToLoad*100) + '%' );

        if( document.id('loadBarContainer').style.opacity != 0.85 ){
            document.id('loadBarContainer').setStyle( 'opacity', 0.85 );
        }

        // If we're done with loading, fade out the load bar
        if( this.nTilesLoaded == this.nTilesToLoad ){
            // Fade out our progress bar and loading animation in a chain
            document.id('target').setStyle( 'cursor', 'default' );
            document.id('loadBarContainer').fade('out');
        }

    },



    /* Set a scale on our image - change the units if necessary
     */
    setScale: function() {
        var pixels = 1000 * this.scale * this.wid / this.max_width; // x1000 because we want per m
        var label = '1m';
        if( pixels > 1000 ){
            pixels = pixels/100;
            label = '1cm';
        }
        else if( pixels > 100 ){
            pixels = pixels/10;
            label = '10cm';
        }

        document.id('scale').set({
            styles: {width: pixels},
            html: label
        });
    },



    /* Use a AJAX request to get the image size, tile size and number of resolutions from the server
     */
    //load: function(){

    //new Request(
    //{
    //method: 'get',
    //url: this.server,
    //onComplete: function(transport){
    //    var response = transport || alert( "No response from server " + this.server );
    //    var tmp = response.split( "Max-size" );
    //    if(!tmp[1]) alert( "Unexpected response from server " + this.server );
    //    var size = tmp[1].split(" ");
    //    this.max_width = parseInt( size[0].substring(1,size[0].length) );
    //    this.max_height = parseInt( size[1] );
    //    tmp = response.split( "Tile-size" );
    //    size = tmp[1].split(" ");
    //    this.tileSize[0] = parseInt( size[0].substring(1,size[0].length) );
    //    this.tileSize[1] = parseInt( size[1] );
    //    tmp = response.split( "Resolution-number" );
    //    this.num_resolutions = parseInt( tmp[1].substring(1,tmp[1].length) );
    //    this.res = this.num_resolutions;
    //    this.createWindows();
    //    }.bind(this),
    //onFailure: function(){ alert('Unable to get image and tile sizes from server!'); }
    //  } ).send( "FIF=" + this.images[0].src + "&obj=IIP,1.0&obj=Max-size&obj=Tile-size&obj=Resolution-number" );
    //},
    /*
     // djatoka mod
     load : function() {
     new Request( {
     method :'get',
     url :this.server,
     onComplete : function(transport) {
     // var response = transport || alert("No response from server " + this.server);
     // var p = eval("(" + response + ")");
     // var tmp = 4; // p.levels;
     // this.max_width = 927; // parseInt(p.width);
     // this.max_height = 1200; // parseInt(p.height);
     // this.tileSize[0] = 256;
     // this.tileSize[1] = 256;
     // this.num_resolutions = 4 // parseInt(p.levels);
     // this.res = this.num_resolutions;
     this.createWindows();
     }.bind(this)//,
     // onFailure : function() {
     // alert('Unable to get image and tile sizes from server!');
     // }
     }).send("url_ver=Z39.88-2004&rft_id=" + this.images[0].src + "&svc_id=info:lanl-repo/svc/getMetadata");
     },
     // end djatoka mod
     */

    // bpl mod
    // don't need AJAX call as in above since we are getting metadata using Rails Djatoka call
    load: function() {
        this.createWindows();
    },

    /* Recenter the image view
     */
    reCenter: function(){
        this.rgn_x = (this.wid-this.rgn_w)/2;
        this.rgn_y = (this.hei-this.rgn_h)/2;
    },



    /* Reposition the navigation rectangle on the overview image
     */
    positionZone: function(){

        var pleft = (this.rgn_x/this.wid) * (this.min_x);
        if( pleft > this.min_x ) pleft = this.min_x;
        if( pleft < 0 ) pleft = 0;

        var ptop = (this.rgn_y/this.hei) * (this.min_y);
        if( ptop > this.min_y ) ptop = this.min_y;
        if( ptop < 0 ) ptop = 0;

        var width = (this.rgn_w/this.wid) * (this.min_x);
        if( pleft+width > this.min_x ) width = this.min_x - pleft;

        var height = (this.rgn_h/this.hei) * (this.min_y);
        if( height+ptop > this.min_y ) height = this.min_y - ptop;

        if( width < this.min_x ) this.xfit = 0;
        else this.xfit = 1;
        if( height < this.min_y ) this.yfit = 0;
        else this.yfit = 1;

        var border = document.id('zone').offsetHeight - document.id('zone').clientHeight;

        // Move the zone to the new size and position
        document.id('zone').morph({
            left: pleft,
            top: ptop + 10, // 10px for the toolbar
            width: width - border/2,
            height: height - border/2
        });

    }


});

