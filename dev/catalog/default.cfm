<!--- 
	Template: default.cfm
	Author:	Thomas Bishop	
	
	Called by: ../default.htm (redirected), ../index.cfm (redirected)
	Calls: 
	Associated Templates: dsp_cat_page.cfm
	Includes: 
	Required Variables: 
			

	Passed Variables: 
			
	Purpose: 	I am the first page in the Online catalog showing all of the course categories
				(prefixes) with links to drill down to a particular subject/course.
				I utilize search engine friendly translation for URLs using IISAPI_Rewrite
	
	Date Created: unknown
	Modification History: 
		switched from included queries to Courses CFC method calls (2008-02-21)
		switched to div css layout (2008-04-08)
		added dynamic image switching (2010-11-16)
 --->
 
<!--- set up image switching per day of the month --->
<cfparam name="Variables.imgno" default="4">
<cfset i = Day(Now())>
<cfswitch expression="#Int(i MOD 4)#">
		<cfcase value="0">
			<cfset Variables.imgno = 4>
		</cfcase>
		<cfcase value="1">
			<cfset Variables.imgno = 5>
		</cfcase>
		<cfcase value="2">
			<cfset Variables.imgno = 6>
		</cfcase>
		<cfcase value="3">
			<cfset Variables.imgno = 3>
		</cfcase>
		<cfdefaultcase>
			<cfset Variables.imgno = 3>
		</cfdefaultcase>
	</cfswitch>


<!--- get all active categories --->
<cfinvoke component="edu.chemeketa.common.Courses" method="getCat" returnvariable="categories">
	<cfinvokeargument name="sortfield" value="Prefix">
</cfinvoke>

<div class="content">
	<div id="categories">
		<h1>
			Course Descriptions | Index
		</h1>
		<ul id="crslist">
		<cfoutput query="categories" startrow="1" maxrows="#Int(categories.RecordCount)#">
		    <li id="#LCase(categories.Prefix)#-list">
		        <a href="#request.webroot#catalog/#LCase(categories.Prefix)#/" class="subject"><abbr>#categories.Prefix#</abbr> <dfn>#Replace(categories.CourseCategory,"&","&amp;")#</dfn></a>
			</li>
        </cfoutput>
		</ul>
	</div>
</div>
