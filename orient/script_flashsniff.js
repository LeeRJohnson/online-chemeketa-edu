<script type="text/javascript">
	<!-- hide JavaScript from non-JavaScript browsers
	// Flash checking code adapted from Doc JavaScript information; 
	// see http://webref.com/js/column84/2.html
	var agt=navigator.userAgent.toLowerCase();
    var appVer = navigator.appVersion.toLowerCase();
   	var iePos  = appVer.indexOf('msie');
	var is_ie   = ((iePos!=-1) && (!is_opera) && (!is_khtml));
	// *** BROWSER VERSION ***
	var is_minor = parseFloat(appVer);
    var is_major = parseInt(is_minor);
	if (iePos !=-1) {
       is_minor = parseFloat(appVer.substring(iePos+5,appVer.indexOf(';',iePos)))
       is_major = parseInt(is_minor);
    }
	var is_gecko = ((!is_khtml)&&(navigator.product)&&(navigator.product.toLowerCase()=="gecko"))?true:false;
	var is_konq = false;
    var kqPos   = agt.indexOf('konqueror');
    if (kqPos !=-1) {                 
       is_konq  = true;
       is_minor = parseFloat(agt.substring(kqPos+10,agt.indexOf(';',kqPos)));
       is_major = parseInt(is_minor);
    }       
    var is_safari = ((agt.indexOf('safari')!=-1)&&(agt.indexOf('mac')!=-1))?true:false;
	var is_khtml  = (is_safari || is_konq);
	
	var is_Flash        = false;
   	var is_FlashVersion = 0;
	var is_nav  = ((agt.indexOf('mozilla')!=-1) && (agt.indexOf('spoofer')==-1)
                && (agt.indexOf('compatible') == -1) && (agt.indexOf('opera')==-1)
                && (agt.indexOf('webtv')==-1) && (agt.indexOf('hotjava')==-1)
                && (!is_khtml) && (!(is_moz)));
	var is_opera = (agt.indexOf("opera") != -1);
	var is_moz   = ((agt.indexOf('mozilla/5')!=-1) && (agt.indexOf('spoofer')==-1) &&
                    (agt.indexOf('compatible')==-1) && (agt.indexOf('opera')==-1)  &&
                    (agt.indexOf('webtv')==-1) && (agt.indexOf('hotjava')==-1)     &&
                    (is_gecko) && 
                    ((navigator.vendor=="")||(navigator.vendor=="Mozilla")));
	 var is_mac   = (agt.indexOf("mac")!=-1);	
	 var is_ie5up = (is_ie && is_minor >= 5);
   	 var is_win   = ( (agt.indexOf("win")!=-1) || (agt.indexOf("16bit")!=-1) );
	 var is_ie4up = (is_ie && is_minor >= 4);
	
	 if ((is_nav||is_opera||is_moz)||
       (is_mac&&is_ie5up)) {
	  var plugin = (navigator.mimeTypes && 
                    navigator.mimeTypes["application/x-shockwave-flash"] &&
                    navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin) ?
                    navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
      if (plugin) {
        	window.document.location = ("<cfoutput>http://#cgi.server_name##cgi.script_name#?flash=yes</cfoutput>");
      }
	  else {
	  		window.document.location = ("<cfoutput>http://#cgi.server_name##cgi.script_name#?flash=no</cfoutput>");
	  }
   }

   else if (is_win&&is_ie4up)
   {
	   	document.write(
	         '<scr' + 'ipt language=VBScript>' + '\n' +
	         'Dim hasPlayer, playerversion' + '\n' +
	         'hasPlayer = false' + '\n' +
	         'playerversion = 10' + '\n' +
	         'Do While playerversion > 0' + '\n' +
	            'On Error Resume Next' + '\n' +
	            'hasPlayer = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash." & playerversion)))' + '\n' +
	            'If hasPlayer = true Then Exit Do' + '\n' +
	            'playerversion = playerversion - 1' + '\n' +
	         'Loop' + '\n' +
	         'is_FlashVersion = playerversion' + '\n' +
	         'is_Flash = hasPlayer' + '\n' +
	         '<\/sc' + 'ript>'
	      );
	   	if (is_Flash) {
        	window.document.location = ("<cfoutput>http://#cgi.server_name##cgi.script_name#?flash=yes</cfoutput>");
      	}
	  	else {
	  		window.document.location = ("<cfoutput>http://#cgi.server_name##cgi.script_name#?flash=no</cfoutput>");
	  	}
	}
	else 
	// not any one of the aformentioned browsers
	 {
	 	window.document.location = ("<cfoutput>http://#cgi.server_name##cgi.script_name#?flash=no</cfoutput>");
	}

   
// -->
</script>