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
		<head>
			<title>FindOnlineTutor</title>
			
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
			<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
			<cfif  structKeyExists(attributes, "scriptPath")>
				<script src="<cfoutput>#attributes.scriptPath#</cfoutput>"></script>
			</cfif>

			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
			<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css">
			<link href="https://fonts.googleapis.com/css?family=Lora|Sen&display=swap" rel="stylesheet">
			<link rel="stylesheet" type="text/css" href="<cfoutput>#attributes.stylePath#</cfoutput>">

			
       		

		</head>

		<body>
			<cfif structKeyExists(URL,'logout')>
				<cfset createObject("component",'FindOnlineTutor.Components.authenticationService').doLogout() />
				<cflocation  url="/assignments_mindfire/FindOnlineTutor/index.cfm">
			</cfif>
			<nav class="navbar navbar-expand-lg navbar-fixed-top navbar-dark shadow-sm p-3 mb-5 bg-dark">
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
							<a class="nav-link text-light" href="../index.cfm">Home</a>
						</li>
						<cfif structKeyExists(session, "stLoggedInUser") >
							<li class="nav-item mx-2">
								<a class="nav-link text-light" href="../profile.cfm">Profile</a>
							</li>
							<li class="nav-item mx-2">
								<a class="nav-link text-light" href="/assignments_mindfire/FindOnlineTutor/index.cfm?logout">Logout</a>
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
