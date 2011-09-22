<!--- Set Breadcrumbs --->
<cfset Crumbs="<a href='../intro/intro.cfm'>HOME</a> &raquo; <a href='mod4.cfm'>ELEARN SKILLS</a> &raquo; <a href='mod4_navsum.cfm'>THE HOMEPAGE</a> &raquo; <a href='mod4_nav.cfm'>NAVIGATION</a> &raquo; <a href='mod4_bb.cfm'>BULLETIN BOARD</a> &raquo; <span style='color:Black;font-weight:bold;'>E-MAIL:</span>">

<!---Set SideBar info--->
<cfset Side_section="4"><!--- under what main category does the submenu appear? --->
<cfset submenu = ArrayNew(2)>
<cfset thispage = 3> <!--- where does the submenu appear --->
<cfset submenu[1][1] = "../mod4/mod4_nav.cfm">
<cfset submenu[1][2] = "Navigation">
<cfset submenu[2][1] = "../mod4/mod4_bb.cfm">
<cfset submenu[2][2] = "Discussion Board">
<cfset submenu[3][1] = "../mod4/mod4_email.cfm">
<cfset submenu[3][2] = "Email">
<cfset submenu[4][1] = "../mod4/mod4_quizzes.cfm">
<cfset submenu[4][2] = "Quizzes">
<cfset submenu[5][1] = "../mod4/mod4_webctprint.cfm">
<cfset submenu[5][2] = "Printing">

<cfinclude template="../template_top2.cfm">
<div id="maincontent">
<!--- Content Starts Content Starts  Content Starts Content Starts Content Starts Content Starts --->

<!--- Print popup link --->
<ul>
	<li><h2><a href="media/mail_read_post.swf" onclick="pop('media/mail_read_post.swf?popup=yes','menubar'); return false; ">Click here for the demo for reading and sending e-mail </a></h2></li>
</ul>


<!--- <!--- Set session variable --->
<cfif IsDefined("URL.Flash")>
	<cfif URL.Flash IS "Yes"><cfset Session.Flash = "YES"></cfif>
	<cfif URL.Flash IS "No"><cfset Session.Flash = "NO"></cfif>
</cfif> --->
<!--- NAV--->
<cfset nexttext = request.lms & " Quizzes&nbsp;&nbsp;&nbsp;"><cfset Back="mod4_bb.cfm"><cfset Next="mod4_quizzes.cfm">

<!--- <!--- Show Flash --->
<cfif Session.Flash IS "YES">
	<span class="linkmenu"><a href="mod4_email.cfm?Flash=no">Non-Flash Version</a></span>
	<center><OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
 codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0"
 WIDTH=550 HEIGHT=400>
 <PARAM NAME=movie VALUE="media/webctemail_020703.swf"> <PARAM NAME=loop VALUE=false> <PARAM NAME=quality VALUE=high> <PARAM NAME=bgcolor VALUE=#FFFFFF> <EMBED src="media/webctemail_020703.swf" loop=false quality=high bgcolor=#FFFFFF  WIDTH=550 HEIGHT=400 TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></EMBED>
</OBJECT></center>

<!--- Include Html --->
<cfelseif Session.Flash IS "NO"> 
	<span class="linkmenu"><a href="http://webct.pstcc.edu/studenthelp/tutorials/discussion/discussions.html" target="_blank">Flash Version</a> (on Pellissippi State University web site)</span><br />
	--->
<!--- <cfinclude template="mod4_emailprint.cfm"> --->

<!--- <cfelse>
	<cfset URL="mod4_email.cfm">
	<cfinclude template="../script_flashsniff.js">

</cfif> --->

<!--- Content Ends Content Ends Content Ends Content Ends Content Ends Content Ends Content Ends --->
</div>
<cfinclude template="../template_bottom2.cfm">

