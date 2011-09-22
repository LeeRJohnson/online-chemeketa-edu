<!--- 
	Template: dsp_class_info3.cfm
	Author:	Thomas Bishop	
	
	Linked from:	course_descriptions/default.cfm,
				dsp_delivery.cfm,
				dsp_gotoce6.cfm,
				dsp_gotoce8.cfm,
				dsp_gotolms.cfm,
				dsp_instructor.cfm,
				dsp_lms_form.cfm,
				eval/dsp_instruct_pw_form.cfm,
				handbook/dsp_cont_id4.cfm,
				handbook/dsp_page.cfm
	Calls: 
	Associated Templates: 	course_descriptions/dsp_course_info.cfm, util/etutor.cfm
							
	Includes: 	OnRequestEnd.cfm (maybe)
	Required Variables: 
			ishost,preopen,request.curtermid,request.shownext

	Passed Variables: 
			
	
	Required Queries: 	gettermtextlist (inline), pubclasses (included)
						thisterm (inline), elearnpercent (inline)
	Required Database: col
			
	Purpose: I display a lot of information, most of which is dynamically dependent upon
				the current date in relation to the start of a particular term
				Many 'if's and loops
			First we choose a term to view, then display a box of notes, then a table
				of all DE classes with links for more information pertaining to such
	
	Date Created: circa 2004??
	Modification History: 
		removed links in table, changed to expand, group by course (then Lec, Lab, Rec), removed 'insession' div, 'Go to Class' references, instant scroll, grouping by letter (2011-04-28)
 --->

 
<!--- initialize some vars --->
<cfparam name="ishost" default="0">
<cfparam name="preopen" type="date" default="2000-01-01">
<cfset thenow = DateFormat(Now(),"yyyy-mm-dd") & ' ' & TimeFormat(Now(),"HH:mm:ss") & '.0'>
<cfparam name="Variables.localclient" default="false" type="boolean">

<cfif IsDefined("CGI.REMOTE_ADDR") AND (CGI.REMOTE_ADDR CONTAINS "10.9.1" OR CGI.REMOTE_ADDR EQ "10.9.2.53") AND CGI.REMOTE_ADDR DOES NOT CONTAIN "10.9.1.91">
	<cfset Variables.localclient = true>
<cfelse>
	<cfset Variables.localclient = false>
</cfif>


	
<div id="classlistmain">
<!--- I then check to see if a term has been selected and appears in the URL --->
<cfif NOT IsDefined("URL.tid")>
	<div id="notid"><!-- start 'notid' div -->
	
		<!--- select term form action: here --->
		<!--- create a list of term ids surrounding the current one --->
		<cfset CountVar = request.curtermid - 3><!--- go back three terms --->
		<cfif request.shownext EQ "true"><!--- edit this value in the Global Settings XML file --->
			<cfset future = request.curtermid + 1>
		<cfelse>
			<cfset future = request.curtermid>
		</cfif><!--- end of 'request.shownext' if --->
				
		<cfset termlist = "">
		<cfloop condition="CountVar LESS THAN (future)">
			<cfset CountVar = CountVar + 1>
			<cfset termlist = ListAppend(termlist,CountVar)>
		</cfloop>
						
		<!--- query the database for corresponding termtext --->
		<cfquery 	datasource="#request.sqldsn#"
					name="gettermtextlist">
		SELECT Term_ID,TermText
		FROM termtext_vu
		WHERE Term_ID IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" list="Yes" null="No" value="#termlist#" maxlength="25">)
		ORDER BY Term_ID
		;
		</cfquery>
						
		
		<div id="termform"><!-- start 'termform' div -->
        <form method="get" action="">
		<cfif IsDefined("URL.h") AND IsNumeric(URL.h) AND URL.h LT 2>
			<cfoutput><input type="hidden" name="h" value="#URL.h#" />
			<cfif URL.h EQ "0">
				<p id="titlebox">Chemeketa Community College students</p>
				<p>Not registered through Chemeketa? Come in as a <a href="#CGI.SCRIPT_NAME#?h=1<cfif IsDefined('URL.tid')>&amp;tid=#URL.tid#</cfif>">host college student</a></p>
			<cfelseif URL.h EQ "1">
				<p id="titlebox">Host College students</p>
				<p>Registered through Chemeketa? Come in as a <a href="#CGI.SCRIPT_NAME#?h=0<cfif IsDefined('URL.tid')>&amp;tid=#URL.tid#</cfif>">Chemeketa student</a></p>
			<cfelse>
				<h2>Chemeketa Online class access</h2>
				<fieldset id="hostornot">
					<legend>Choose your student type</legend>
					<label for="h1">I am a Host college student: </label><input type="radio" value="1" name="h" id="h1" /><br />
                    <div class="details">A host student is one who has registered (or plans to register) through their local Oregon community college and not through Chemeketa</div>
					<label for="h0">I am a Chemeketa student: </label><input type="radio" value="0" name="h" id="h0" checked /><br />
                    <div class="details">A Chemeketa student is one who has registered (or plans to register) through Chemeketa Community College via the <a href="http://my.chemeketa.edu/" target="_blank">My Chemeketa web site</a>.</div>				
				</fieldset>
				
			</cfif><!---  end of 'URL.h EQ 0' if --->
			</cfoutput>
		<cfelse>
			<h1>Chemeketa Online class access</h1>
			<fieldset id="hostornot">
				<legend>Choose your student type</legend>
					<input type="radio" value="1" name="h" id="h1" /><label for="h1">I am a Host college student: </label><br />
                    <div class="details">A host student is one who has registered (or plans to register) through their local Oregon community college and not through Chemeketa</div>
					<input type="radio" value="0" name="h" id="h0" checked /><label for="h0">I am a Chemeketa student: </label><br />
                    <div class="details">A Chemeketa student is one who has registered (or plans to register) through Chemeketa Community College via the <a href="http://my.chemeketa.edu/" target="_blank">My Chemeketa web site</a>.</div>				
			</fieldset>
		</cfif>
		<label for="tid" class="chooseterm">Choose term:&nbsp;&nbsp;</label>
		<span class="text3">
	    	<select class="textform" name="tid" id="tid">
				<cfoutput query="gettermtextlist">
					<option value="#Term_ID#"<cfif Term_ID EQ request.curtermid> selected="selected"</cfif>>#TermText#</option>
				</cfoutput>
	  		</select></span>
            <div class="submit">
			<button type="submit" id="sbmt"><img src="global_images/edit.png" alt="submit form to continue" title="submit form to continue" />Go</button>
            </div>
        </form> 
		</div><!-- end 'termform' div -->
        
       
       
		</div><!-- end 'notid' div -->		
	</div><!-- end 'classlistmain' div -->
					
	<cfinclude template="OnRequestEnd.cfm">
	<cfabort>
			
	
<!--- If we don't know if they're host student or not, let them choose --->	
<cfelseif IsDefined("URL.tid") AND NOT IsDefined("URL.h")>
	<div id="hform">
		<cfoutput>
		<form method="get" action="">
		<fieldset id="hostornot">
			<legend>Choose your student type: </legend>		
			<input type="hidden" name="tid" value="#URL.tid#" />
			<input type="radio" value="1" name="h" id="h1" />&nbsp;<label for="h1">I am a Host college student</label><br />
            <div class="details">A host student is one who has registered (or plans to register) through their local Oregon community college and not through Chemeketa</div>
            
            <input type="radio" value="0" name="h" id="h0" checked /><label for="h0">I am a Chemeketa student</label><br />
            <div class="details">A Chemeketa student is one who has registered (or plans to register) through Chemeketa Community College via the <a href="http://my.chemeketa.edu/" target="_blank">My Chemeketa web site</a>.</div><br />
			<div class="submit">
            <input type="submit" value="Go" style="width:30px;" />
            </div>
		</fieldset>
		
		</cfoutput>
	</div><!--- end 'hform' div --->
	<cfinclude template="OnRequestEnd.cfm">
	<cfabort>
	
</cfif><!--- end of 'NOT IsDefined("URL.tid")' if --->
		
		<!--- trap them if they type non-numeric chars for the term id --->
		<cfif NOT IsNumeric(URL.tid) OR URL.tid GT 145 OR URL.tid LT 3>
			<span class="warning">ERROR:</span> Term ID must be numeric and be within the bounds of our time frame. Please start over.
			<cfinclude template="OnRequestEnd.cfm"><cfabort>
		</cfif>
		<!--- query the database for chosen termtext --->
			<cfquery 	datasource="#request.sqldsn#"
						name="thisterm" 
						maxrows="1">
				SELECT Term_ID,TermText,TermNumber,termstart
				FROM termtext_vu
				WHERE Term_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" maxlength="3" null="No" value="#URL.tid#">
				;
			</cfquery>
	
		<!--- set the variable for host or not host --->
		<cfif IsDefined("URL.h") AND URL.h EQ "1">
			<cfset Variables.ishost = "1">
		<cfelse>
			<cfset Variables.ishost = "0">
		</cfif>
		
		<!--- now that we have the term, invoke the query method --->
		<cfparam name="Variables.theterm" default="#request.curtermid#">
		<cfif IsDefined("URL.tid") AND IsNumeric(URL.tid) AND URL.tid LT 400 AND URL.tid GT 2>
			<cfset Variables.theterm = URL.tid>
		</cfif>
		
		<!--- get the data --->
		<cfinvoke component="edu.chemeketa.common.testing" method="getPublicClasses" returnvariable="pubclasses">
			<cfinvokeargument name="termid" value="#Variables.theterm#">
			<cfinvokeargument name="ishost" value="#Variables.ishost#">
			<cfif IsDefined("URL.sort") AND Len(URL.sort) LT 20>
			<cfinvokeargument name="primesort" value="#Trim(URL.sort)#">
			</cfif>
		</cfinvoke>
		
		<cfoutput>
		<div id="outside" /><!-- 'outside' div (self-closing) -->
			<div id="top-pars"><!-- start 'top' div -->
				<!--- page header showing term --->
				<span id="titlebox">Online Class Schedule for #thisterm.TermText#</span>
				
				<!--- allow them to choose a different term --->
				
				<span class="normal"><a href="#CGI.SCRIPT_NAME#?h=0">Choose a different term</a>
					<cfif thisterm.Term_ID NEQ request.curtermid>
						&nbsp;|&nbsp;<a href="#CGI.SCRIPT_NAME#?h=0&amp;tid=#request.curtermid#">Jump to current term</a>						
					</cfif>
					</span>
			<cfif IsDefined("URL.tid") AND (URL.tid IS 85 OR URL.tid IS 86)><!--- if summer 2011 or fall 2011, show errata --->
				<div class="note">
					<p>Chemeketa experienced an error in the printed version of our schedule of classes.  Online classes are appearing as either &quot;Chemeketa Online Day&quot; or &quot;Chemeketa Online Evening&quot;. This distinction is simply an error that occurred in the printed schedule. Online courses are neither day nor evening restricted.</p>
				<p>We are aware of the issue and working to correct it for future printed schedules. In the meantime, feel free to register for online classes without concern of any time restrictions.</p>
				<p>If you have any additional questions, please don't hesitate to contact Chemeketa Online at 503.399.7873 or <a href="http://learning.chemeketa.edu/dsp_email_form.cfm?mailto=online@chemeketa.edu&subject=question%20about%20the%20printed%20schedule">online@chemeketa.edu</a>.</p>
				</div>
			</cfif><!--- end of 'URL.tid' if --->
		</cfoutput>	
		
		<!--- provide a carousel of course categories --->	
		<!--- get distinct list of categories --->
		<cfquery dbtype="query" name="ccat">
		SELECT DISTINCT CourseCategory, cpre
		FROM	pubclasses
		ORDER BY cpre
		</cfquery>

			<ul id="mycarousel" class="jcarousel-skin-tango">
				<cfoutput query="ccat">
				<li><a href="###Trim(Replace(CourseCategory,' ',''))#"><abbr>#cpre#</abbr><br /><dfn>#CourseCategory#</dfn></a></li>
				</cfoutput>
			</ul>
			
			
		</div><!-- end 'top' div -->
		
		
		<!--- table for classes in selected term --->
		<div id="thelist"><!-- start 'thelist' div -->
			
			<cfoutput>
			<!--- sort by course name or course number --->
			<cfset Variables.linkstring = CGI.SCRIPT_NAME>
			<cfset Variables.defaultquery = "">
			<cfif IsDefined("CGI.QUERY_STRING") AND CGI.QUERY_STRING GT "">
				<cfif IsDefined("URL.h")>
					<cfset Variables.defaultquery = Variables.defaultquery & "h=" & URL.h>
				</cfif>
				<cfif IsDefined("URL.tid") AND IsDefined("URL.h")>
					<cfset Variables.defaultquery = Variables.defaultquery & "&amp;tid=" & URL.tid>
				</cfif>
				<cfset Variables.linkstring = Variables.linkstring & "?" & Variables.defaultquery>
			</cfif>
			<cfif IsDefined("URL.sort") AND URL.sort EQ "c.CourseNum">
				<div id="sort">
					<span>Sorted by course number || <a href="#Variables.linkstring#&amp;sort=c.CourseName">Sort by course name</a></span>&nbsp;				
				</div>
			<cfelseif IsDefined("URL.sort") AND URL.sort EQ "c.CourseName">
				<div id="sort">
					<span>Sorted by course name || <a href="#Variables.linkstring#&amp;sort=c.CourseNum">Sort by course number</a></span>&nbsp;
				</div>
			<cfelse>
				<div id="sort">
					<span><a href="#Variables.linkstring#&amp;sort=c.CourseName">Sort by course name</a></span>&nbsp;
				</div>
			</cfif>
			</cfoutput>
			
			
            <!--- Schedule QuickSearch --->
            <!-- Libs Ref:
            	jQuery : http://jquery.com (script hosted by google)
                jQuery.quickSearch : http://rikrikrik.com/jquery/quicksearch/
            -->
			<!--- quicksearch references now in Application.cfm and script.js --->
            
			
			<!--- END Schedule QuickSearch --->
					
			
			
			<!--- MAIN TABLE --->
			<table id="crs-sched" style="font-size:9pt;" border="0" summary="table provides links to classes, course information, instructor information, etcetera">
              <thead>
				<tr>
					<th align="left" title="This is the Course Reference Number you use to register with.">CRN</th>
					<th align="left" title="A Course link will take you to the Course Description page.">
					Course&nbsp;/&nbsp;Course Name
					</th>
					<th align="left" title="The Instructor link will bring up an information page about the instructor.">Instructor</th>
					<!--- <th align="left" title="The Delivery link: how to access and function in that type of class.">Delivery</th> --->
					<cfif Variables.ishost NEQ "1" AND Variables.localclient EQ true>
					<th align="left" title="The Availability link: how many seats are available for students to register for this section. (visible to only 9-106 computers)">Availability<br />(COL clients only)</th>					
					</cfif>
				</tr>
              </thead>
              <tbody>
				<cfoutput query="pubclasses" group="CourseCategory">
				<tr>
					<th><a href="##top-pars"><img src="/global_images/triangle-up.gif" title="Return to top of page" /></a></th>
					<th id="#Trim(Replace(CourseCategory,' ',''))#" colspan="3" class="crs-category">#CourseCategory#</th>
					<th><a href="##top-pars"><img src="/global_images/triangle-up.gif" title="Return to top of page" /></a></th>
				</tr>
					
				<cfoutput group="coursenum">
				<tr id="#CourseNum#" class="crs-number">
					<th colspan="4" class="crs-num" title="click to see more information about this course">&nbsp;
					<a class="course-info" href="/catalog/#cpre#/#cnum#">#CourseNum# - #Replace(CourseName,"'",Chr(39))#</a></th>
					
				</tr>
				
				<cfoutput>
				<tr class="crs-section #CourseCategory# #CourseNum#">
					<!--- Column 1 --->
					<td>
					#CRN#
					</td>
					
					<!--- Column 2 --->
					<td style="<cfif sectype EQ 'Lab'>background-color:rgb(220,220,220);<cfelseif sectype EQ 'Recitation'>background-color:rgb(230,220,210);</cfif>">
					<cfif status CONTAINS "cancel">
						&nbsp;<span class="warning">cancelled</span>
					<cfelse>
						&nbsp;#sectype#
						<cfif Status CONTAINS "*">
							 &nbsp;&ndash;&nbsp;#Replace(Status,"*","")#
						</cfif>
						<cfif Trim(Status) GT "">
							&nbsp;&ndash;&nbsp;#Status#
						</cfif>
					</cfif>
					</td>
					<!--- Column 3 --->
					<td headers="#Left(pubclasses.CourseNum,1)#" style="white-space:nowrap;">
					<cfif instid NEQ 12><!--- not 'Staff' --->
						<!--- <a href="dsp_instructor.cfm?instid=#instid#">#Instructor#</a> ---><!--- if not using ISAPI_Rewrite --->
						<a href="instructor/#instid#/default.htm">#Instructor#</a><!--- uses ISAPI_Rewrite for SES URLs --->
					<cfelse>
						#Instructor#
					</cfif>
					</td>
					
					<!--- Column 4 (Chemeketa Online staff only) --->
					<cfif Variables.ishost NEQ "1" AND Variables.localclient EQ true>
					<td headers="#Left(pubclasses.CourseNum,1)#" title="Only LOCAL clients can see this column">
						<cfif status DOES NOT CONTAIN "cancel">
							<a href="https://ssb-cprd.chemeketa.edu/pls/cprd/bwckschd.p_disp_detail_sched?term_in=#thisterm.TermNumber#&amp;crn_in=#CRN#" target="_blank"><span style="text-decoration:none;">Availability</span></a>
						<cfelse>
							<span style="color:Gray;">Availability</span>	
						</cfif>
						
					</td>					
					</cfif>
				</tr>
				</cfoutput><!--- close innermost output group --->
				</cfoutput><!--- close 'coursenum' output group --->
				</cfoutput><!--- close 'CourseCategory' output group --->
               </tbody>
			</table><!-- end of 'crs-sched' table -->
		</div><!-- end 'thelist' div -->
		
		
		
		
			
		</div><!-- end 'outside' div -->
        
        
        
        
		<!--- They're in the current term and classes are open --->
        <cfif URL.tid EQ request.curtermid AND Now() GT Variables.preopen>
        
            <!--- what they must read --->
            <div id="mustread">
                Recommended reading prior to taking online classes at Chemeketa:
                <ul>
                	<li><a href="http://www.chemeketa.edu/aboutchemeketa/collegelife/studentrights/rights.html" title="Student Rights and Responsibilities" target="_blank">Student Rights and Responsibilities</a> </li>
                    <li><a href="http://online.chemeketa.edu/signature.htm" title="Notice Regarding Electronic Communications" target="_blank">Notice Regarding Electronic Communications</a> </li>
                    <li><a href="http://online.chemeketa.edu/know.htm" title="Technical Responsibility" target="_blank">Technical Responsibility</a> </li>
                </ul>
            </div><!--- end 'mustread' div --->
        
        </cfif>
		
		
		<script>
					$(document).ready(function() {
						$('a.course-info').one('mouseover', function() {
						var $dialog = $('<div style="font-size:smaller"></div>')
						//.html('loading…')
						.load($(this).attr('href') + ' #courseinfo')
						.dialog({
							autoOpen: false,
							title: $(this).html(),
							minWidth: 650,
							width: 700
							});
						$(this).click(function() {
						$dialog.dialog('open');
						// prevent the default action, e.g., following a link
						return false;
						});

																	});// end mouseover event function
						
					});//emd document.ready function
					</script>
		
        
</div><!-- end of 'classlistmain' div -->
