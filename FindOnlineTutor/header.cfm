<!---
Project Name: FindOnlineTutor.
File Name: header.cfm.
Created In: 28th Mar 2020
Created By: Rajendra Mishra.
Functionality: It is a header file which is included probably in every pages.
--->
<cfset batchServiceObject = createObject("component","FindOnlineTutor.Components.batchService")/>
<!---if user is a Teacher--->
<cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
	<cfset myRequests = batchServiceObject.getMyRequests()/>
	<cfset pendingRequest = 0/>
	<cfif NOT structKeyExists(myRequests, "error")>
		<cfloop query="myRequests.requests">
			<cfif #requestStatus# EQ 'Pending'>
				<cfset pendingRequest = pendingRequest+1/>
			</cfif>
		</cfloop>
	</cfif>
<!---if user is a student--->
<cfelseif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student'>
	<cfset myNotification = batchServiceObject.getMyNotification()/>
	<cfset newNotification = 0/>
	<cfif NOT structKeyExists(myNotification, "error")>
		<cfloop query="myNotification.Notifications">
			<cfif NOT #notificationStatus#>
				<cfset newNotification = newNotification+1/>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif thistag.executionMode EQ 'start'>
	<!DOCTYPE html>
	<html lang="en" >
		<cfinclude  template="Include/head.cfm">

		<body>
			<!---if logout button is clicked--->
			<cfif structKeyExists(URL,'logout')>
				<cfset createObject("component",'FindOnlineTutor.Components.authenticationService').doLogout() />
				<cflocation  url="/assignments_mindfire/FindOnlineTutor/index.cfm">
			</cfif>
			<!---navbar start from here--->
			<nav class="navbar navbar-expand-lg navbar-light p-3 navFix">
				<div class="container-fluid">
					<div class="navbar-header">
						<img  src="<cfoutput>#attributes.logoPath#</cfoutput>" class="img-fluid mr-2" alt="logo"/>
			      		<a class="navbar-brand" href="<cfoutput>#attributes.homeLink#</cfoutput>">FindOnlineTutor</a>
				    </div>
				  	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
					    <span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse " id="navbarSupportedContent">
					<ul class="navbar-nav ml-auto">
						<li class="nav-item mx-2">
							<a class="nav-link" href="index.cfm">Home</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link" href="teachers.cfm">Teachers</a>
						</li>
						<!---if the user is not a teacher but student or visitor--->
						<cfif NOT structKeyExists(session, "stLoggedInUser") OR session.stLoggedInUser.role EQ 'Student'>
							<li class="nav-item mx-2">
								<a class="nav-link" href="searchResult.cfm">Find Batch</a>
							</li>
						</cfif>
						
						<!---if user is logged in--->
						<cfif structKeyExists(session, "stLoggedInUser") >
							<li class="nav-item mx-2">
								<a class="nav-link" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/batches.cfm">Your Batch</a>
							</li>
							
							<!---teacher's facilities start here--->
							<cfif session.stLoggedInUser.role EQ 'Teacher'>
								<li class="nav-item mx-2">
									<cfif pendingRequest GT 0>
										<span class="notification-count float-right"><cfoutput>#pendingRequest#</cfoutput></span>
									</cfif>
									<a class="nav-link d-inline-block pr-0" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/request.cfm">Requests</a>
								</li>
								<li class="nav-item mx-2">
									<a class="nav-link" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/students.cfm">Students</a>
								</li>
							</cfif>
							<!---teacher's faclities end here--->

							
							<!---student's faclities starts here--->
							<cfif session.stLoggedInUser.role EQ 'Student'>
								<li class="nav-item mx-2">
									<cfif newNotification GT 0>
										<span class="notification-count float-right"><cfoutput>#newNotification#</cfoutput></span>
									</cfif>
									<a class="nav-link d-inline-block pr-0" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/notification.cfm">Notification</a>
								</li>
								
							</cfif>
							<!---student's faclities ends here--->

							<li class="nav-item mx-2">
								<a class="nav-link" href="profile.cfm">Profile</a>
							</li>
							<li class="nav-item mx-2">
								<a class="btn button-color shadow text-white" href="/assignments_mindfire/FindOnlineTutor/index.cfm?logout">Logout</a>
							</li>
						<!---if user is not logged in--->
						<cfelse>
							<li class="nav-item mx-2">
								<a class="nav-link" href="login.cfm">LogIn</a>
							</li>
							<li class="nav-item mx-2">
								<a class="btn button-color shadow text-white" href="signup.cfm">Register</a>
							</li>
						</cfif>
					
					</ul>
					</div>
				</div>
			</nav>
			<div class="mt-5 pt-5 min-height">
	<cfelse>	
			</div>
			<cfinclude  template="Include/footer.cfm">	
		</body>
	</html>
</cfif>
