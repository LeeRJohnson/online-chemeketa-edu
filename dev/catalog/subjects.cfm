<!--- 
	Template: subjects.cfm
	Author:	Lee Johnson
	
	Called by: ../default.htm (redirected), ../index.cfm (redirected)
	Calls: 
	Associated Templates: dsp_cat_page.cfm
	Includes: 
	Required Variables: 
			

	Passed Variables: 
			
	Purpose: 	I am the first page in the Online catalog showing all of the course categories
				(prefixes) with links to drill down to a particular subject/course.
				I utilize search engine friendly translation for URLs using IISAPI_Rewrite
	
	Date Created: 2011-8-10
	Modification History:
 --->

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
		    <li id="#LCase(categories.CourseCat_ID)#-list">
		        <a href="#request.webroot#catalog/#LCase(categories.Prefix)#/" class="subject"><abbr>#categories.Prefix#</abbr> <dfn>#Replace(categories.CourseCategory,"&","&amp;")#</dfn></a>
                <cftry>
                    <!--- we have only the prefix, need the category ID --->
                    <cfstoredproc datasource="#request.sqldsn#" procedure="get_cat_id">
                        <cfprocparam cfsqltype="CF_SQL_VARCHAR" maxlength="5" null="No" value="#categories.Prefix#">
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
                <ul>
				<cfloop query="getCatCourses">
					<li id="#LCase(getCatCourses.cpre)#-#LCase(getCatCourses.cnum)#" class="course">
					<cfif getCatCourses.Course_ID NEQ 142>
                    	<!--- <a href="#request.webroot#catalog/#LCase(getCatCourses.cpre)#/#LCase(getCatCourses.cnum)#" class="course" rel="##overlay"><img src="/global_images/plus.png" title="view details in overlay" /></a> --->
						<a href="#request.webroot#catalog/#LCase(getCatCourses.cpre)#/#LCase(getCatCourses.cnum)#" rel="bookmark prefetch"><abbr class="course-id">&nbsp;#getCatCourses.CourseNum#</abbr> - <dfn class="course-title">#getCatCourses.CourseName#</dfn></a>
					<cfelse>
						#getCatCourses.CourseNum# - #getCatCourses.CourseName#
					</cfif>
					<cfif getCatCourses.Course_ID EQ 142>
						&nbsp;See the <a href="dsp_cat_page.cfm?cat=58">NFM</a> course
					</cfif></li>
				</cfloop>
				</ul>
			</li>
        </cfoutput>
		</ul>
	</div>
</div>
