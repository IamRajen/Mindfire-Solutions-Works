<!---
Project Name: FindOnlineTutor.
File Name: index.cfm.
Created In: 28th Mar 2020
Created By: Rajendra Mishra.
Functionality: This is the homepage.
--->
<cfset batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm">

<div class="container-fuild">

	<cfinclude  template="Include/searchForm.cfm">

	<hr>
	<cfif structKeyExists(session, "stloggedinUser")>
		<cfif session.stloggedinUser.role EQ 'Teacher'>
			<!---the teacher includes will be included--->
			<div class="h-50 bg-light my-3">
				<h4 class="float-right text-dark p-2">Welcome, <cfoutput>#session.stLoggedInUser.firstName#</cfoutput></h4>
			</div>
			<cf_card title="Batches" description="Number of batches you created" data="4" link="Teacher/batches.cfm">
			
			<cf_card title="Students" description="Number of students you have" data="20" link="Teacher/students.cfm">
			
		<cfelseif session.stloggedinUser.role EQ 'Student'>
			<!---the student includes will be included--->

			<div class="h-50 bg-light my-3">
				<h4 class="float-right text-dark p-2">Welcome, <cfoutput>#session.stLoggedInUser.firstName#</cfoutput></h4>
			</div>
			<cf_card title="Batches" description="Number of batches you created" data="4" link="Teacher/batches.cfm">
			
			<cf_card title="Students" description="Number of students you have" data="20" link="Teacher/students.cfm">
		</cfif>

	</cfif>

</div>
</cf_header>	



<!-- <div class="row mt-5"> -->
<!-- 			<div class="col-md-4"> -->
<!-- 				<h3>Q. What is Relationship between Teacher and Student?</h3> -->
<!-- 				<p>Positive teacher-student relationships are very important for quality teaching and student learning.</p> -->
<!-- 			</div> -->

<!-- 		    <div class="col-md-4"> -->
<!-- 				<h3>Q. What do you mean by teacher-student relationships?</h3> -->
<!-- 		    	<p>According to our view, student-teacher relationships can be just like a friend who try to understand our problems very well and help us to try to solve it.</p> -->
<!-- 		    </div> -->

<!-- 			<div class="col-md-4"> -->
<!-- 				<h3>Q. How will it be able to build up such a relation?</h3> -->
<!-- 		    	<p>It is very easy to build up a very good teacher and student relationship after knowing each other properly.</p> -->
<!-- 		    </div> -->

<!-- 			<div class="col-md-4"> -->
<!-- 				<h3>Q. Do student-teacher relationships help in any way?</h3> -->
<!-- 		    	<p>Surely student-teacher relationships can help the teacher in many ways. Having a very good relationship with a teacher will make us free from tensions, worries, etc.</p> -->
<!-- 		    </div> -->

<!-- 			<div class="col-md-4"> -->
<!-- 				<h3>Q. Who can help us in great difficulty? Either a teacher or a best friend?</h3> -->
<!-- 		    	<p>.According to me, a teacher can help us in great difficulties than a best friend. When we face great difficulties a friend can only console us they can�t do anything more. Whereas a teacher will stand along with us</p> -->
<!-- 		    </div> -->

<!-- 			<div class="col-md-4"> -->
<!-- 				<h3>Q. Now the Question Came what does our website do?</h3> -->
<!-- 		    	<p>It's Just helps this Relation to grow it to Next level.</p> -->
<!-- 		    </div> -->
<!-- 	  	</div> -->

<!---
<div class="container mt-5 mb-5">
			<div class="row mt-5">
				<div class="col-sm-6 d-flex justify-content-center mb-5">
					<a href="Teacher/batches.cfm" type="button" class="section-div bg-light w-75 shadow">
						<h1 class="text-center mt-4 text-dark">Batches</h1>
					</a>	
				</div>
				<div class="col-sm-6 d-flex justify-content-center mb-5">
					<a href="profile.cfm" type="button" class="section-div bg-light w-75 shadow">
						<h1 class="text-center mt-4 text-dark">Profile</h1>
					</a>
				</div>
			</div>
			<div class="row mt-5">
				<div class="col-sm-6 d-flex justify-content-center mb-5">
					<a type="button" class="section-div bg-light w-75 shadow">
						<h1 class="text-center mt-4 text-dark">Notifications</h1>
					</a>	
				</div>
				<div class="col-sm-6 d-flex justify-content-center mb-5">
					<a type="button" class="section-div bg-light w-75 shadow">
						<h1 class="text-center mt-4 text-dark">Students</h1>
					</a>
				</div>
			</div>
		</div>

--->