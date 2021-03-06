<!---
Project Name: FindOnlineTutor.
File Name: header.cfm.
Created In: 26th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a header file which is included probably in student section pages.
--->

<cfset local.batchServiceObject = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset local.myNotification = local.batchServiceObject.getMyNotification()/>
<cfset local.newNotification = 0/>
<cfif NOT structKeyExists(local.myNotification, "error")>
	<cfloop query="#local.myNotification.Notifications#">
		<cfif NOT #notificationStatus#>
			<cfset local.newNotification = local.newNotification+1/>
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
			<nav class="navbar navbar-expand-lg navbar-light p-3 navFix">
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
							<a class="nav-link" href="../searchResult.cfm">Find Batch</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link" href="batches.cfm">Your Batch</a>
						</li>
						<li class="nav-item mx-2">
							<cfif local.newNotification GT 0>
								<span class="notification-count float-right"><cfoutput>#local.newNotification#</cfoutput></span>
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
			<div class="container mt-5 pt-5 min-height" >
            
			
	<cfelse>
			</div>	<cfinclude  template="../Include/footer.cfm">				
		</body>
	</html>
</cfif>
