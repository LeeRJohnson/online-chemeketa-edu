/*  -----------------------------------------------------------

COL UI - Version 1.3.2 [Patch]

Update: 20090330

Authors: Lee R Johnson - ljohns10@chemeketa.edu

Created specifically for http://online.chemeketa.edu to 
add advanced client side UI.

Adds: newsBar (req: 
Moved: some common functions to COL Utilites

Patch: the Distance Ed Load Hang by removing it.


Requires jQuery 1.3 & jQuery UI 1.7, Google AJAX API, COL Utilites

-----------------------------------------------------------  */
var colui = {
    onlineProxy: 'http://online.chemeketa.edu/web-services/req-proxy.aspx?url=',
    header: 'div.hd',

    uiConfig: {
        defaults: {
            header: "div.hd",
            event: 'click',
            autoHeight: false,
            alwaysOpen: false,
            fillSpace: true
        },
        autoCycle: {
            header: 'div.hd',
            event: 'mouseover',
            alwaysOpen: true,
            fillSpace: false
        },
        dialog: {
            width: '70em',
            maxWidth: '100%',
            height: 'auto',
            dialogClass: 'container',
            position: 'top',
            bgiframe: false,
            modal: true,
            show: 'fold',
            hide: 'fold',
            resizable: true,
            dragable: true,
            buttons: {
                'Close': function() {
                    $('.ui-dialog').hide()
                    .find('.ui-dialog-titlebar-close').click();
                }
            }
        }
    },
    swfConfig:{
        video:{
            player: 'http://online.chemeketa.edu/media/swf/player.swf',
            vars: {},
            params: {loop:'true', allowfullscreen: 'true', allowscriptaccess:'always'},
            attrs: {}
        }
    },
    //templates
    templates: {
        jLoading: '<div class="ui-nav-panel ui-state-load"><p style="width:100%; display:block; text-align:center;"><img style="margin:auto;" alt="Loading..." src="http://online.chemeketa.edu/media/loaders/ajax-loader.h800000.x31.gif" /></p></div>'
    },
    //Widgets                
    autoCycle: function(e, speed) {
        var config = colui.uiConfig.autoCycle;
        clearTimeout(timer);
        var timer = setTimeout(function() {
            var rotate; //the next item to trigger
            if ($(e.target).find('>.selected').is(':last-child')) {
                rotate = $(e.target).find(':first-child');
            } else {
                rotate = $(e.target).find('>.selected').next();
            }
            $(rotate).find(colui.uiConfig.autoCycle.header)
                         .trigger(colui.uiConfig.autoCycle.event);
        },
            speed
        );
    },
    rotator: {
        playing: false,
        toolbar: function(settings) {
            function createButton(config) {
                var btn = $('<a />')
                    .attr('href', '#')
                    .attr('rel', config.label)
                    .attr('title', config.label)
                    .append($('<span />')
                              .addClass('ui-icon ui-icon-' + config.icon)
                              .html(config.label))
                    .button()
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
            var bar = $('<ul />')
                        .addClass('ui-rotator-nav ui-tabs-nav ui-helper-reset ui-helper-clearfix')
                        .append(prev)
                        .append(play)
                        .append(pause)
                        .append(next);
            $(bar).find('a[rel]').wrap('<li></li>');
            return bar;
        },
        defaults: {
            delay: 2000,
            autoStart: true,
            showTabs: true,
            showControls: true,
            id: "ui-rotator"
        },
        init: function(tabs, settings) {
            $root = $(tabs);
            var config = jQuery.extend({}, colui.rotator.defaults, settings);
            $root
                .data('rotator', config)

            //Add Event Handlers
                .bind('rotatorplay', function(event, ui) {
                    colui.rotator.play(event.target, config.delay);
                    return false;
                })
                .bind('rotatorpause', function(event, ui) {
                    colui.rotator.pause(event.target);
                })
                .bind('rotatornext', function(event, ui) {
                    colui.rotator.next(event.target);
                })
                .bind('rotatorprev', function(event, ui) {
                    colui.rotator.prev(event.target);
                })

            //init control events
                .append(colui.rotator.toolbar({})).andSelf()
                .find('a[rel=prev]').bind('click', function(e) {
                    $root.triggerHandler('rotatorprev');
                    return false;
                }).click(function() { return false; }).andSelf()
                .find('a[rel=next]').bind('click', function(e) {
                    $root.triggerHandler('rotatornext');
                }).andSelf()
                .find('a[rel=play]').bind('click', function(e) {
                    $root.triggerHandler('rotatorplay');
                }).andSelf()
                .find('a[rel=pause]').bind('click', function(e) {
                    $root.triggerHandler('rotatorpause');
                }).andSelf()
                ;
            //auto play
            if (config.autoStart) { $root.trigger('rotatorplay', config.delay); }

        },
        play: function(target, delay) {
            var $root = $(target);
            $root.tabs('rotate', delay).addClass('ui-state-playing');
        },
        pause: function(target) {
            var $root = $(target);
            $root.tabs('rotate', 0).removeClass('ui-state-playing');
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
    },
    colNewsLoad: function() {
        $("#col-news").each(function(i) {
            // init control
            var feedControl = new google.feeds.FeedControl();
            //load data models
            var data_src = $(this).find("a[rel*='feed'][href]").attr("href");
            var data_name = $(this).find(".hd:header").text();
            feedControl.addFeed(data_src, data_name);
            //render view
            feedControl.draw($(this).find('.bd')[0], { drawMode: google.feeds.FeedControl.DRAW_MODE_LINEAR });

        });
    },
    newsBar: function(ctrlID) {
        //COL News Bar
        //1. Collect news bar feeds:
        var newsBarfeeds = $('#' + ctrlID).find('ul.feeds>li a[rel*=feed]').map(function(i) {
            //Return title and url pairs
            var feed = { title: $(this).attr('title'), url: $(this).attr('href') };
            return feed;
        });

        //2. Set Options
        var newBarCfg = {
            horizontal: true
        };

        //3. Render Control
        if (GFdynamicFeedControl) {
            new GFdynamicFeedControl(newsBarfeeds, ctrlID, newBarCfg);
        } else {
            $.getScript('http://www.google.com/uds/solutions/dynamicfeed/gfdynamicfeedcontrol.js', function() { });
            new GFdynamicFeedControl(newsBarfeeds, ctrlID, newBarCfg);
        }
    },
    navbarLoad: function(selector) {
        $('#navbar').append($('div class="marquee"></div>'));
        $(selector || '#navbar>.linkbar>li').not('.dir')
            .click(function(e) {
                //disable non loaded links by jumping to link
                if ($(this).data('src').contents().length < 1) {
                    $(this).trigger('dblclick');
                }
                else {
                    e.preventDefault();

                    // Open only if not previously selected
                    if ($(this).data('src').hasClass("selected")) {
                        $('#navbar div.navpane.selected').slideUp(500).toggleClass('selected');
                        window.location.hash = '#';
                    }
                    else {
                        //Keep Screen at Top
                        $('body').attr('id', $(this).find('a').text().replace(/&/g, 'and').replace(/</g, '-').replace(/>/g, '-').replace(/\s/g, '-'))
                        window.location.hash = $('body').attr('id');
                        $(window).scrollTop(0);
                        //hide open so its no in the way of new selected
                        $('#navbar div.navpane.selected').hide().toggleClass('selected');
                        //use the height of the element for equal speed appearance
                        $(this).data('src').slideDown($(this).data('src').height() * 2).toggleClass('selected');
                    }
                }
            })
            .keyup(function(e) {
                //On Focus load
                $(this).trigger('mouseover');
            })
            .dblclick(function(e) { //open full page
                window.location = $(this).data('href');
            })
            .css({ 'cursor': 'pointer' })
            .hover(function() {
                $(this).addClass('hover')
            }, function() {
                $(this).removeClass('hover')
            })
            .one("mouseover", function(i) {
                if (!$(this).data('href')) {
                    $(this).data('href', $(this).find('a').attr("href"));
                }
                if (!$(this).data('src')) {
                    $(this).data('src', $(colui.templates.jLoading).addClass('container top'));
                    $(this).find('a[href^="/"]').each(function(i) {
                        $(this).parent("li").data('src').data('nav', $(this).parent("li"))
                            .load($(this).attr("href") + ' #content>div.bd', '', function(txt, status, xhr) {
                                if ($(this).html() != '') {
                                    $(this).addClass('navpane')
                                            .data('nav')
                                                .addClass('navtog')
                                                .append($('<span />')
                                                    .addClass('ui-icon ui-icon-' + 'triangle-1-s')
                                                    .html('v=v'));
                                }
                            });
                    });
                    $(this).find('a[href^="http://"]').each(function(i) {
                        $(this).parent("li").data('src').data('nav', $(this).parent("li"))
                        
                        //Had the remove #crslist, from the load selection it started craping out.
                        //It was crap code anyway this needs some work.                      
                            .load(colui.onlineProxy + $(this).attr("href") + ' #notid', '', function() {
                                if ($(this).html() != '') {
                                    $(this).addClass('navpane')
                                                    .data('nav')
                                                        .addClass('navtog')
                                                        .append($('<span />')
                                                            .addClass('ui-icon ui-icon-' + 'triangle-1-s')
                                                            .html('v=v'));
                                }
                                
                                //Make URL Absolute //This didn't seem to work on some comps with IE
                                $(this).find('a[href^="/"]').each(function(i) {
                                    $(this).attr("href", 'http://learning.chemeketa.edu' + $(this).attr("href"));
                                });

                                //Restructure Course List
                                var colLength = $(this).find('#crslist td>a').length / 4; //4 cols
                                while ($(this).find('#crslist td>a').length > 0) {
                                    $(this).append($('<ul class="span-5 append-0"></ul>')
                                        .append($(this).find('#crslist td>a:lt(' + colLength + ')')
                                    ))
                                    .find('ul>a').attr('rel', 'course').wrap($('<li></li>'));
                                }
                                $(this).find('#crslist').remove();
                                $(this).find('ul:first').addClass('prepend-1');

                                //Restructure Schedule Choice Form
                                var mappedItems = $('#notid select.textform>option:gt(1)').map(function(index) {
                                    var replacement = $("<a>").data('h', 0).data('tid', $(this).attr('value'))
                                    .attr('id', 'to-sched-' + colUtil.toTermCode($(this).attr('value')))
                                    .attr('href', 'http://learning.chemeketa.edu/dsp_class_info.cfm?h=0&tid=' + $(this).attr('value'))
                                    .addClass('src')
                                    .addClass(colUtil.toTermLabel($(this).attr('value')))
                                    //.one('mouseover', function(e) {                                        $('#main-qee').append($('<div id="sched-' + colUtil.toTermCode($(e.target).data('tid')) + '"><div>').load(colui.onlineProxy + $(this).attr('href') + ' table'));                                  })
                                    .text($(this).text()).get(0);
                                    if ($(this).is(":selected")) {
                                        $(replacement).addClass('current');
                                    }
                                    return replacement;

                                });
                                $(this).remove('#termform');
                                //only add them to navpane parent of the form
                                $(this).find('#notid').parent().append(mappedItems);
                                colui.scheduleLoad($(mappedItems).wrap('<div class="hd span-6 last"><h2></h2></div>'));
                                $(this).find('#notid').hide();
                                if ($(this).html() != '') {
                                    $(this).addClass('navpane').data('nav').addClass('navdrop');
                                }
                            });
                    });
                    $(this).find('a').attr("title", 'Double click to go to ' + $(this).find('a').text());
                    $(this).data('src')
                    .toggleClass('loaded')
                    .addClass($(this).find('a').text().replace(/&/g, 'and').replace(/</g, '-').replace(/>/g, '-').replace(/\s/g, '-'))
                    .appendTo('#navbar').hide();

                }
            })
            .each(function() {
                $(this).addClass($(this).find('a').text().replace(/&/g, 'and').replace(/</g, '-').replace(/>/g, '-').replace(/\s/g, '-'));
                if ($(this).hasClass(window.location.hash.replace('#', ''))) {
                    $(this).mouseover();
                    $(this).click();
                }
            });
    },
    scheduleLoad: function(selector) {
        $(selector || '.course-schedules a[href*="tid="]')
            .one("mouseover", function(i) {
                var id = 'sched-' + colUtil.toTermCode($(this).data('tid'));
                $(this).attr('rel', id);
            })
    }

};
//jQuery Plugins Using COL UI
jQuery.fn.autoCycle = function(speed) {
    return this.each(function(i) {
        $(this).bind('accordionchange', function(event, ui) {
            colui.autoCycle(event, speed);
        })
        .trigger('accordionchange');
    });
};
jQuery.fn.button = function() {
    return this.each(function(i) {
        $(this)
            .addClass('ui-state-default')
            .hover(function(e) { $(this).toggleClass('ui-state-hover'); $(this).toggleClass('ui-state-default'); },
                  function(e) { $(this).toggleClass('ui-state-hover'); $(this).toggleClass('ui-state-default'); })
            .focus(function(e) { $(this).toggleClass('ui-state-focus'); $(this).toggleClass('ui-state-default'); })
            .blur(function(e) { $(this).toggleClass('ui-state-focus'); $(this).toggleClass('ui-state-default'); })
        //Pressed
            .bind('pressed', function(e) { $(this).toggleClass('ui-state-active'); $(this).toggleClass('ui-state-default'); })
            .click(function(e) { $(this).trigger('pressedx'); })
        //After a full button press of the enter key do we act
            .keyup(function(e) {
                switch (e.keyCode) {
                    case 13: //The Enter Key
                        $(this).trigger('pressedx');
                        break;
                    default:
                        //I only want to change enter key event
                        //and not mess up other keys
                        //so we don't do anyting here
                        break;
                }
            })
            ;
    });
};
jQuery.fn.rotator = function(settings) {
    return this.each(function(i) {
        colui.rotator.init(this, settings)
    });
};