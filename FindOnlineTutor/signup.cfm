<!---
Project Name: FindOnlineTutor.
File Name: signup.cfm.
Created In: 28th Mar 2020
Created By: Rajendra Mishra.
Functionality: This is the signup page helps the user to validate and register in the website.
--->
<!---if user already logged in--->
<cfif structKeyExists(session, "stLoggedInUser")>
	<cflocation  url="/assignments_mindfire/FindOnlineTutor">
</cfif>
<!---Including the navibar custom tag--->
<cf_header homeLink="index.cfm"  logoPath="Images/logo.png" stylePath="Styles/style.css" scriptPath="Script/registrationFormValidation.js">
<div class="container mt-5">
<noscript>
	<div class="container  px-5 text-center">
		<h3 class="mx-5 text-danger">Please enable <strong>JavaScipt</strong> to submit the form!!</h3>
	</div>
</noscript>


<div class="container-fuild w-100 mx-auto pb-4 mb-5 shadow rounded bg-light border">

	<!---Heading Field--->
	<div class="bg-light pt-3 pb-3 rounded-top">
		<h4 class="text-dark text-center">REGISTRATION FORM</h4>
	</div>
	<hr class="border border-info">


	<!---Form Field--->
	<form class="pt-4 disabledbutton" id="form-registration" method="POST" action="login.cfm">



	<!---Name Field--->
		<div class="row mt-4 mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="firstName">Fullname<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-4">
				<input type="text" id="firstName" name="firstName" placeholder="First Name" class="form-control d-block" onblur="checkName(this)">
				<span class="text-danger small float-left"></span>
			</div>
			<div class="col-md-4">
				<input type="text" id="lastName" name="lastName" placeholder="Last Name" class="form-control d-block" onblur="checkName(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Email Address Field--->
		<div class="row mt-4 mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="emailAddress">Email ID:<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-8">
				<input type="text" id="emailAddress" name="emailAddress" placeholder="Email Address" class="form-control d-block" onblur="checkEmailId(this)">
				
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Phone Number Field--->
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3">
				<label class="control-label"  for="primaryPhoneNumber">Phone Number:<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-4">
				<input type="text" id="primaryPhoneNumber" name="primaryPhoneNumber" placeholder="Primary Phone Number" class="form-control d-block" onblur="checkPhoneNumber(this)">
				<span class="text-danger small float-left"></span>
			</div>
			<div class="col-md-4">
				<input type="text" id="alternativePhoneNumber" name="alternativePhoneNumber" placeholder="Alternative Phone Number" class="form-control d-block" onblur="checkPhoneNumber(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Username Field--->
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3">
				<label class="control-label"  for="username">Create Username:<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-4">
				<input type="text" id="username" name="username" placeholder="Username" class="form-control d-block" onblur="checkUsername(this)">
				<span class="text-danger small float-left"></span>
			</div>
			
		</div>


	<!---Password Field--->
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3">
				<label class="control-label"  for="password">Create Password:<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-4">
				<input type="password" id="password" name="password" placeholder="Create Password" class="form-control d-block" onblur="checkPassword(this)">
				<span class="text-danger small float-left"></span>
			</div>
			<div class="col-md-4">
				<input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter Password" class="form-control d-block" onblur="checkPassword(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---DOB Field--->
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3">
				<label class="control-label"  for="dob">D.O.B:<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-4">
				<input type="date" id="dob" name="dob" class="form-control d-block" onblur="checkDOB(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Current Address Field--->
		<div class="row mt-4 mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="currentAddress">Current Address:<span class="text-danger">*</span></label>
			</div>
			<div class="col-md-8">
				<textarea type="text" id="currentAddress" name="currentAddress" placeholder="Current Adrress" class="form-control d-block" onblur="checkAddress(this)"></textarea>
				<span class="text-danger small float-left"></span>
			</div>
		</div>
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3"></div>
			<div class="col-md-4">
				<select id="currentCountry" name="currentCountry" class="form-control d-block" onblur="populateState(this)">
					<option value="">---select your country----</option>
				</select>
				<span class="text-danger small float-left"></span>
			</div>
			<div  class="col-md-4">
				<select id="currentState" name="currentState" class="form-control d-block" onblur="checkState(this)">
					<option value="">---select your state----</option>
				</select>
				<span class="text-danger small float-left"></span>
			</div>
		</div>
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3"></div>
			<div class="col-md-4">
				<input type="text" id="currentCity" name="currentCity" placeholder="Current City" class="form-control d-block" onblur="checkAddress(this)">
				<span class="text-danger small float-left"></span>
			</div>
			<div class="col-md-4">
				<input type="text" id="currentPincode" name="currentPincode" placeholder="Current Pincode" class="form-control d-block" onblur="checkPincode(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Alternative Address Field--->
		<div class="row mt-4 mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="alternativeAddress">Alternative Address:</label>
			</div>
			<div class="col-md-8">
				<textarea type="text" id="alternativeAddress" name="alternativeAddress" placeholder="Alternative Adrress" class="form-control d-block" onblur="checkAddress(this)"></textarea>
				<span class="text-danger small float-left"></span>
			</div>
		</div>
		
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3"></div>
			<div class="col-md-4">
				<select id="alternativeCountry" name="alternativeCountry" class="form-control d-block" onblur="populateState(this)">
					<option value="">---select your country----</option>
				</select>
				<span class="text-danger small float-left"></span>
			</div>
			<div class="col-md-4">
				<select id="alternativeState" name="alternativeState" class="form-control d-block" onblur="checkState(this)">
					<option value="">---select your state----</option>
				</select>
				<span class="text-danger small float-left"></span>
			</div>
		</div>
		
		<div class="row mt-4 mr-2 ml-2 ">
			<div class="col-md-3"></div>
			<div class="col-md-4">
				<input type="text" id="alternativeCity" name="alternativeCity" placeholder="Alternative City" class="form-control d-block" onblur="checkAddress(this)">
				<span class="text-danger small float-left"></span>
			</div>
			<div class="col-md-4">
				<input type="text" id="alternativePincode" name="alternativePincode" placeholder="Alternative Pincode" class="form-control d-block" onblur="checkPincode(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Bio field--->
		<div class="row mt-4 mr-2 ml-2">
			<div class="col-md-3">
				<label class="control-label"  for="bio">Bio (optional):</label>
			</div>
			<div class="col-md-8">
				<textarea type="text" id="bio" name="bio" placeholder="" class="form-control d-block" rows="4" onblur="checkBio(this)"></textarea>
				<span class="text-danger small float-left"></span>
			</div>
		</div>


	<!---Teacher Section--->
		<div class="row mt-4 mr-2 ml-4">
			<div class="col-md-3">
				<label class="form-check-label">
					<input id="isTeacher" name="isTeacher" type="checkbox" class="form-check-input" value="1">Are you Teacher??
				</label>
			</div>
		</div>
		<div id="teacherSection" class="row mt-4 mr-2 ml-1">
			<div class="col-md-3">
				<label class="control-label"  for="experience">Year's of Experience:</label>
			</div>
			<div class="col-md-2">
				<input type="number" id="experience" name="experience" class="form-control d-block" onblur="checkExperience(this)">
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
				<input type="text" id="captcha" name="captcha" class="form-control d-block" onblur="checkCaptcha(this)">
				<span class="text-danger small float-left"></span>
			</div>
		</div>
			
	<!---Submit Section--->
		<div class="row mt-5 mr-2 ml-2">
			<div class="col-md-2" id="buttonDiv">

			</div>
		</div>
		
	</form>
	<!---Registration Page Ends here--->
	<div class="pb-3 pr-3 ">
		<p class="float-right font-weight-normal">Have an account? <a href="login.cfm">Click Here.</a> </p>
	</div>
	
</div>
</div>
</cf_header>
        
	