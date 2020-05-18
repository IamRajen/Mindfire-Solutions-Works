<!---
Project Name: FindOnlineTutor.
File Name: index.cfm.
Created In: 28th Mar 2020
Created By: Rajendra Mishra.
Functionality: This is the homepage.
--->
<cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset local.profileServiceObj = createObject("component","FindOnlineTutor.Components.profileService")/>
<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm">
	<div class="container-fuild">
		<!---including the search bar with trending words--->
		<cfinclude  template="Include/searchForm.cfm">
		
		<div class="w-100 text-center my-3">

			<cfif structKeyExists(session, "stloggedinUser") AND session.stloggedinUser.role EQ 'Teacher'>
				
				<cfset local.teacherInfo = local.profileServiceObj.getTeacherInfo()>
					
				<cf_card title="Batch" description="Number of batches you created" data="#local.teacherInfo.batchCount.batch#" link="">
				<cf_card title="Student" description="Number of students you have" data="#local.teacherInfo.studentCount.enrolledStudents.recordCount#" link="">
				<cf_card title="Request" description="Number of request you got till now" data="#local.teacherInfo.requestCount.requests.recordCount#" link="">
			
			
			<cfelse>
				<cfset local.ourDetails = local.batchServiceObj.getOurDetails()/>
				<cf_card title="Teacher" description="Number of teacher's we have" data="#local.ourDetails.teacher.user#" link="">
				<cf_card title="Student" description="Number of student's we have" data="#local.ourDetails.student.user#" link="">
				<cf_card title="Batch" description="Number of batches we have" data="#local.ourDetails.batch.batch#" link="">
			</cfif>	
		</div>
	</div>
</cf_header>	


<!---
	<div class="row mt-5 container">
		<div class="col-md-4"> 
			<h3>Q. What is Relationship between Teacher and Student?</h3>
			<p>Positive teacher-student relationships are very important for quality teaching and student learning.</p>
		</div>
		<div class="col-md-4">
			<h3>Q. What do you mean by teacher-student relationships?</h3>
			<p>According to our view, student-teacher relationships can be just like a friend who try to understand our problems very well and help us to try to solve it.</p>
		</div> 

		<div class="col-md-4"> 
			<h3>Q. How will it be able to build up such a relation?</h3> 
			<p>It is very easy to build up a very good teacher and student relationship after knowing each other properly.</p>
		</div>

		<div class="col-md-4"> 
			<h3>Q. Do student-teacher relationships help in any way?</h3> 
			<p>Surely student-teacher relationships can help the teacher in many ways. Having a very good relationship with a teacher will make us free from tensions, worries, etc.</p> 
		</div>

		<div class="col-md-4"> 
			<h3>Q. Who can help us in great difficulty? Either a teacher or a best friend?</h3> 
			<p>.According to me, a teacher can help us in great difficulties than a best friend. When we face great difficulties a friend can only console us they can�t do anything more. Whereas a teacher will stand along with us</p> 
		</div> 

		<div class="col-md-4"> 
			<h3>Q. Now the Question Came what does our website do?</h3>
			<p>It's Just helps this Relation to grow it to Next level.</p>
		</div>
	</div>
--->