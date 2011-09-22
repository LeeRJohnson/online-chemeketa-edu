<!--- Set Breadcrumbs --->
<cfset Crumbs="<a href='../intro/intro.cfm'>HOME</a> &raquo; <a href='mod6.cfm'>SUMMARY</a> &raquo; <span style='color:Red;'>LOGIN INSTRUCTIONS</span>">

<!---Set SideBar info--->
<cfset Side_section="6"><!--- under what main category does the submenu appear? --->
<cfset submenu = ArrayNew(2)>
<cfset thispage = 1> <!--- where does the submenu appear --->
<cfset submenu[1][1] = "../mod6/mod6.cfm">
<cfset submenu[1][2] = "Logging In">


<cfinclude template="../template_top2.cfm">
<div id="maincontent">
<!--- Content Starts Content Starts  Content Starts Content Starts Content Starts Content Starts --->

<!--- Print popup link --->
<span class="linkmenu"><a href="#" onclick="pop('mod6_loginverprint.cfm?popup=yes','menubar'); return false; ">Print Version </a> | </span>

<!--- Set session variable --->
<cfif IsDefined("URL.Flash")>
	<cfif URL.Flash IS "Yes"><cfset Session.Flash = "YES"></cfif>
	<cfif URL.Flash IS "No"><cfset Session.Flash = "NO"></cfif>
</cfif>

<!--- Show Flash --->
<cfif Session.Flash IS "YES">
	<span class="linkmenu"><a href="mod6_login.cfm?Flash=no">Non-Flash Version</a></span>
	<center><OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
 codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0"
 WIDTH=550 HEIGHT=400>
 <PARAM NAME=movie VALUE="media/login.swf"> <PARAM NAME=loop VALUE=false> <PARAM NAME=quality VALUE=high> <PARAM NAME=bgcolor VALUE=#FFFFFF> <EMBED src="media/login.swf" loop=false quality=high bgcolor=#FFFFFF  WIDTH=550 HEIGHT=400 TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></EMBED>
</OBJECT></center>

<!--- Include Html --->
<cfelseif Session.Flash IS "NO">
<cfset Back="mod6.cfm"><cfset Next="mod6_congrats.cfm">
	<span class="linkmenu"><a href="mod6_login.cfm?Flash=yes">Flash Version</a></span><br />
	
<cfinclude template="mod6_loginverprint.cfm">

<cfelse>
	<!--- SET YES/NO --->
	<script type="text/javascript">
	//If this browser understands the mimeTypes property and recognizes the MIME Type 			//"application/x-shockwave-flash"...
	if (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"] 
  	&& navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin 
  	&& navigator.plugins && navigator.plugins["Shockwave Flash"]){
	 location = "mod6_login.cfm?Flash=yes";
	}
	else location = "mod6_loginver.cfm?Flash=no"; 
	</script>

</cfif>
<br /><br />



<!--- Content Ends Content Ends Content Ends Content Ends Content Ends Content Ends Content Ends --->
</div>
<cfinclude template="../template_bottom2.cfm"> 
