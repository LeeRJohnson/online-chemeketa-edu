/*  -----------------------------------------------------------

COL UI - Version 2 (Development)

Update: 20011-08-10

Authors: Lee R Johnson - ljohns10@chemeketa.edu

Created specifically for http://online.chemeketa.edu to 
add advanced client side UI.

adds rotator class and plugin for jQuery Tabs

Requires jQuery 1.3, Google AJAX API, COL Utilites

-----------------------------------------------------------  */
var colui = {
    rotator: {
        playing: false,
        toolbar: function(settings) {
            function createButton(config) {
                var btn = $('<a />').attr('href', '#').attr('rel', config.label).attr('title', config.label).append($('<span />').addClass('ui-icon ui-icon-' + config.icon).html(config.label)).button()
                return btn;
            }
            var config = {
                label: 'next',
                icon: 'seek-next'
            };
            var next = createButton(config);
            config.label = 'prev';
            config.icon = 'seek-prev';
            var prev = createButton(config);
            config.label = 'pause';
            config.icon = 'pause';
            var pause = createButton(config);
            config.label = 'play';
            config.icon = 'play';
            var play = createButton(config);
            var bar = $('<ul />').addClass('ui-rotator-nav ui-tabs-nav ui-helper-reset ui-helper-clearfix').append(prev).append(play).append(pause).append(next);
            $(bar).find('a[rel]').wrap('<li></li>');
            return bar;
        },
        defaults: {
            delay: 6000,
            autoStart: true,
            showTabs: true,
            showControls: true,
            id: "ui-rotator"
        },
        init: function(tabs, settings) {
            $root = $(tabs);
            var config = jQuery.extend({}, colui.rotator.defaults, settings);
            $root.data('rotator', config).addClass(config.id)

            //Add Event Handlers
            .bind('rotatorplay', function(event, ui) {
                colui.rotator.play(event.target, config.delay);
                return false;
            }).bind('rotatorpause', function(event, ui) {
                colui.rotator.pause(event.target);
            }).bind('rotatornext', function(event, ui) {
                colui.rotator.next(event.target);
            }).bind('rotatorprev', function(event, ui) {
                colui.rotator.prev(event.target);
            })

            //init control events
            .append(colui.rotator.toolbar({})).andSelf().find('a[rel=prev]').bind('click', function(e) {
                $root.triggerHandler('rotatorprev');
                return false;
            }).click(function() {
                return false;
            }).andSelf().find('a[rel=next]').bind('click', function(e) {
                $root.triggerHandler('rotatornext');
            }).andSelf().find('a[rel=play]').bind('click', function(e) {
                $root.triggerHandler('rotatorplay');
            }).andSelf().find('a[rel=pause]').bind('click', function(e) {
                $root.triggerHandler('rotatorpause');
            }).andSelf();
            //auto play
            if (config.autoStart) {
                $root.trigger('rotatorplay', config.delay);
            }

        },
        play: function(target, delay) {
            var $root = $(target);
            $root.tabs('rotate', delay).removeClass('ui-state-paused').addClass('ui-state-playing');
        },
        pause: function(target) {
            var $root = $(target);
            $root.tabs('rotate', 0).removeClass('ui-state-playing').addClass('ui-state-paused');
        },
        prev: function(target) {
            var $root = $(target);
            var i = colUtil.loopToIndex($root.tabs('option', 'selected'), -1, $root.tabs('length'));
            $root.tabs('option', 'selected', i);
        },
        next: function(target) {
            var $root = $(target);
            var i = colUtil.loopToIndex($root.tabs('option', 'selected'), 1, $root.tabs('length'));
            $root.tabs('option', 'selected', i);
        }
    }
}
var colUtil = {


    /**
     * Find the next or prev index number:
     * @param {int} from The starting index
     * @param {int} by   A positive for next or negative for prev
     * @param {int} of   a number of items
     * @returns a int indicating the next index
     */
    loopToIndex: function(from, by, of) {
        var i = from + by;
        i = (i > from) ? (i % of) //make zero next after last
        : ((i < 0) ? i + of : i); //takes negitive out of end
        return i;
    }

}
jQuery.fn.rotator = function(settings) {
    return this.each(function(i) {
        colui.rotator.init(this, settings)
    });
};;