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
<div class="content">
<div id="titlebox">
	<span id="brdcrms"><a href="#request.webroot#catalog/">Course Descriptions</a> | <a href="#request.webroot#catalog/#LCase(prenum.cpre)#/">#courseinfo.CourseCategory#</a> | <cfif IsDefined("courseinfo.CourseNum") AND courseinfo.CourseNum GT "">#courseinfo.CourseNum#<cfelseif IsDefined("URL.cpre") AND IsDefined("URL.cnum")>#URL.cpre##URL.cnum#<cfelse>--</cfif></span>
</div><!--- end of titlebox div --->
<table id="courseinfo" summary="contains header, course description, prerequisites, credits and fees, and other links specific to the course">
<cfif courseinfo.Notes CONTAINS "NOW OFFERED AS">
	<tr>
		<td><span class="readme">#courseinfo.Notes#</span></td>
	</tr>
</cfif><!--- end of 'now offered as' if --->
	<tr> 
    	<td valign="top" width="320"><!--- left column --->
      	<p class="normal"><strong><cfif IsDefined("courseinfo.CourseNum") AND courseinfo.CourseNum GT "">#courseinfo.CourseNum#<cfelseif IsDefined("URL.cpre") AND IsDefined("URL.cnum")>#URL.cpre##URL.cnum#<cfelse>--</cfif></strong> [#Variables.thiscredit# credit<cfif Variables.thiscredit NEQ 1>s</cfif>]<br /><strong>#courseinfo.CourseName#</strong><br />#courseinfo.CourseDescrip#</p>
<cfif courseinfo.PreReq1 GT "" AND courseinfo.CourseDescrip DOES NOT CONTAIN "Prerequisite:">
		<p class="normal"><strong>Prerequisite:</strong>&nbsp;#courseinfo.PreReq1#</p>
</cfif><!--- end of 'courseinfo.PreReq1' if --->
	
<cfif IsDefined("result") AND result GT "">
		<p class="normal"><strong>Terms offered online: </strong>#result#</p>
</cfif><!--- end of 'result' if --->
<cfif IsDefined("crns.RecordCount") AND crns.RecordCount GT 0>
	<div id="classofferings">
		<p class="normal">Online <abbr title="Course Reference Number">CRN</abbr>s for this course during the coming term:<br /> <a href="#request.webroot#dsp_class_info.cfm?h=0&tid=#nextterm.Term_ID####Variables.cid#"><strong>#nextterm.TermText#</strong></a><br />
		<cfset count = 0>
		<cfloop query="crns">
			<cfset count = count + 1>
			<span class="help" title="#crns.LName#">#crns.CRN#</span><cfif count LT crns.RecordCount>, </cfif>
		</cfloop><!--- end of 'crns' query loop --->
		</p>
	</div><!--- end of classofferings div (option 2) --->
</cfif><!--- end of 'crns.RecordCount' if --->
<cfif Left(courseinfo.CourseNum,3) EQ "XRE"><!--- Real Estate Workshops --->
		Credits: Non Credit
<cfelseif Left(courseinfo.CourseNum,4) EQ "XGED"><!--- GED Transition to College FEE??--->
		Credits: Non Credit
<cfelseif Left(courseinfo.CourseNum,3) EQ "XHS"><!--- Practical Writing FEE??--->
		Credits: Non Credit
<cfelseif Left(courseinfo.CourseNum,4) EQ "XNUR"><!--- Nursing Refresher FEE??--->
		Credits: Non Credit
<cfelseif Left(courseinfo.CourseNum,3) EQ "XHD"><!--- Anger Management FEE??--->
		Credits: Non Credit
<cfelseif courseinfo.CourseNum EQ "XHTM9900D"><!--- Foodhandler Workshop --->
		Credits: Non Credit<br />
		<strong>Tuition and Fees</strong>: $#request.foodcost#
<cfelseif courseinfo.CourseNum EQ "XECE9900K"><!--- Child Abuse Prevention Workshop --->
		Credits: Non Credit<br />
		<strong>Tuition and Fees</strong>: #DollarFormat(20 + (request.uafnc * (courseinfo.LecHours + courseinfo.LabHourse)))#
<cfelseif 	courseinfo.CourseNum EQ "XCS0001A" OR
			courseinfo.CourseNum EQ "XBA9503B" OR
			courseinfo.CourseNum EQ "XBA9503C" OR
			courseinfo.CourseNum EQ "XBA9503X" OR
			courseinfo.CourseNum EQ "XWR0512B"><!--- Online Orientation, Employee Dev. Seminars, or CWC --->
		Credits: 0<br />
		<strong>Tuition and Fees</strong>: $0
<cfelse>
	<cfif courseinfo.RecordCount>
		<p class="normal"><strong>Tuition and Fees</strong></p>
		<dl>
			<dt>Online Fee per class</dt>
			<dd>$50</dd>
			<dt>Tuition and other fees</dt>
			<dd>see the college <a href="http://www.chemeketa.edu/earncertdegree/tuition/" target="_blank">Tuition &amp; Fees</a> page</dd>			
		</dl>
		<!--- <cfset Variables.thiscredit = Int(courseinfo.LabCredit + courseinfo.LecCredit)>
		<cfset Variables.thistuition = Int(request.tuition * Int(courseinfo.LabCredit + courseinfo.LecCredit))>
		<cfset Variables.thisuaf = Int((courseinfo.LabCredit + courseinfo.LecCredit) * request.uaf)>
		<cfset Variables.thisssfee = (courseinfo.LabCredit + courseinfo.LecCredit) * request.ssfee>
		<cfset Variables.total = Variables.thistuition + Variables.thefee + Variables.thisuaf + Variables.thisssfee>
		<table id="coursetuition"><!--- Tuition Table --->
			<caption><strong>Tuition and Fees</strong><br /> (see the college <a href="http://www.chemeketa.edu/earncertdegree/tuition/" target="_blank">Tuition &amp; Fees</a> page for more information)</caption>
			<tr>
				<th>Credits&nbsp;</th>
				<th>Tuition&nbsp;</th>
				<th>#Variables.delivery#&nbsp;Fee&nbsp;</th>
				<th>Universal&nbsp;Access&nbsp;Fee&nbsp;</th>
				<!--- <th>Student&nbsp;Services&nbsp;Fee&nbsp;</th> --->
			</tr>
			<tr>
				<td>#Variables.thiscredit#</td>
				<td><span class="help" title="$#request.tuition# per credit">#DollarFormat(Variables.thistuition)#</span></td>
				<td>#DollarFormat(Variables.thefee)#</td>
				<td><span class="help" title="#DollarFormat(request.uaf)# per credit">#DollarFormat(Variables.thisuaf)#</span></td>
				<!--- <td><span class="help" title="#DollarFormat(request.ssfee)# per credit">#DollarFormat(Variables.thisssfee)#</span></td> --->
			</tr>
		</table><!--- end of Tuition Table --->
		<cfif Variables.total GT 0>
			<p class="tuitiondisclaimer">This table does not include any special class fees or the cost of textbooks.</p>
		</cfif><!--- end of 'Variables.total' if --->
		 --->
		
		
		<!--- include changes for next term --->
		<!--- 
		<cfset Variables.nextcredit = Int(courseinfo.LabCredit + courseinfo.LecCredit)>
		<cfset Variables.nexttuition = Int(request.nexttuition * Int(courseinfo.LabCredit + courseinfo.LecCredit))>
		<cfset Variables.nextuaf = Int((courseinfo.LabCredit + courseinfo.LecCredit) * request.uafnext)>
		<cfset Variables.nextssfee = (courseinfo.LabCredit + courseinfo.LecCredit) * request.ssfeedefunct>
		<cfset Variables.nexttotal = Variables.nexttuition + Variables.thefee + Variables.nextuaf + Variables.nextssfee>
		<table id="coursetuition2"><!--- Next Term Tuition Table --->
			<caption>Tuition and Fees starting <span style="font-weight: bold; color: Teal;">Summer Term 2011</span><br /> (see the college <a href="http://www.chemeketa.edu/earncertdegree/tuition/" target="_blank">Tuition &amp; Fees</a> page for more information)</caption>
			<tr>
				<th>Credits&nbsp;</th>
				<th>Tuition&nbsp;</th>
				<th>#Variables.delivery#&nbsp;Fee&nbsp;</th>
				<th>Universal&nbsp;Access&nbsp;Fee&nbsp;</th>
			</tr>
			<tr>
				<td>#Variables.nextcredit#</td>
				<td><span class="help" title="$#request.nexttuition# per credit">#DollarFormat(Variables.nexttuition)#</span></td>
				<td>#DollarFormat(Variables.thefee)#</td>
				<td><span class="help" title="#DollarFormat(request.uafnext)# per credit">#DollarFormat(Variables.nextuaf)#</span></td>
			</tr>
		</table>
		<!--- end of Next Term Tuition Table --->
		<cfif Variables.total GT 0>
			<p class="tuitiondisclaimer">This table does not include any special class fees or the cost of textbooks.</p>
		</cfif>
		 --->
	<cfelse>
		No record found.
	</cfif><!--- end of courseinfo.recordcount if --->
</cfif><!--- end of coursenum if --->
			<!--- end of left column --->
			

			</cfoutput>
			<cfif instructors.RecordCount GT 0>
				<!--- if this course has been taught recently, list instructors --->
				<div class="instructors"
						<p class="b">Instructors who have taught this course during the past year.</p>
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
					</ul><p>
			<a href="http://www.chemeketa.edu/started/register.html" target="_blank" class="nowrap">How to Register</a> <br />
			<a href="http://bookstore.chemeketa.edu/" target="_blank" class="nowrap">Buy the book</a></p></td>
					</div><!--- end of courseinstructors table --->
			</cfif><!--- end of instructors.recordcount if --->
		</div><!--- end of courseinfo table --->
</div><!--- end of content div --->
<br clear="all" />
