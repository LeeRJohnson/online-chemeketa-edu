/* Author:
 Lee R Johnson

 Website Support Specialist
 Chemeketa Community College
 Distance Education and Academic Technology

 503.589.7840    |    lee.johnson@chemeketa.edu
 */
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
};
$(function() {
    //Setup Access Nav
    $.easy.showhide();
    $.easy.jump();
    $('#access-banner a[href=#content]').live('click', function() {
        $('.menu-pane .selected').hide().toggleClass('selected');
        $('#master-banner').slideToggle();

    });
    function bannerNavUI(event) {
        event.preventDefault();
        var hashTarget = $(this).attr('href');
        //  1. tab actions
        $(this).toggleClass('selected');
        //  2. menu-pane actions
        $('.menu-pane .selected').slideUp("slow", function () {
            $(this).toggleClass('selected');
        });
        $(hashTarget + ':not(.selected)').slideDown("slow").toggleClass('selected');
    }

    //Setup Banner Nav
    //$.easy.navigation("#banner-nav li");
    $('a.menu-tab').live('click', function(e) {
        e.preventDefault();
        var hashTarget = $(this).attr('href');
        //  1. tab actions
        $(this).toggleClass('selected');
        //  2. menu-pane actions
        $('.menu-pane .selected').slideUp("slow", function () {
            $(this).toggleClass('selected');
        });
        $(hashTarget + ':not(.selected)').slideDown("slow").toggleClass('selected');
    });
    //Search Nav Util

    var customSearchControl = null;

    function executeQuery() {
        var textNode = document.getElementById('input_box');
        if (textNode.value == '') {
            customSearchControl.clearAllResults();
        } else {
            customSearchControl.execute(textNode.value)
        }
    }


    $('#cse-search-box').live('submit', function() {
        
        $(hashTarget + ':not(.selected)').slideDown("slow").toggleClass('selected');
        executeQuery();
    });
$('#course-descriptions').append("<div />").load($('#subject-index').attr('href'));
    $('#crslist').jcarousel({
        // Configuration goes here
        scroll: 3,
        visible: 5,
        easing: 'linear',
        wrap: 'circular'
    });//end of jcarousel function
    $('a.subject').live('click', function(e) {
        e.preventDefault();
        var proxy = 'web-services/req-proxy.aspx?url=';
        var dataSrc = $(this).attr('href');
        var hashTarget = "#content table";
        var loadUrl = proxy + dataSrc + ' ' + hashTarget;
        //  1. tab actions
        $(this).toggleClass('selected');
        
        $()
    });

    $.easy.tooltip();
    $.easy.popup({
        closeText:'Close',
        opacity:0.1
    });
    $.easy.external();
    $.easy.forms();
    //Setup Spotlight
    $.easy.rotate();
    $.easy.cycle();
    $('#slideshow').tabs().rotator();



});


















