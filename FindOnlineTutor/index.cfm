<!---
Project Name: FindOnlineTutor.
File Name: index.cfm.
Created In: 28th Mar 2020
Created By: Rajendra Mishra.
Functionality: This is the homepage.
--->
<!---creating object's for data retrival--->
<cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset local.profileServiceObj = createObject("component","FindOnlineTutor.Components.profileService")/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm">
	<div class="container-fuild">
		
		<div class="w-100 text-center my-3">
			<cfif structKeyExists(session, "stloggedinUser") AND session.stloggedinUser.role EQ 'Teacher'>
				<cfset local.teacherInfo = local.profileServiceObj.getTeacherInfo()>

				<cf_card title="Batch" description="Number of batches you created" data="#local.teacherInfo.batchCount.value#" link="">
				<cf_card title="Student" description="Number of students you have" data="#local.teacherInfo.studentCount.recordCount#" link="">
				<cf_card title="Request" description="Number of request you got till now" data="#local.teacherInfo.requestCount.recordCount#" link="">

			<cfelse>
				<!---including the search bar with trending words--->
				<cfinclude  template="Include/searchForm.cfm">
				<cfset local.ourDetails = local.batchServiceObj.getOurDetails()/>
				<cf_card title="Teacher" description="Number of teacher's we have" data="#local.ourDetails.teacher.value#" link="">
				<cf_card title="Student" description="Number of student's we have" data="#local.ourDetails.student.value#" link="">
				<cf_card title="Batch" description="Number of batches we have" data="#local.ourDetails.batch.value#" link="">
				
			</cfif>	
		</div>
	</div>
</cf_header>	
