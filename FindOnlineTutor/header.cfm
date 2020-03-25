<!--- <cfparam name="attributes.home" default="index.cfm" > --->
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
       		<script src="<cfoutput>#attributes.scriptPath#</cfoutput>"></script>

		</head>

		<body>
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
							<a class="nav-link text-light" href="index.cfm">Home</a>
						</li>
						<li class="nav-item mx-2">
							<a class="nav-link text-light" href="login.cfm">LogIn</a>
						</li>
						<li class="nav-item mx-2">
							<a class="btn btn-danger my-2 my-sm-0 pl-3 pr-3" href="signup.cfm">Register</a>
						</li>

					</ul>
					</div>
				</div>
			</nav>
			<div class="container">
	<cfelse>
			</div>			
		</body>
	</html>
</cfif>
