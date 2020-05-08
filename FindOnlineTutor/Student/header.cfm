<!---
Project Name: FindOnlineTutor.
File Name: header.cfm.
Created In: 26th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a header file which is included probably in student section pages.
--->

<cfset batchServiceObject = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset myNotification = batchServiceObject.getMyNotification()/>
<cfset newNotification = 0/>
<cfif NOT structKeyExists(myNotification, "error")>
	<cfloop query="myNotification.Notifications">
		<cfif NOT #notificationStatus#>
			<cfset newNotification = newNotification+1/>
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
			<nav class="navbar navbar-expand-lg navbar-fixed-top navbar-light shadow-sm p-3 mb-3 bg-light">
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
						<li class="nav-item mx-2">
							<a class="nav-link" href="../searchResult.cfm">find Batch</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link" href="batches.cfm">Your Batch</a>
						</li>
						<li class="nav-item mx-2">
							<cfif newNotification GT 0>
								<span class="notification-count float-right"><cfoutput>#newNotification#</cfoutput></span>
							</cfif>
							<a class="nav-link d-inline-block pr-0" href="notification.cfm">Notification</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link" href="../profile.cfm">Profile</a>
						</li>
						<li class="nav-item mx-2">
							<a class="btn button-color shadow text-white" href="/assignments_mindfire/FindOnlineTutor/index.cfm?logout">Logout</a>
						</li>
					
					</ul>
					</div>
				</div>
			</nav>
<cfelse>	
			<div class="footer-copyright text-center text-light p-3"> © 2020 Copyright:
                <a class="text-light" href="https://192.168.43.32/assignments_mindfire/FindOnlineTutor/index.cfm"> FindOnlineTutor.com</a>
            </div>			
		</body>
	</html>
</cfif>
