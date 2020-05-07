<!---
Project Name: FindOnlineTutor.
File Name: header.cfm.
Created In: 15th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a header file which is included probably in Teacher section pages.
--->
<cfif thistag.executionMode EQ 'start'>
	<!DOCTYPE html>
	<html lang="en" >
		<cfinclude  template="../Include/head.cfm">

		<body>
			<cfif structKeyExists(URL,'logout')>
				<cfset createObject("component",'FindOnlineTutor.Components.authenticationService').doLogout() />
				<cflocation  url="/assignments_mindfire/FindOnlineTutor/index.cfm">
			</cfif>
			<nav class="navbar navbar-expand-lg navbar-light shadow-sm p-3 mb-5 bg-light">
				<div class="container-fluid">
					<div class="navbar-header">
						<img  src="<cfoutput>#attributes.logoPath#</cfoutput>" class="img-fluid mr-2" alt="logo">
			      		<a class="navbar-brand" href="<cfoutput>#attributes.homeLink#</cfoutput>">FindOnlineTutor</a>
				    </div>
				  	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
					    <span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse " id="navbarSupportedContent">
					<ul class="navbar-nav ml-auto">
						<li class="nav-item mx-2">
							<a class="nav-link text-dark" href="../index.cfm">Home</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link text-dark" href="../teachers.cfm">Teachers</a>
						</li>
						<cfif structKeyExists(session, "stLoggedInUser") >
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="batches.cfm">Your Batch</a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="request.cfm">Requests<span class="text-warning">*</span></a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="students.cfm">Students</a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="../profile.cfm">Profile</a>
							</li>
							<li class="nav-item mx-2">
								<a class="btn button-color shadow text-white" href="/assignments_mindfire/FindOnlineTutor/index.cfm?logout">Logout</a>
							</li>
						</cfif>
					
					</ul>
					</div>
				</div>
			</nav>
			<div class="container">
            
			
	<cfelse>
			</div>	
			<div class="bg-secondary footer-copyright text-center text-light p-3"> © 2020 Copyright:
                <a class="text-light" href="https://192.168.43.32/assignments_mindfire/FindOnlineTutor/index.cfm"> FindOnlineTutor.com</a>
            </div>			
		</body>
	</html>
</cfif>
