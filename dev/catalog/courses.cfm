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
<!--- get CourseID from URL.cnum
	<cfstoredproc datasource="#request.sqldsn#" procedure="get_course_id">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" null="No" maxlength="5" value="#URL.cpre#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" null="No" maxlength="8" value="#URL.cnum#">
		<cfprocresult name="cid">
	</cfstoredproc>
	--->
<div class="content">
	<div id="catalog">
		<h1>
			Course Descriptions | Index
		</h1>
		<ul id="crslist">
		<cfoutput query="categories" startrow="1" maxrows="#Int(categories.RecordCount)#">
		    <li id="catalog-#LCase(categories.CourseCat_ID)#-courses">
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
					<li id="#LCase(getCatCourses.cpre)##LCase(getCatCourses.cnum)#" data-catalog-course-sub="#getCatCourses.cpre#" data-catalog-course-num="#getCatCourses.cnum#" class="course #getCatCourses.cpre#">
                    	<a href="#request.webroot#course_descriptions/course-details.cfm?cpre=#getCatCourses.cpre#&cnum=#getCatCourses.cnum#" rel="bookmark prefetch">
                    	    <abbr class="course-id">#getCatCourses.CourseNum#</abbr>
                    	    <dfn class="course-title">#getCatCourses.CourseName#</dfn>
                    	</a>
                        
				    </li>
				</cfloop>
				</ul>
			</li>
        </cfoutput>
		</ul>
	</div>
</div>
<script>

$(document).ready(function() {

			$('a[rel]').one('mouseover', function() {
var courseId = $(this).parent('li').attr('id');

$(this).addClass('popup')
.parent('li')
.append(	$('<div id='+courseId + '-info class="hide">')
.load($(this).attr('href') + ' #' + courseId + '-details')	);
$(this).attr('href').value(courseId + '-info');

						});
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