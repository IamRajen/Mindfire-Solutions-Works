<cf_header homeLink="index.cfm"  logoPath="Images/logo.png" stylePath="Styles/style.css" scriptPath="Script/formValidation.js">


<div class="container-fuild w-50 mx-auto pb-4 mb-5 shadow rounded bg-light">
	<!--- Registration Page starts here --->

	<div class="bg-dark pt-3 pb-3 rounded-top">
		<h4 class="text-light text-center">LOGIN</h4>
	</div>

	<form class="pt-4" name="form-registration" id="form-registration" method="POST">
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

		<div class="row mt-3 ml-2 mr-2">
			<div class="col-md-3">
				<button type="submit" class="btn btn-danger btn-block">Log In</button>
			</div>
		</div>
	</form>
	<!---Registration Page Ends here--->
	<div class="pb-3 pr-3 mx-3">
		<p class="float-right font-weight-normal">Don't have an Account? <a href="signup.cfm">Click Here.</a> </p>
	</div>
	
</div>


</cf_header>



