<!---
Project Name: FindOnlineTutor.
File Name: validation.cfc.
Created In: 5th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file has function that validated the registration form and inserted 
                the user data to the database if successfully validated .
--->

<cfcomponent output="false">
    <!---onsubmit validation--->
    <cfset patternValidationObj = createObject("component","patternValidation")/>
    <cfset databaseServiceObj = createObject("component","databaseService")/>
    
    <cffunction  name="validateForm" access="remote" output="false" returnformat="json" returntype="struct">

        <!---defining arguments--->
        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="primaryPhoneNumber" type="string" required="true"/>
        <cfargument  name="alternativePhoneNumber" type="string" required="false"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="username" type="string" required="true"/>
        <cfargument  name="password" type="string" required="true"/>
        <cfargument  name="confirmPassword" type="string" required="true"/>
        <cfargument  name="isTeacher" type="string" required="true"/>
        <cfargument  name="experience" type="string" required="false"/>
        <cfargument  name="currentAddress" type="string" required="true"/>
        <cfargument  name="currentCountry" type="string" required="true"/>
        <cfargument  name="currentState" type="string" required="true"/>
        <cfargument  name="currentCity" type="string" required="true"/>
        <cfargument  name="currentPincode" type="string" required="true"/>
        <cfargument  name="havingAlternativeAddress" type="boolean" required="true"/>
        <cfargument  name="alternativeAddress" type="string" required="false"/>
        <cfargument  name="alternativeCountry" type="string" required="false"/>
        <cfargument  name="alternativeState" type="string" required="false"/>
        <cfargument  name="alternativeCity" type="string" required="false"/>
        <cfargument  name="alternativePincode" type="string" required="false"/>
        <cfargument  name="bio" type="string" required="false"/>

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset errorMsgs={}>

        <cfset errorMsgs["validatedSuccessfully"]=true/>
        <cfset errorMsgs["firstName"]=validateName(arguments.firstName)/>
        <cfset errorMsgs["lastName"]=validateName(arguments.lastName)/>
        <cfset errorMsgs["emailAddress"]=validateEmail(arguments.emailAddress)/>
        <cfset errorMsgs["primaryPhoneNumber"]=validatePhoneNumber(arguments.primaryPhoneNumber)/>

        <cfif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber NEQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]=validatePhoneNumber(arguments.alternativePhoneNumber)/>
        <cfelseif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber EQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]="Alternative number should not be same.You can keep this blank."/>
        </cfif>

        <cfset errorMsgs["dob"]=validateDOB(arguments.dob)/>
        <cfset errorMsgs["username"]=validateUsername(arguments.username)/>
        <cfset errorMsgs["password"]=validatePassword(arguments.password)/>

        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset errorMsgs["confirmPassword"]="password not matched!!"/>
        </cfif>

        <cfif arguments.isTeacher EQ 1>
            <cfset errorMsgs["experience"]=validateExperience(arguments.experience)/>
        <cfelse>
            <cfset arguments.experience=0/>
        </cfif>
        
        <cfset errorMsgs["currentAddress"]=validateText(arguments.currentAddress)/>
        <cfset errorMsgs["currentCountry"]=validateText(arguments.currentCountry)/>
        <cfset errorMsgs["currentState"]=validateText(arguments.currentState)/>
        <cfset errorMsgs["currentCity"]=validateText(arguments.currentCity)/>
        <cfset errorMsgs["currentPincode"]=validatePincode(arguments.currentPincode)/>

        <cfif arguments.havingAlternativeAddress>
            <cfset errorMsgs["alternativeAddress"]=validateText(arguments.alternativeAddress)/>
            <cfset errorMsgs["alternativeCountry"]=validateText(arguments.alternativeCountry)/>
            <cfset errorMsgs["alternativeState"]=validateText(arguments.alternativeState)/>
            <cfset errorMsgs["alternativeCity"]=validateText(arguments.alternativeCity)/>
            <cfset errorMsgs["alternativePincode"]=validatePincode(arguments.alternativePincode)/>
        </cfif>
        
        <cfif arguments.bio NEQ ''>
            <cfset errorMsgs["bio"]=validateText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and structKeyExists(errorMsgs[key],"error")>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfset errorMsgs["serverError"]=true/>
                <cfbreak>
            <cfelseif key NEQ 'validatedSuccessfully' and structKeyExists(errorMsgs[key],"msg")>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>
        
        <!---if successfully validated do Registration Work--->
        <cfif errorMsgs["validatedSuccessfully"]==true>
            <!---Do insertion operation--->
            <cfset errorMsgs["validatedSuccessfully"] = databaseServiceObj.insertUser(
            arguments.firstName, arguments.lastName, arguments.emailAddress, arguments.primaryPhoneNumber, 
            arguments.alternativePhoneNumber, arguments.dob, arguments.username, arguments.password, arguments.isTeacher,
            arguments.experience, arguments.currentAddress,arguments.currentCountry,arguments.currentState,arguments.currentCity,
            arguments.currentPincode, arguments.havingAlternativeAddress, arguments.alternativeAddress,arguments.alternativeCountry,
            arguments.alternativeState, arguments.alternativeCity,arguments.alternativePincode,arguments.bio
            )/>

        </cfif>
            
        <cfreturn errorMsgs/>
    </cffunction>


    <!---function to validate name--->
    <cffunction name="validateName" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrName" type="string" required="true">
        <!---declaring a variable for errormsg of type string--->
        <cfset var errorMsg={}/>
        <cfset var name=trim(arguments.usrName)/>

        <!---validation work--->
        <cfif patternValidationObj.isEmpty(name)>
            <cfset errorMsg.msg="Mandatory field!!"/>
        <cfelseif NOT patternValidationObj.validName(name)>
            <cfset errorMsg.msg="Invalid Name.Only Alphabets allowed without spaces."/>
        <cfelseif len(name) GT 20>
            <cfset errorMsg.msg="Should be less than 20 characters!!"/>
        </cfif>

        <cfreturn errorMsg/> 
    </cffunction>

    <!---function to validate email pattern--->
    <cffunction  name="validateEmail" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrEmail" type="string" required="true">
        <!---declaring a structure for error msgs--->
        <cfset var errorMsg={}/>
        <!---triming and initiazing a variable contains usrEmail--->
        <cfset var email=trim(arguments.usrEmail) />
        <!---email validation starts here--->
        <cfif patternValidationObj.isEmpty(email)>
            <cfset errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validEmail(email)>
            <cfset errorMsg.msg="Invalid Email Address."/>
        <cfelse>    
            <cftry>
                <cfset var isEmailAddressPresent = databaseServiceObj.isEmailPresent(email)/>
                <cfif structKeyExists(isEmailAddressPresent, "error")>
                    <cfset errorMsg.error="Some Error occurred while validating email address.Please, try after some time"/>
                    <cfthrow detail = #isEmailAddressPresent.error#/>
                <cfelseif structKeyExists(isEmailAddressPresent, "isPresent")>
                    <cfif isEmailAddressPresent.isPresent EQ true>  
                        <cfset errorMsg.msg="Email address already present"/>
                        <cflog text="helo"/>
                    </cfif>
                </cfif>
            <cfcatch type="any">
                <cflog text = "Email validation error: #cfcatch#"/>
            </cfcatch>
            </cftry>   
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate phone number pattern--->
    <cffunction  name="validatePhoneNumber" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrPhoneNumber" type="string" required="true">
        <!---declaring a variable for usrPhoneNumber--->
        <cfset var phoneNumber=trim(arguments.usrPhoneNumber)/>
        <!---declaring a strcuture for returning error msg--->
        <cfset var errorMsg={}/>
        <!---phone Number validation starts here--->
        <cfif patternValidationObj.isEmpty(phoneNumber)>
            <cfset errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validNumber(phoneNumber)>
            <cfset errorMsg.msg="Invalid Phone Number!!Only number Allowed"/>
        <cfelseif len(phoneNumber) NEQ 10>
            <cfset errorMsg.msg="Invalid Phone Number!! Length should be of 10"/> 
        <cfelse>
            <cftry>
                <cfset var isPhoneNumberPresent = databaseServiceObj.isPhonePresent(phoneNumber)/>
                <cfif structKeyExists(isPhoneNumberPresent, "error")>
                    <cfset errorMsg.error="Some Error occurred while validating phone Number.Please, try after some time"/>
                    <cfthrow detail = #isPhoneNumberPresent.error#/>
                <cfelseif structKeyExists(isPhoneNumberPresent, "isPresent")>
                    <cfif isPhoneNumberPresent.isPresent>  
                        <cfset errorMsg.msg="Phone Number already present"/>
                    </cfif>
                </cfif>
            <cfcatch type="any">
                <cflog text = "Phone Number validation error: #cfcatch#"/>
            </cfcatch>
            </cftry>   
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate username pattern and unique--->
    <cffunction  name="validateUsername" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrUsername" type="string" required="true">
        <!---declaring a variable for further uses--->
        <cfset var username = trim(arguments.usrUsername)/>
        <!---declaring a structure for error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(username)>
            <cfset errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validUsername(username)>
            <cfset errorMsg.msg="Username should contain only alphabets, numbers, (_ @ .)"/>
        <cfelseif len(username) GT 8>
            <cfset errorMsg.msg="Username should of length 8 characters long"/>
        <cfelse>
            <cftry>
                <cfset var isUsernamePresent = databaseServiceObj.isUserPresent(username)/>
                <cfif structKeyExists(isUsernamePresent, "error")>
                    <cfset errorMsg.error="Some Error occurred while validating username.Please, try after some time"/>
                    <cfthrow detail = #isUsernamePresent.error#/>
                <cfelseif structKeyExists(isUsernamePresent, "isPresent")>
                    <cfif isUsernamePresent.isPresent>  
                        <cfset errorMsg.msg="Username already taken"/>
                    </cfif>
                </cfif>
            <cfcatch type="any">
                <cflog text = "Username validation error: #cfcatch#"/>
            </cfcatch>
            </cftry>   
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate password pattern--->
    <cffunction  name="validatePassword" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argumnents--->
        <cfargument  name="usrPassword" type="string" required="true">
        <!---declaring variable to store the usrPassword for further uses--->
        <cfset var password=trim(arguments.usrPassword)/>
        <!---declaring variable for error msg--->
        <cfset var errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(password)>
            <cfset errorMsg.msg="Please provide a password!!"/>
        <cfelseif len(password) GT 15 and len(password) LT 8 >
            <cfset errorMsg.msg="Password length must be within 8-15!!">
        <cfelseif NOT patternValidationObj.validPassword(password)>
            <cfset errorMsg.msg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>

        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate valid DOB--->
    <cffunction  name="validateDOB" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argumnents--->
        <cfargument name="usrDOB" type="string" required="true">
        <!---declaring variable to store the usrDOB for further uses--->
        <cfset var dob=arguments.usrDOB/>
        <!---declaring variable for error msg--->
        <cfset var errorMsg={}/>
        <!---validation starts here--->
        <cfif NOT IsDate(dob)>
            <cfset errorMsg.msg="Not a Valid date format!!">
        <cfelse>
            <cfset dob=dateTimeFormat(dob, "MM/dd/yyyy") />
            <cfif Year(dob) GT Year(now())-2 OR Year(dob) LT Year(now())-80 >
                <cfset errorMsg.msg="Should be greater than 2 years and less than 80 years old"/>
            </cfif>
        </cfif>

        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate any valid text--->
    <cffunction  name="validateText" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argumnents--->
        <cfargument name="usrText" type="string" required="true">
        <!---declaring variable to store the text for further uses--->
        <cfset var text=trim(arguments.usrText)/>
        <!---declaring variable for error msg--->
        <cfset var errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(text)>
            <cfset errorMsg.msg = "Mandatory Field!!"/>
        <cfelseif NOT patternvalidationObj.ValidText(text)>
            <cfset errorMsg.msg="Should contain only alphabets, number and ',''/''&' "/>
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate valid pincode--->
    <cffunction  name="validatePincode" access="remote" output="false" returnType="struct">
        <!---defining argumnents--->
        <cfargument name="usrPincode" type="string" required="true">
        <!---declaring variable to store the usrPincode for further uses--->
        <cfset var pincode = trim(arguments.usrPincode) />
        <!---declaring variable for error msg--->
        <cfset var errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(pincode)>
            <cfset errorMsg.msg="Mandatory Field"/>
        <cfelseif (NOT patternValidationObj.validNumber(pincode)) and (len(pincode) NEQ 6)>
            <cfset errorMsg.msg="Invalid Pincode.Must be Number of 6 digit and should contain only Number">
        </cfif>

        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate experience--->
    <cffunction name="validateExperience" access="remote" output="false" returnType="struct">
        <!---defining argumnents--->
        <cfargument name="usrExperience" type="string" required="true">
        <!---declaring variable to store the usrExperience for further uses--->
        <cfset var experience = trim(arguments.usrExperience)/>
        <!---declaring variable for error msg--->
        <cfset var errorMsg ={}/>
        <!---validation starts here--->
        <cfif NOT patterValidationObj.validNumber(experience)>
            <cfset errorMsg.msg="Invalid Experience. Only Integer allowed."/>
        <cfelseif experience GT 99 and experience LT 0>
            <cfset errorMsg.msg="Experience must be within 0 to 99"/>
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>

 

</cfcomponent>

