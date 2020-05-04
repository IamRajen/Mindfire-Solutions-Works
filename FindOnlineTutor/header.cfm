<!---
Project Name: FindOnlineTutor.
File Name: header.cfm.
Created In: 28th Mar 2020
Created By: Rajendra Mishra.
Functionality: It is a header file which is included probably in every pages.
--->
<cfif thistag.executionMode EQ 'start'>
	<!DOCTYPE html>
	<html lang="en" >
		<head>
			<title>FindOnlineTutor</title>
			
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
			<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css">
			<link href="https://fonts.googleapis.com/css?family=Lora|Sen&display=swap" rel="stylesheet">
			<link rel="stylesheet" type="text/css" href="<cfoutput>#attributes.stylePath#</cfoutput>">

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
			<script type = "text/javascript" src = "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
			<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
			<cfif  structKeyExists(attributes, "scriptPath")>
				<script src="<cfoutput>#attributes.scriptPath#</cfoutput>"></script>
			</cfif>
       		

		</head>

		<body>
			<!---if logout button is clicked--->
			<cfif structKeyExists(URL,'logout')>
				<cfset createObject("component",'FindOnlineTutor.Components.authenticationService').doLogout() />
				<cflocation  url="/assignments_mindfire/FindOnlineTutor/index.cfm">
			</cfif>
			<!---navbar start from here--->
			<nav class="navbar navbar-expand-lg navbar-light shadow-sm p-3 bg-light">
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
							<a class="nav-link text-dark" href="index.cfm">Home</a>
						</li>
						<!---if the user is not a teacher but student or visitor--->
						<cfif NOT structKeyExists(session, "stLoggedInUser") OR session.stLoggedInUser.role EQ 'Student'>
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="searchResult.cfm">find Batch</a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="teachers.cfm">Teachers</a>
							</li>
						</cfif>
						
						<!---if user is logged in--->
						<cfif structKeyExists(session, "stLoggedInUser") >
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/batches.cfm">Your Batch</a>
							</li>
							
							<!---teacher's facilities start here--->
							<cfif session.stLoggedInUser.role EQ 'Teacher'>
								<li class="nav-item mx-2">
									<a class="nav-link text-dark" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/request.cfm">Requests<span class="text-warning">*</span></a>
								</li>
								<li class="nav-item mx-2">
									<a class="nav-link text-dark" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/students.cfm">Students</a>
								</li>
							</cfif>
							<!---teacher's faclities end here--->

							
							<!---student's faclities starts here--->
							<cfif session.stLoggedInUser.role EQ 'Student'>
								<li class="nav-item mx-2">
									<a class="nav-link text-dark" href="<cfoutput>#session.stLoggedInUser.role#</cfoutput>/notification.cfm">Notification</a>
								</li>
								
							</cfif>
							<!---student's faclities ends here--->

							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="profile.cfm">Profile</a>
							</li>
							<li class="nav-item mx-2">
								<a class="btn button-color shadow text-white" href="/assignments_mindfire/FindOnlineTutor/index.cfm?logout">Logout</a>
							</li>
						<!---if user is not logged in--->
						<cfelse>
							<li class="nav-item mx-2">
								<a class="nav-link text-dark" href="login.cfm">LogIn</a>
							</li>
							<li class="nav-item mx-2">
								<a class="btn button-color shadow text-white" href="signup.cfm">Register</a>
							</li>
						</cfif>
					
					</ul>
					</div>
				</div>
			</nav>
			
	<cfelse>	
			<footer class="p-5">
        	</footer>			
		</body>
	</html>
</cfif>
