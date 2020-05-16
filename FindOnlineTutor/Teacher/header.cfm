<!---
Project Name: FindOnlineTutor.
File Name: header.cfm.
Created In: 15th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a header file which is included probably in Teacher section pages.
--->

<cfset batchServiceObject = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset myRequests = batchServiceObject.getMyRequests()/>
<cfset pendingRequest = 0/>
<cfif NOT structKeyExists(myRequests, "error")>
	<cfloop query="myRequests.requests">
		<cfif #requestStatus# EQ 'Pending'>
			<cfset pendingRequest = pendingRequest+1/>
		</cfif>
	</cfloop>
</cfif>
<cfif thistag.executionMode EQ 'start'>
	<!DOCTYPE html>
	<html lang="en" >
		<cfinclude  template="../Include/head.cfm">

		<body>
			<cfif structKeyExists(URL,'logout')>
				<cfset createObject("component",'FindOnlineTutor.Components.authenticationService').doLogout() />
				<cflocation  url="/assignments_mindfire/FindOnlineTutor/index.cfm">
			</cfif>
			<nav class="navbar navbar-expand-lg navbar-light p-3 mb-5">
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
							<a class="nav-link" href="../index.cfm">Home</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link" href="../teachers.cfm">Teachers</a>
						</li>
						<cfif structKeyExists(session, "stLoggedInUser") >
							<li class="nav-item mx-2">
								<a class="nav-link" href="batches.cfm">Your Batch</a>
							</li>

							<li class="nav-item mx-2">
								<cfif pendingRequest GT 0>
									<span class="notification-count float-right"><cfoutput>#pendingRequest#</cfoutput></span>
								</cfif>
								<a class="nav-link d-inline-block pr-0" href="request.cfm">Requests</a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link" href="students.cfm">Students</a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link" href="../profile.cfm">Profile</a>
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
			<cfinclude  template="../Include/footer.cfm">		
		</body>
	</html>
</cfif>
