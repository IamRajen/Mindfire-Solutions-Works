<!---
Project Name: FindOnlineTutor.
File Name: profile.cfm.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file show the profile data to user and allows to modify it.
--->

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" scriptPath="Script/updateProfile.js">

<!---if the user is logged in this if block will get executed--->
<cfif structKeyExists(session, "stLoggedInUser")>
    <!---if user disables the javascript--->
    <noscript>
        <div class="container  px-5 text-center">
            <h3 class="mx-5 text-danger">Please enable <strong>JavaScipt</strong> to submit the form!!</h3>
        </div>
    </noscript>
  
    <!---creating a databaseService object for retriving user profile--->
    <cfset databaseObj = createObject("Component","FindOnlineTutor/Components/databaseService")/>
    <!---calling the function for profile data--->
    <cfset profileInfo = databaseObj.getMyProfile(#session.stloggedinuser.userID#)/>
    <cfdump  var="#profileInfo#">
    <!---Initializing the primary phone number--->
    <cfset  primaryPhoneNumber = #profileInfo.USERPHONENUMBER.PHONENUMBER.phoneNumber[1]#/>
    <!---Initializing the alternative phone number--->
    <cfset  alternativePhoneNumber = #profileInfo.USERPHONENUMBER.PHONENUMBER.phoneNumber[2]#/>
    
    <div class="container-fuild w-100 mx-auto mb-5 shadow rounded bg-light">

        <!---Heading Field--->
        <div class="bg-dark pt-3 pb-3 rounded-top text-center">
            <h2 id="headingUserId" class="text-light text-capitalize d-inline"><cfoutput>#session.stloggedinuser.userID#</cfoutput></h2>
            <p class="text-light d-inline">   Your Profile</p>
        </div>

        <!---Profile Loading Error--->
        <cfif structKeyExists(profileInfo, "error")>
            <div class="alert alert-danger pt-3 pb-3 rounded-top">
                <p class="text-danger text-center">
                    <cfoutput>
                        #profileInfo.error#
                    </cfoutput>
                </p>
            </div>

        <!---if profile perfectly get loaded else part will get executed--->
        <cfelse>
        <!---Form Field--->
            <form class="disabledbutton pb-5" id="form-update" method="POST">

                <!---Name Field--->
                    <div class="row mt-4 mr-2 ml-2">
                        <div class="col-md-3">
                            <label class="control-label"  for="firstName">Fullname<span class="text-danger">*</span></label>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="firstName" name="firstName" placeholder="First Name" class="form-control d-block" onblur="checkName(this)" value="<cfoutput>#profileInfo.USERDETAILS.firstName#</cfoutput>">
                            <span class="text-danger small float-left"></span>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="lastName" name="lastName" placeholder="Last Name" class="form-control d-block" onblur="checkName(this)" value="<cfoutput>#profileInfo.USERDETAILS.lastName#</cfoutput>">
                            <span class="text-danger small float-left"></span>
                        </div>
                    </div>


                <!---Email Address Field--->
                    <div class="row mt-4 mr-2 ml-2">
                        <div class="col-md-3">
                            <label class="control-label"  for="emailAddress">Email ID:<span class="text-danger">*</span></label>
                        </div>
                        <div class="col-md-8">
                            <input type="text" id="emailAddress" name="emailAddress" placeholder="Email Address" class="form-control d-block" onblur="checkEmailId(this)" value="<cfoutput>#profileInfo.USERDETAILS.emailId#</cfoutput>">
                            
                            <span class="text-danger small float-left"></span>
                        </div>
                    </div>


                
                <!---Phone Number Field--->
                    <div class="row mt-4 mr-2 ml-2 ">
                        <div class="col-md-3">
                            <label class="control-label"  for="primaryPhoneNumber">Phone Number:<span class="text-danger">*</span></label>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="primaryPhoneNumber" name="primaryPhoneNumber" placeholder="Primary Phone Number" class="form-control d-block" onblur="checkPhoneNumber(this)" value="<cfoutput>#primaryPhoneNumber#</cfoutput>">
                            <span class="text-danger small float-left"></span>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="alternativePhoneNumber" name="alternativePhoneNumber" placeholder="Alternative Phone Number" class="form-control d-block" onblur="checkPhoneNumber(this)" value="<cfoutput>#alternativePhoneNumber#</cfoutput>">
                            <span class="text-danger small float-left"></span>
                        </div>
                    </div>


                
                <!---Password Field--->
                    <div class="row mt-4 mr-2 ml-2 ">
                        <div class="col-md-3">
                            <label class="control-label"  for="password">Create Password:<span class="text-danger">*</span></label>
                        </div>
                        <div class="col-md-4">
                            <input type="password" id="password" name="password" placeholder="Create Password" class="form-control d-block" onblur="checkPassword(this)" value="<cfoutput>#profileInfo.USERDETAILS.password#</cfoutput>">
                            <span class="text-danger small float-left"></span>
                        </div>
                        <div class="col-md-4">
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter Password" class="form-control d-block" onblur="checkPassword(this)" value="<cfoutput>#profileInfo.USERDETAILS.password#</cfoutput>">
                            <span class="text-danger small float-left"></span>
                        </div>
                    </div>


                <!---DOB Field--->
                    <div class="row mt-4 mr-2 ml-2 ">
                        <div class="col-md-3">
                            <label class="control-label"  for="dob">D.O.B:<span class="text-danger">*</span></label>
                        </div>
                        <div class="col-md-4">
                            <input type="date" id="dob" name="dob" placeholder="Create Password" class="form-control d-block" onblur="checkDOB(this)" value="<cfoutput>#profileInfo.USERDETAILS.dob#</cfoutput>">
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
                    <div  class="row mt-4 mr-2 ml-2">
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
                            <input type="text" id="currentPincode" name="currentPincode" placeholder="Current Pincode" class="form-control d-block" onblur="checkPincode(this)" >
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
                            <textarea type="text" id="bio" name="bio" placeholder="" class="form-control d-block" rows="4" onblur="checkBio(this)"><cfoutput>#profileInfo.USERDETAILS.BIO#</cfoutput></textarea>
                            <span class="text-danger small float-left"></span>
                        </div>
                    </div>


                
                <!---Submit Section--->
                    <div class="row mt-5 mr-2 ml-2">
                        <div class="col-md-2" id="buttonDiv">

                        </div>
                    </div>
                <!---Interested location field--->
                    
                
            </form>
        </cfif> 

    </div>
<!---if user not logged in he/she will be redirected to homepage--->
<cfelse>
    <cflocation  url="/assignments_mindfire/FindOnlineTutor"/>

</cfif>


	