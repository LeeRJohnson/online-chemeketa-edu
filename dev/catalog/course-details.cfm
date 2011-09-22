<cfsetting enablecfoutputonly="yes">
<!--- 
	Template: dsp_course_info.cfm
	Author:	Thomas Bishop	
	
	Called by: dsp_cat_page.cfm or dsp_class_info.cfm
	Calls: 
	Associated Templates: 
	Includes: 
	Required Variables: URL.CourseID
				
	Purpose: I display various information about a course (not class-specific)
	
	Date Created: unknown
	Modification History: 
		switched to using CFC: Courses getCourseInfo method (2008-02-24)
		added this comment block (2008-02-28)
		removed references to syllabus draft (2008-03-18)
		
		added Template for Fall tuition table (2008-05-27) by Lee Johnson
		added Unavailable notice to Term Class offerings (2008-06-05) by Lee J.
		moved Term Class Offerings above the Tuition for clarity of availability (2008-06-06)
		
		made Fall tuition table de facto (2008-07-30)
		condensed URL.CourseID validation (2008-08-08)
		cleaned up code and validated (2008-09-05)
		added back in the table for next term tuition (2009-03-25)
		commented out the regular Tuition and Fees table (2009-05-20)
		commented out link to course outline (2009-08-20)
		deleted link to course outline (2009-10-27)
		CRNs offered next term only appear if there are any (2009-10-27)
		made 'Tuition and Fees' strong (2009-10-27)
		added course prefix and course number URL translation (2010-02-19)
		removed reference to Summer Term 2010 (2010-06-15)
		included commented query result fields (2010-06-21)
		uncommented reference to Summer term fees (2011-05-02)
		uncommented Variables.thiscredit and displayed it with course title (2011-08-01)
 --->
<cfparam name="Variables.cid" default="0">
<!--- make sure the URL.CourseID is valid ---> 
<cfif 	IsDefined("URL.CourseID") AND 
		IsNumeric(URL.CourseID) AND
		Len(URL.CourseID) LT 13>
	<cfset Variables.cid = URL.CourseID>
<!--- if they are using course folder URL, test for that --->
<cfelseif IsDefined("URL.cnum") AND
		URL.cnum GT "" AND
		Len(URL.cnum) LT 13 AND
		IsDefined("URL.cpre") AND
		URL.cpre GT "">
	<!--- get CourseID from URL.cnum --->
	<cfstoredproc datasource="#request.sqldsn#" procedure="get_course_id">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" null="No" maxlength="5" value="#URL.cpre#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" null="No" maxlength="8" value="#URL.cnum#">
		<cfprocresult name="cid">
	</cfstoredproc>
	<cfif cid.RecordCount>
		<cfset Variables.cid = cid.Course_ID>
	<cfelse>
		<cfset Variables.cid = 0>
	</cfif>
<cfelseif IsDefined("Form.cid") AND
			IsNumeric(Form.cid)>
	<cfset Variables.cid = Form.cid>
<cfelse>
	<!--- they don't belong here - take them to the main catalog page --->
	<cflocation addtoken="No" url="http://learning.chemeketa.edu/">
</cfif><!--- end of URL if --->
	
	
<cfif IsDefined("URL.del")>
	<cfswitch expression="#URL.del#">
		<cfcase value="TE">
			<cfset Variables.delivery = "Telecourse">
			<cfset Variables.thefee = request.tefee>
		</cfcase>
		<cfcase value="OL">
			<cfset Variables.delivery = "Online">
			<cfset Variables.thefee = request.fee>
		</cfcase>
		<cfcase value="CTV">
			<cfset Variables.delivery = "CTV">
			<cfset Variables.thefee = 0>
		</cfcase>
		<cfdefaultcase>
			<cfset Variables.delivery = "Online">
			<cfset Variables.thefee = request.fee>
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cfset Variables.delivery = "Online">
	<cfset Variables.thefee = request.fee>
</cfif><!--- end of 'URL.del' if --->

<cfparam name="Variables.workingterm" default="#request.curtermid#" type="numeric">

<cfif Now() LT DateAdd("w",1,request.thistermstart)>
	<!--- it's too early to be thinking about next term --->
	<cfset Variables.workingterm = request.curtermid>
<cfelse>
	<cfset Variables.workingterm = Int(request.curtermid + 1)>
</cfif><!--- end of 'Now()' if --->

<!--- get course info --->
<cfinvoke	component="edu.chemeketa.common.Courses" 
			method="getCourseInfo" 
			returnvariable="courseinfo">
	<cfinvokeargument name="cid" value="#Variables.cid#">
</cfinvoke><!--- CourseCat_ID, 
				CourseNum, 
				CourseName, 
				CourseDescrip, 
				PreReq1, 
				LecHours, 
				LabHourse,
				LabCredit, 
				LecCredit, 
				Course_ID,
				CourseCategory,
				Notes --->

<cfif courseinfo.RecordCount AND IsNumeric(courseinfo.LabCredit) AND IsNumeric(courseinfo.LecCredit)>
	<cfset Variables.thiscredit = Int(courseinfo.LabCredit + courseinfo.LecCredit)>
<cfelseif courseinfo.RecordCount AND IsNumeric(courseinfo.LecCredit)>
	<cfset Variables.thiscredit = Int(courseinfo.LecCredit)>
<cfelse>
	<cfset Variables.thiscredit = 0>
</cfif>

<!--- get recent instructors for this course --->
<cfinvoke	component="edu.chemeketa.common.Instructors" 
			method="getRecentInstructors" 
			returnvariable="instructors">
	<!--- look for instructors from the past 5 terms --->		
	<cfinvokeargument name="termid" value="#Int(request.curtermid - 4)#">
	<cfinvokeargument name="courseid" value="#Variables.cid#">
</cfinvoke>

<!--- get recent yearly terms (F,W,Sp,Su) for this course --->
<cfinvoke component="edu.chemeketa.common.Courses" method="getCourseTerms" returnvariable="result">
	<cfinvokeargument name="cid" value="#Variables.cid#">
	<cfinvokeargument name="termsback" value="8"><!--- past 2 years --->
</cfinvoke>

<!--- get next term's CRNs for this course if available --->
<cfinvoke	component="edu.chemeketa.common.Courses" 
			method="getClassCRNs" 
			returnvariable="crns">
	<!--- if it is before a week into the current term, show current term, otherwise show next term --->
	<cfinvokeargument name="termid" value="#Variables.workingterm#">
	<cfinvokeargument name="courseid" value="#Variables.cid#">
	<cfinvokeargument name="commondelivery" value="true">
	<cfinvokeargument name="includeinst" value="true">
</cfinvoke>

<!--- get next term's TermText --->
<cfinvoke	component="edu.chemeketa.common.Term" 
			method="getTermData" 
			returnvariable="nextterm">
	<cfinvokeargument name="termid" value="#Variables.workingterm#">
</cfinvoke>

<!--- make sure we have a 'cpre' value to return to the category page --->
<cfinvoke	component="edu.chemeketa.common.Courses" 
			method="getCpreCnum" 
			returnvariable="prenum">
	<cfinvokeargument name="cid" value="#Variables.cid#">
</cfinvoke><!--- now we have prenum.cpre and prenum.cnum --->


<!--- display content --->
<cfsetting enablecfoutputonly="no">
<cfoutput>
<div id="content" >

    <header>
        <p id="brdcrms"><a href="//online.chemekta.edu">CHemeketa Online</a> |
        <a href="#request.webroot#catalog/">Course Catalog</a> |
        <a href="#request.webroot#catalog/#LCase(prenum.cpre)#/">#courseinfo.CourseCategory#</a></p>
        <h1>
        <cfif IsDefined("courseinfo.CourseNum") AND courseinfo.CourseNum GT "">#courseinfo.CourseNum#<cfelseif IsDefined("URL.cpre") AND IsDefined("URL.cnum")>#URL.cpre##URL.cnum#<cfelse>--</cfif>
        </h1>
    </header><!--- end of titlebox div --->
    <div id="#courseinfo.CourseNum#-details">
        <p class="course-description">#courseinfo.CourseDescrip#</p>
        <p class="course-readme">#courseinfo.Notes#</p>
        <dl>
             <dt>credits</dt><dd>#Variables.thiscredit#</dd>
        <cfif courseinfo.PreReq1 GT "" AND courseinfo.CourseDescrip DOES NOT CONTAIN "Prerequisite:">
            <dt>Prerequisite:</dt><dd>#courseinfo.PreReq1#</dd>
        </cfif><!--- end of 'courseinfo.PreReq1' if --->
        <cfif IsDefined("result") AND result GT "">
            <dt>Terms offered online: </dtt<dd>#result#</dd>
        </cfif><!--- end of 'result' if --->
        </dl>
        <cfif IsDefined("crns.RecordCount") AND crns.RecordCount GT 0>
        <div class="course-offerings">
            <h2><abbr title="Course Reference Number">CRN</abbr>s for this course during the coming term:</h2>
            <h3><a href="#request.webroot#dsp_class_info.cfm?h=0&tid=#nextterm.Term_ID####Variables.cid#"><strong>#nextterm.TermText#</strong></a></h3>
            <cfset count = 0>
            <ul>
            <cfloop query="crns">
                <cfset count = count + 1>
                <li class="course-section" title="#crns.LName#">#crns.CRN#</li>
            </cfloop><!--- end of 'crns' query loop --->
            </ul>
        </div><!--- end of classofferings div (option 2) --->
        </cfif><!--- end of 'crns.RecordCount' if --->
    </div>
</cfoutput>
    <div class="course-instructors">
            <h3>Instructors who have taught this course during the past year.</h3>
            <ul>
        <cfoutput query="instructors">
        <li>
            <cfif Trim(instructors.Email1) GT "">
                <a href="#request.webroot#instructor/#instructors.Instructor_ID#/default.htm">#instructors.FName# #instructors.LName#</a>
            <cfelse>
                #instructors.FName# #instructors.LName#
            </cfif><!--- end of 'instructors.Email1' if --->
            </li>
        </cfoutput>
        </ul>
    </div><!--- end of courseinstructors table --->

    </div><!--- end of courseinfo table --->
</div><!--- end of content div --->
<br clear="all" />
