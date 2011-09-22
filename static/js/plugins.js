
// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
      arguments.callee = arguments.callee.caller;
      console.log( Array.prototype.slice.call(arguments) );
  }
};
// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();)b[a]=b[a]||c})(window.console=window.console||{});


// place any jQuery/helper plugins in here, instead of separate, slower script files.
/*
*
* Easy front-end framework
*
* Copyright (c) 2009 Alen Grakalic
* http://easyframework.com/license.php
*
* supported by Templatica (http://templatica.com)
* and Css Globe (http://cssglobe.com)
*
* built to be used with jQuery library
* http://jquery.com
*
* update: May 10th 2010
*
*/

(function($) {
    
    $.easy = {
        navigation: function(options) {
            var defaults = {
                selector: '#nav li',
                className: 'over'
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).each(function() {
                $(this).hover(function() {
                    $('ul:first', this).fadeIn(100);
                    $(this).addClass(options.className)
                },
                function() {
                    $('ul', this).hide();
                    $(this).removeClass(options.className)
                })
            })
        },
        tooltip: function(options) {
            var defaults = {
                selector: '.tooltip',
                xOffset: 10,
                yOffset: 25,
                clickRemove: false,
                id: 'easy_tooltip',
                content: '',
                useElement: ''
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            var content;
            return $(options.selector).each(function() {
                var title = $(this).attr('title');
                $(this).hover(function(e) {
                    content = (options.content != '') ? options.content: title;
                    content = (options.useElement != '') ? $('#' + options.useElement).html() : content;
                    $(this).attr('title', '');
                    if (content != '' && content != undefined) {
                        $('body').append('<div id="' + options.id + '">' + content + '</div>');
                        $('#' + options.id).css({
                            'position': 'absolute',
                            'display': 'none'
                        }).css('top', (e.pageY - options.yOffset) + 'px').css('left', (e.pageX + options.xOffset) + 'px').fadeIn('fast')
                    }
                },
                function() {
                    $('#' + options.id).remove();
                    $(this).attr('title', title)
                });
                $(this).mousemove(function(e) {
                    var x = ((e.pageX + options.xOffset + $(this).width()) < $(window).width()) ? (e.pageX + options.xOffset) : (e.pageX - options.xOffset - $(this).width() - 16);
                    $('#' + options.id).css('top', (e.pageY - options.yOffset) + 'px').css('left', (x + 'px'))
                });
                if (options.clickRemove) {
                    $(this).mousedown(function(e) {
                        $('#' + options.id).remove();
                        $(this).attr('title', title)
                    })
                }
            })
        },
        popup: function(options) {
            var defaults = {
                selector: '.popup',
                popupId: 'col-popup',
                preloadText: 'Loading',
                errorText: 'There has been a problem with your request, please click outside this window to close it.',
                closeText: 'Close',
                prevText: 'Previous',
                nextText: 'Next'
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).each(function(i) {
                if ($(this).hasClass('gallery')) {
                    var classNames = $(this).attr('class');
                    classNames = classNames.split(' ').join('');
                    $.data(this, 'gallery', classNames);
                    eval('if((typeof ' + classNames + '_arr == "undefined")) ' + classNames + '_arr= new Array()');
                    eval(classNames + '_arr').push($(this));
                    $.data(this, 'index', eval(classNames + '_arr').length - 1)
                };
                $(this).bind('click',
                function(e) {
                    e.preventDefault();
                    if ($.browser.opera) $.support.opacity = true;
                    var ie6 = $.browser.msie && $.browser.version.substr(0, 1) < 7;
                    var opera95 = $.browser.opera && $.browser.version <= 9.5;
                    var w = $(window).width();
                    var h = $(document).height();
                    var w2 = $(window).width() / 2;
                    var h2 = $(window).height() / 2;
                    show = function() {
                        $('#' + options.popupId + 'preloader').remove();
                        if (cw != 0) $('#' + options.popupId + 'content').css('width', cw + 'px');
                        if (ch != 0) $('#' + options.popupId + 'content').css('height', ch + 'px');
                        set($('#' + options.popupId + 'content'));
                        $('#' + options.popupId + 'content').css('visibility', 'visible')
                    };
                    set = function(obj) {
                        $(obj).css({
                            'padding': '10px',
                            'background': '#fff',
                            'color': '#333',
                            'text-align': 'left',
                            'float': 'left',
                            'position': 'fixed',
                            'z-index': '10001',
                            'visible': 'hidden'
                        });
                        var left = w2 - $(obj).width() / 2;
                        var top = h2 - $(obj).height() / 2;
                        $(obj).css({
                            'left': left,
                            'top': top,
                            'display': 'none'
                        }).fadeIn('1000');
                        if (ie6) $(obj).css({
                            'position': 'absolute',
                            'top': (top + $(window).scrollTop()) + 'px'
                        });
                        if (opera95) $(obj).css({
                            'position': 'absolute',
                            'top': (document.body['clientHeight'] / 2 - $(obj).height() / 2 + $(window).scrollTop()) + 'px'
                        });
                        $('.caption', obj).css({
                            'width': $(obj).width() + 'px',
                            'display': 'block'
                        })
                    };
                    if (ie6) $('embed, object, select').css('visibility', 'hidden');
                    error = function() {
                        $('#' + options.popupId + 'content').text(options.errorText);
                        show()
                    };
                    remove = function() {
                        $('#' + options.popupId).remove();
                        $('#' + options.popupId + 'content').remove();
                        $('#' + options.popupId + 'preloader').remove();
                        if (ie6) $('embed, object, select').css('visibility', 'visible')
                    };
                    if ($('#' + options.popupId).length == 0) {
                        $('<div id="' + options.popupId + '"></div>').appendTo('body').css({
                            'width': w,
                            'height': h,
                            'background': '#000',
                            'position': 'absolute',
                            'top': '0',
                            'left': '0',
                            'z-index': '10000',
                            'opacity': .7
                        }).click(function() {
                            remove()
                        })
                    };
                    var href = $(this).attr('href');
                    var extension = href.substr(href.lastIndexOf('.')).toLowerCase();
                    var content;
                    var cw = 0;
                    var ch = 0;
                    var showOk = false;
                    $('<div id="' + options.popupId + 'preloader">' + options.preloadText + '</div>').appendTo('body');
                    set($('#' + options.popupId + 'preloader'));
                    $('<div id="' + options.popupId + 'content"></div>').appendTo('body');
                    $('#' + options.popupId + 'content').css({
                        'visibility': 'hidden',
                        'position': 'absolute',
                        'top': '-10000px',
                        'left': '-10000px'
                    });
                    if ($(this).hasClass('flash')) {
                        var flash = '<object width="100%" height="100%"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="' + href + '" /><embed src="' + href + '" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="100%" height="100%"></embed></object>';
                        $(flash).appendTo('#' + options.popupId + 'content');
                        cw = 600;
                        ch = 400;
                        showOk = true
                    } else {
                        if (extension == '.jpg' || extension == '.jpeg' || extension == '.gif' || extension == '.png' || extension == '.bmp') {
                            var img = new Image();
                            $(img).error(function() {
                                error()
                            }).appendTo('#' + options.popupId + 'content');
                            img.onload = function() {
                                show();
                                img.onload = function() {}
                            };
                            img.src = href + '?' + (new Date()).getTime() + ' =' + (new Date()).getTime()
                        } else if (href.charAt(0) == '#') {
                            $(href).clone().removeClass('hidden').appendTo('#' + options.popupId + 'content').show();
                            $.easy.forms('#' + options.popupId + 'content form');
                            showOk = true
                        } else {
                            $('<iframe frameborder="0" scrolling="auto" style="width:100%;height:100%" src="' + href + '" />').appendTo('#' + options.popupId + 'content');
                            cw = 950;
                            ch = 720;
                            showOk = true
                        }
                    };
                    var rel = $(this).attr('rel').split(';');
                    $.each(rel,
                    function(i) {
                        if (rel[i].indexOf('width') != -1) cw = rel[i].split(':')[1];
                        if (rel[i].indexOf('height') != -1) ch = rel[i].split(':')[1]
                    });
                    if ($(this).attr('title') != '') {
                        $('<span class="caption">' + $(this).attr('title') + '</span>').appendTo('#' + options.popupId + 'content').css({
                            'display': 'none',
                            'padding': '10px 0 0 0'
                        })
                    };
                    if (showOk) show();
                    $('<small>' + options.closeText + '</small>').appendTo('#' + options.popupId + 'content').css({
                        'position': 'absolute',
                        'float': 'left',
                        'left': '0',
                        'top': '-24px',
                        'color': '#fff',
                        'cursor': 'pointer'
                    }).click(function() {
                        remove()
                    });
                    if ($(this).hasClass('gallery')) {
                        var arr = $.data(this, 'gallery');
                        arr = eval(arr + '_arr');
                        var index = $.data(this, 'index');
                        if (arr.length > 1) {
                            $('<small>' + (index + 1) + '/' + arr.length + '</small>').appendTo('#' + options.popupId + 'content').css({
                                'position': 'absolute',
                                'float': 'right',
                                'right': '0',
                                'bottom': '-24px',
                                'color': '#fff',
                                'cursor': 'pointer'
                            });
                            $('<small id="' + options.popupId + 'gallery"></small>').appendTo('#' + options.popupId + 'content').css({
                                'position': 'absolute',
                                'float': 'left',
                                'left': '0',
                                'bottom': '-24px',
                                'color': '#fff',
                                'cursor': 'pointer'
                            });
                            if (index != 0) {
                                $('<span>' + options.prevText + '</span>').css('margin-right', '5px').appendTo('#' + options.popupId + 'gallery').click(function() {
                                    $('#' + options.popupId + 'content').remove();
                                    var obj = arr[index - 1];
                                    $(obj).trigger('click')
                                })
                            }
                            if (index < arr.length - 1) {
                                $('<span>' + options.nextText + '</span>').appendTo('#' + options.popupId + 'gallery').click(function() {
                                    $('#' + options.popupId + 'content').remove();
                                    var obj = arr[index + 1];
                                    $(obj).trigger('click')
                                })
                            }
                        }
                    }
                })
            })
        },
        external: function(options) {
            var defaults = {
                selector: 'a'
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            var hostname = window.location.hostname;
            hostname = hostname.replace('www.', '').toLowerCase();
            return $(options.selector).each(function() {
                var href = $(this).attr('href').toLowerCase();
                if (href.indexOf('http://') != -1 && href.indexOf(hostname) == -1) {
                    $(this).attr('target', '_blank');
                    $(this).addClass('external')
                }
            })
        },
        rotate: function(options) {
            var defaults = {
                selector: '.rotate',
                initPause: 0,
                pause: 5000,
                randomize: false
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).each(function() {
                var obj = $(this);
                var length = $(obj).children().length;
                var temp = 0;
                function getRan() {
                    var ran = Math.floor(Math.random() * length) + 1;
                    return ran
                };
                function show() {
                    if (options.randomize) {
                        var ran = getRan();
                        while (ran == temp) {
                            ran = getRan()
                        };
                        temp = ran
                    } else {
                        temp = (temp == length) ? 1 : temp + 1
                    };
                    $(obj).children().hide();
                    $(':nth-child(' + temp + ')', obj).fadeIn('slow')
                };
                function init() {
                    show();
                    setInterval(show, options.pause)
                };
                setTimeout(init, options.initPause)
            })
        },
        cycle: function(options) {
            var defaults = {
                selector: '.cycle',
                effect: 'fade',
                initPause: 0,
                pause: 5000
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).each(function() {
                var obj = $(this);
                var length = $(obj).children().length;
                var temp = 0;
                var prev = -1;
                var z = 1;
                var h = $(':nth-child(1)', obj).height();
                $(obj).css('position', 'relative').height(h);
                $(obj).children().hide().css({
                    'position': 'absolute',
                    'top': '0',
                    'left': '0'
                });
                function show() {
                    temp = (temp == length) ? 1 : temp + 1;
                    prev = (temp == 1) ? length: temp - 1;
                    $(':nth-child(' + temp + ')', obj).css('z-index', z).fadeIn('slow',
                    function() {
                        $(':nth-child(' + prev + ')', obj).fadeOut('slow')
                    });
                    z++
                };
                function init() {
                    show();
                    setInterval(show, options.pause)
                };
                setTimeout(init, options.initPause)
            })
        },
        jump: function(options) {
            var defaults = {
                selector: 'a.jump',
                speed: 1000
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).click(function() {
                var target = $($(this).attr('href'));
                var offset = $(target).offset().top;
                $('html,body').animate({
                    scrollTop: offset
                },
                1000, 'linear')
            })
        },
        showhide: function(options) {
            var defaults = {
                selector: '.toggle'
            };
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).each(function() {
                var target;
                if ($(this).hasClass('prev')) {
                    target = $(this).prev().hide()
                } else if ($(this).hasClass('id')) {
                    target = $(this).attr('href');
                    target = $(target).hide()
                } else {
                    target = $(this).next().hide()
                };
                $(this).css('cursor', 'pointer');
                $(this).toggle(function() {
                    $(this).addClass('expanded');
                    $(target).slideDown()
                },
                function() {
                    $(target).slideUp();
                    $(this).removeClass('expanded')
                })
            })
        },
        forms: function(options) {
            var defaults = {
                selector: 'form',
                err: 'This is required',
                errEmail: 'Valid email address is required',
                errUrl: 'URL is required',
                errPhone: 'Phone number is required',
                notValidClass: 'notvalid'
            };
            function check(obj) {
                if ($(obj).val() == '' || checkLabel(obj)) {
                    var errormsg = ($(obj).attr('title') != '') ? $(obj).attr('title') : options.err;
                    error(obj, errormsg)
                }
            };
            function checkRegEx(obj, type) {
                var regEx, err;
                switch (type) {
                case 'url':
                    regEx = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
                    err = options.errUrl;
                    break;
                case 'phone':
                    var regEx = /[\d\s_-]/;
                    err = options.errPhone;
                    break;
                default:
                    regEx = /^[^@]+@[^@]+.[a-z]{2,}$/;
                    err = options.errEmail
                };
                var val = $(obj).val();
                if (val.search(regEx) == -1 || checkLabel(obj)) {
                    var errormsg = ($(obj).attr('title') != '') ? $(obj).attr('title') : err;
                    error(obj, errormsg)
                }
            };
            function checkLabel(obj) {
                var text = $('label[for=' + $(obj).attr('id') + ']').text();
                return (text == $(obj).val())
            };
            function error(obj, errormsg) {
                var parent = $(obj).parent();
                parent.append('<span class="error">' + errormsg + '</span>');
                $('span.error', parent).hide().fadeIn('fast');
                $(obj).addClass(options.notValidClass);
                valid = false
            };
            $('input.label,textarea.label').each(function() {
                var text = $('label[for=' + $(this).attr('id') + ']').text();
                $('label[for=' + $(this).attr('id') + ']').css('display', 'none');
                $(this).val(text);
                $(this).focus(function() {
                    if ($(this).val() == text) $(this).val('')
                });
                $(this).blur(function() {
                    if ($(this).val() == '') $(this).val(text)
                })
            });
            if (typeof options == 'string') defaults.selector = options;
            var options = $.extend(defaults, options);
            return $(options.selector).each(function() {
                $(this).submit(function() {
                    $('.error', this).remove();
                    $('.' + options.notValidClass, this).removeClass(options.notValidClass);
                    valid = true;
                    $(':text.required', this).each(function() {
                        if ($(this).hasClass('email')) {
                            checkRegEx(this, 'email')
                        } else if ($(this).hasClass('url')) {
                            checkRegEx(this, 'url')
                        } else if ($(this).hasClass('phone')) {
                            checkRegEx(this, 'phone')
                        } else {
                            check(this)
                        }
                    });
                    $(':password.required', this).each(function() {
                        check(this)
                    });
                    $('textarea.required', this).each(function() {
                        check(this)
                    });
                    $(':checkbox.required', this).each(function() {
                        if (!$(this).attr('checked')) {
                            var errormsg = ($(this).attr('title') != '') ? $(this).attr('title') : options.err;
                            error(this, errormsg)
                        }
                    });
                    return valid
                })
            })
        }
    }
})(jQuery);
