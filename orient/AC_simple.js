
function RunFoo()
{
    document.write('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" WIDTH="550" HEIGHT="400">\n');
    document.write('<param name="movie" value="media/webctemail_020703.swf" />\n');
	document.write('<param name="loop" value="false" />\n');
	document.write('<param name="quality" value="high" />\n');
	document.write('<param name="bgcolor" value="#FFFFFF" />\n');
	document.write('<EMBED src="media/webctemail_020703.swf" loop="false" quality="high" bgcolor="#FFFFFF" WIDTH="550" HEIGHT="400" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></EMBED>\n');
    document.write('</object>\n');
}
