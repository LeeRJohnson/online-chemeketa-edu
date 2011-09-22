<!--- 
	Template: dsp_cat_page.cfm
	Author:	Thomas Bishop	
	
	Called by: default.cfm, other links
	Calls: 
	Associated Templates: dsp_course_info.cfm
	Includes: 
	Required Variables: URL.cat
			

	Passed Variables: getCatCourses.cpre, getCatCourses.cnum (in dynamic URLs)
			
	Purpose: Display all courses in a particular category (prefix)
	
	Date Created: unknown
	Modification History: 
		switched to using CFC: Courses getCat method (2007-12-28)
		added this comment block (2008-02-27)
		added call to get cpre and cnum from CFC/SP for new URL (2010-03-08)
		added style and code to make JQueryTools overlays for course detail (2010-06-29)
		removed links to overlays because they started coming up blank - worked yesterday! (2010-06-30)
 --->

<cfif IsDefined("URL.cat") AND IsNumeric(URL.cat)>
	<cftry>
		<cfstoredproc datasource="#request.sqldsn#"
					procedure="get_category_courses"><!--- takes 2 params: the category ID, and past term ID how far back to search  --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" maxlength="5" null="No" value="#URL.cat#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" maxlength="5" null="No" value="#Int(request.curtermid - 12)#"><!--- course must have been offered within past 3 years --->
			<cfprocresult name="getCatCourses">
			<!---	Course_ID, CourseNum, CourseName, CourseCat_ID, 
					CourseCategory, COURSES_ID_FK, DELIVERY_MODE_ID_FK --->
		</cfstoredproc>
	<cfcatch type="Database">
		ERROR: There was a database error when executing your request. Please do not manually enter anything into the URL.
		<cfabort>
	</cfcatch>
	</cftry>
	
	<cfset Variables.catid = URL.cat>
	
<cfelseif IsDefined("URL.prefix") AND URL.prefix GT "">
	<cftry>
		<!--- we have only the prefix, need the category ID --->
		<cfstoredproc datasource="#request.sqldsn#" procedure="get_cat_id">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" maxlength="5" null="No" value="#URL.prefix#">
			<cfprocresult name="cat">
		</cfstoredproc>
		
		<cfstoredproc datasource="#request.sqldsn#"
					procedure="get_category_courses"><!--- takes 2 params: the category ID, and past term ID how far back to search  --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" maxlength="5" null="No" value="#cat.CourseCat_ID#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" maxlength="5" null="No" value="#Int(request.curtermid - 12)#"><!--- course must have been offered within past 3 years --->
			<cfprocresult name="getCatCourses">			
			<!---	Course_ID, CourseNum, cpre, cnum, CourseName, CourseCat_ID, 
					CourseCategory, COURSES_ID_FK, DELIVERY_MODE_ID_FK --->
		</cfstoredproc>
	<cfcatch type="Database">
		<cfoutput>#cfcatch.detail#</cfoutput>
		ERROR: There was a database error when executing your request. Please do not manually enter anything into the URL.
		<cfabort>
	</cfcatch>
	</cftry>
	<cfset Variables.catid = cat.CourseCat_ID>
<cfelse>
	<cflocation url="#request.webroot#catalog/" addtoken="No">
	<cfabort>
</cfif>

	
	<!--- get information on this category --->
	<cfinvoke component="edu.chemeketa.common.Courses" method="getCat" returnvariable="getCat">
		<cfinvokeargument name="catid" value="#Variables.catid#">
	</cfinvoke>
	
	<!--- begin content --->
	<div class="content">
	<div id="titlebox">
		<cfoutput>
		<span id="brdcrms"><a href="http://online.chemeketa.edu/">Home</a> | <a href="#request.webroot#catalog/">Course Descriptions</a> | #getCat.CourseCategory#</span> 
		</cfoutput>
	</div>
	<!--- Is this for Hospitality and Tourism Management? --->
	<cfif Variables.catid EQ "34">
		<p class="normalpadded">See also: <a href="http://www.htmprograms.com/">Click here for the Hospitality and Tourism Management department's website at <strong>www.htmprograms.com</strong></a></p>	
	</cfif>

			<cfif getCatCourses.RecordCount GT 0>
				<cfoutput>
				<ul>
				<cfloop query="getCatCourses">
					<li class="normalpadded">
					<cfif getCatCourses.Course_ID NEQ 142>
                    	<!--- <a href="#request.webroot#catalog/#LCase(getCatCourses.cpre)#/#LCase(getCatCourses.cnum)#" class="course" rel="##overlay"><img src="/global_images/plus.png" title="view details in overlay" /></a> --->
						<a href="#request.webroot#catalog/#LCase(getCatCourses.cpre)#/#LCase(getCatCourses.cnum)#" class="course">&nbsp;#getCatCourses.CourseNum# - #getCatCourses.CourseName#</a>
					<cfelse>
						#getCatCourses.CourseNum# - #getCatCourses.CourseName#
					</cfif>
					<cfif getCatCourses.Course_ID EQ 142>
						&nbsp;See the <a href="dsp_cat_page.cfm?cat=58">NFM</a> course
					</cfif></li>
				</cfloop>
				</ul>
				</cfoutput>
			<cfelse>
				<p class="normal">No courses are currently offered in this category.</p>
			</cfif>
			<cfoutput>
            <div class="captioned_photo">
			<img src="/datacol/assets/#LCase(getcat.Prefix)#_sm.jpg" alt="image relating to subject" title="image relating to subject" />
            <p><span>#getCat.CourseCategory#</span></p>
            </div>
			</cfoutput>
	</div>