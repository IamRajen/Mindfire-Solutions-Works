<!---if user already logged in--->
<cfif structKeyExists(session, "stLoggedInUser")>
	<cflocation  url="/assignments_mindfire/FindOnlineTutor">
</cfif>

<cf_header homeLink="index.cfm"  logoPath="Images/logo.png" stylePath="Styles/style.css" scriptPath="Script/loginFormValidation.js">

<!--- <cfdump  var="#session#"> --->
<div class="container-fuild w-50 mx-auto pb-4 mb-5 shadow rounded bg-light">
	<!--- Registration Page starts here --->

	<div class="bg-dark pt-3 pb-3 rounded-top">
		<h4 class="text-light text-center">LOGIN</h4>
	</div>

	<form class="pt-4" name="form-registration" id="form-registration" method="POST" action="index.cfm">

		<!---username Field--->
		<div class="row mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="username">Username<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-8">
				<input type="text" id="username" name="username" placeholder="Username" class="form-control d-block">
				<span class="text-danger small float-left"></span>
			</div>
		</div>

		<!---Password Field--->
		<div class="row mr-2 ml-2 mt-4">
			<div class="col-md-3">
				<label class="control-label"  for="password">Password<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-8">
				<input type="password" id="password" name="password" placeholder="Password" class="form-control d-block">
				<span class="text-danger small float-left"></span>
			</div>
		</div>
		
		<!---Captcha section--->
		<div class="row mt-5 mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="captcha">Captcha:</label>
			</div>
			<div class="col-md-4">
				<canvas class="w-75 rounded" id="canvas"></canvas>
			</div>
			<div class="col-md-4">
				<input type="text" id="captcha" name="captcha" class="form-control d-block">
				<span class="text-danger small float-left"></span>
			</div>
		</div>

		<!--submit section-->
		<div class="row mt-3 ml-2 mr-2">
			<div class="col-md-3" id="buttonDiv">
			</div>
			<div class="col-md-9">
				<span id="loginError" class="text-danger small float-left"></span>
			</div>
		</div>

	</form>
	<!---Registration Page Ends here--->

	<div class="row mt-3 mr-2 ml-2">	
		<div class="col-md-12">
			<p class="float-right font-weight-normal">Don't have an Account? <a href="signup.cfm">Click Here.</a> </p>
		</div>
	</div>
</div>


</cf_header>



