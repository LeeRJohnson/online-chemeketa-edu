/*  -----------------------------------------------------------

COL UI - Version 0.1 (Development)

Update: 20090215

Authors: Lee R Johnson - ljohns10@chemeketa.edu

Created specifically for http://online.chemeketa.edu to 
add advanced client side UI.

Requires jQuery 1.3 and Google AJAX API

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
            event: 'auto',
            alwaysOpen: true,
            fillSpace: false
        }
    },
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
    navbarLoad: function(selector) {
        $(selector)
            .click(function(e) {

                if ($(this).data('src').contents().length < 1) {
                    $(this).trigger('dblclick');
                }
                else {
                    e.preventDefault();

                    // Open only if not previously selected
                    if ($(this).data('src').hasClass("selected")) {
                        $('#navbar>div.navpane.selected').slideUp(500).toggleClass('selected');
                        window.location.hash = '#';
                    }
                    else {
                        //Keep Screen at Top
                        $('body').attr('id', $(this).find('a').text().replace(/&/g, 'and').replace(/</g, '-').replace(/>/g, '-').replace(/\s/g, '-'))
                        window.location.hash = $('body').attr('id');
                        $(window).scrollTop(0);
                        //hide open so its no in the way of new selected
                        $('#navbar>div.navpane.selected').hide().toggleClass('selected');
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
                    $(this).data('src', $('<div class="navpane span-24 last"><p style="width:100%; display:block; text-align:center;" class="highlight">Loading...</p></div>'));
                    $(this).find('a[href^="/"]').each(function(i) {
                        $(this).parent("li").data('src')
                            .load($(this).attr("href") + ' #content>div.bd');
                    });
                    $(this).find('a[href^="http://"]').each(function(i) {
                        $(this).parent("li").data('src')
                            .load(colui.onlineProxy + $(this).attr("href") + ' #crslist, #notid', '', function() {
                                //Make URL Absolute
                                $(this).find('a[href^="/"]').each(function(i) {
                                    $(this).attr("href", 'http://learning.chemeketa.edu' + $(this).attr("href"));
                                });

                                //Restructure Course List
                                var colLength = $(this).find('#crslist td>a').length / 4; //4 cols
                                while ($(this).find('#crslist td>a').length > 0) {
                                    $(this).append($('<ul class="span-5 append-0"></ul>')
                                        .append($(this).find('#crslist td>a:lt(' + colLength + ')')
                                    ))
                                    .find('ul>a').wrap($('<li></li>'));
                                }
                                $(this).find('#crslist').remove();
                                $(this).find('ul:first').addClass('prepend-1');

                                //Restructure Schedule Choice Form
                                var mappedItems = $('#termform select.textform>option:gt(1)').map(function(index) {
                                    var replacement = $("<a>").attr('href', 'http://learning.chemeketa.edu/dsp_class_info.cfm?h=0&tid='
                                                                + $(this).attr('value'))
                                                              .addClass('src')

                                                              .text($(this).text()).get(0);
                                    switch ($(this).attr('value') % 4) {
                                        case 0:
                                            $(replacement).addClass('spring');
                                            break;
                                        case 1:
                                            $(replacement).addClass('summer');
                                            break;
                                        case 2:
                                            $(replacement).addClass('fall');
                                            break;
                                        case 3:
                                            $(replacement).addClass('winter');
                                            break;
                                        default:
                                            break;
                                    }
                                    if ($(this).is(":selected")) {
                                        $(replacement).addClass('current');
                                    }
                                    return replacement;
                                });
                                //only add them to navpane parent of the form
                                $(this).find('#notid').parent().append(mappedItems);
                                $(mappedItems).wrap('<div class="hd span-6 last"><h2></h2></div>');

                                $(this).find('#notid').hide();

                            });
                    });

                    $(this).find('a').attr("title", 'Double click to go to ' + $(this).find('a').text());
                    $(this).data('src')
                        .toggleClass('loaded')
                        .attr('id', $(this).find('a').text().replace(/&/g, 'and').replace(/</g, '-').replace(/>/g, '-').replace(/\s/g, '-'))
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
    }
};
jQuery.fn.autoCycle = function(speed) {
    return this.each(function(i) {
        $(this).bind('accordionchange', function(event, ui) {
            colui.autoCycle(event, speed);
        })
        .trigger('accordionchange');
    });
};