/*  -----------------------------------------------------------

Common Utilites - Version 0.1 (Development)

Authors: Lee R Johnson - ljohns10@chemeketa.edu

Additional functions and plugins for common actions

-----------------------------------------------------------  */
jQuery.fn.delay = function(callback, time) {
    return this.each(function() {
        setTimeout(callback, time);
    });
};
jQuery.fn.makeAbsUrl = function(baseUrl) {
    return this.each(function() {
        var baseUrl = parseUri(baseUrl);
        var href = parseUri(this.attr('href').val());
        href.protocal = baseUrl.protocal;
        href.authority = baseUrl.authority;
        this.attr('href', href.url());
    });
};