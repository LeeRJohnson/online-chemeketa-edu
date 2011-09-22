//new pop-up window function	
/*2 variables are passed the url of the page to be displayed in the window 
& a variable to turn off the toolbars and resize the window accordingly */

var popWindow
function pop(url, tools) {
if(tools=='notools')
	var width = 640;
else
	var width = 604;
	var height = 480;
	
var winl = (screen.width - width) / 2;
var wint = (screen.height - height) / 2;
var win2 = (screen.width - width) * 0.8;
var winv = (screen.height - height) * 0.8;
if(popWindow && !popWindow.closed) {
popWindow.close();
}
if(tools=='notools')
	popWindow = window.open(url, "", "toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=0,resizable=1,width=620,height=480,left=" + winl + ",top=" + wint + "")
else if (tools=='menubar')
	popWindow = window.open(url, "", "toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=1,resizable=1,width=604,height=480,left=" + winl + ",top=" + wint + "")
else if (tools=='browsertable')
	popWindow = window.open(url, "", "toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=1,resizable=1,width=800,height=680,left=" + win2 + ",top=" + winv + "")
else
	popWindow = window.open(url, "", "toolbar=1,scrollbars=1,location=1,statusbar=1,menubar=0,resizable=1,width=604,height=480,left=" + winl + ",top=" + wint + "")

}

function popSize(url, w, h) {
var winl = (screen.width - w) / 2;
var wint = (screen.height - h) / 2;
if(popWindow && !popWindow.closed) 
	popWindow.close();

popWindow = window.open(url, "", "toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=0,resizable=1,width="+w+",height="+h+",left=" + winl + ",top=" + wint + "")
}

// - End of JavaScript - -->
