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
        <cfset local.errorMsgs={}>

        <cfset local.errorMsgs["validatedSuccessfully"]=true/>

        <cfset local.errorMsgs["firstName"]=validateName(arguments.firstName)/>
        <cfset local.errorMsgs["lastName"]=validateName(arguments.lastName)/>
        <cfset local.errorMsgs["emailAddress"]=validateEmail(arguments.emailAddress)/>
        <cfset local.errorMsgs["primaryPhoneNumber"]=validatePhoneNumber(arguments.primaryPhoneNumber)/>

        <cfif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber NEQ arguments.primaryPhoneNumber>
            <cfset local.errorMsgs["alternativePhoneNumber"]=validatePhoneNumber(arguments.alternativePhoneNumber)/>
        <cfelseif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber EQ arguments.primaryPhoneNumber>
            <cfset local.errorMsgs["alternativePhoneNumber"]="Alternative number should not be same.You can keep this blank."/>
        </cfif>

        <cfset local.errorMsgs["dob"]=validateDOB(arguments.dob)/>
        <cfset local.errorMsgs["username"]=validateUsername(arguments.username)/>
        <cfset local.errorMsgs["password"]=validatePassword(arguments.password)/>

        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset local.errorMsgs["confirmPassword"]="password not matched!!"/>
        </cfif>

        <cfif arguments.isTeacher EQ 1>
            <cfset local.errorMsgs["experience"]=validateExperience(arguments.experience)/>
        <cfelse>
            <cfset arguments.experience=0/>
        </cfif>
        
        <cfset local.errorMsgs["currentAddress"]=validateText(arguments.currentAddress)/>
        <cfset local.errorMsgs["currentCountry"]=validateText(arguments.currentCountry)/>
        <cfset local.errorMsgs["currentState"]=validateText(arguments.currentState)/>
        <cfset local.errorMsgs["currentCity"]=validateText(arguments.currentCity)/>
        <cfset local.errorMsgs["currentPincode"]=validatePincode(arguments.currentPincode)/>

        <cfif arguments.havingAlternativeAddress>
            <cfset local.errorMsgs["alternativeAddress"]=validateText(arguments.alternativeAddress)/>
            <cfset local.errorMsgs["alternativeCountry"]=validateText(arguments.alternativeCountry)/>
            <cfset local.errorMsgs["alternativeState"]=validateText(arguments.alternativeState)/>
            <cfset local.errorMsgs["alternativeCity"]=validateText(arguments.alternativeCity)/>
            <cfset local.errorMsgs["alternativePincode"]=validatePincode(arguments.alternativePincode)/>
        </cfif>
        
        <cfif arguments.bio NEQ ''>
            <cfset local.errorMsgs["bio"]=validateText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#local.errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and structKeyExists(local.errorMsgs[key],"error")>
                <cfset local.errorMsgs["validatedSuccessfully"]=false/>
                <cfset local.errorMsgs.error = "Some error occurred"/>
                <cfbreak>
            <cfelseif key NEQ 'validatedSuccessfully' and structKeyExists(local.errorMsgs[key],"msg")>
                <cfset local.errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>
        <!---if successfully validated do Registration Work--->
        <cfif local.errorMsgs["validatedSuccessfully"]>
            <cftry>
                <!---Do insertion operation--->
                <cfset local.insertedUser = databaseServiceObj.insertUser(
                arguments.firstName, arguments.lastName, arguments.emailAddress, arguments.primaryPhoneNumber, 
                arguments.alternativePhoneNumber, arguments.dob, arguments.username, arguments.password, arguments.isTeacher,
                arguments.experience, arguments.currentAddress,arguments.currentCountry,arguments.currentState,arguments.currentCity,
                arguments.currentPincode, arguments.havingAlternativeAddress, arguments.alternativeAddress,arguments.alternativeCountry,
                arguments.alternativeState, arguments.alternativeCity,arguments.alternativePincode,arguments.bio)/>

                <cfset local.errorMsgs["key"] = local.insertedUser.generatedKey/>
            <cfcatch type="any">
                <cfset local.errorMsgs['error'] = "Some error occurred. Please try after sometime"/>
            </cfcatch>
            </cftry>
            
        </cfif>
        
        <cfreturn local.errorMsgs/>
    </cffunction>


    <!---function to validate name--->
    <cffunction name="validateName" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrName" type="string" required="true">
        <!---declaring a variable for errormsg of type string--->
        <cfset local.errorMsg={}/>
        <cfset local.name=trim(arguments.usrName)/>

        <!---validation work--->
        <cfif patternValidationObj.isEmpty(local.name)>
            <cfset local.errorMsg.msg="Mandatory field!!"/>
        <cfelseif NOT patternValidationObj.validName(local.name)>
            <cfset local.errorMsg.msg="Invalid Name.Only Alphabets allowed without spaces."/>
        <cfelseif len(local.name) GT 20>
            <cfset local.errorMsg.msg="Should be less than 20 characters!!"/>
        </cfif>

        <cfreturn local.errorMsg/> 
    </cffunction>

    <!---function to validate email pattern--->
    <cffunction  name="validateEmail" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrEmail" type="string" required="true">
        <!---declaring a structure for error msgs--->
        <cfset local.errorMsg={}/>
        <!---triming and initiazing a variable contains usrEmail--->
        <cfset local.email=trim(arguments.usrEmail) />
        <!---email validation starts here--->
        <cfif patternValidationObj.isEmpty(local.email)>
            <cfset local.errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validEmail(local.email)>
            <cfset local.errorMsg.msg="Invalid Email Address."/>
        <cfelse>    
            <cftry>
                <cfset local.user = databaseServiceObj.getUser(emailAddress = local.email)/>
                <cfif local.user.recordCount GT 0>
                    <cfset local.errorMsg.msg="Email address already present"/>
                </cfif>
            <cfcatch type="any">
                <cfset local.errorMsg['error'] = "Some error ocuurred.Please try after sometimes"/>
            </cfcatch>
            </cftry>   
        </cfif>
        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate phone number pattern--->
    <cffunction  name="validatePhoneNumber" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrPhoneNumber" type="string" required="true">
        <!---declaring a variable for usrPhoneNumber--->
        <cfset local.phoneNumber=trim(arguments.usrPhoneNumber)/>
        <!---declaring a strcuture for returning error msg--->
        <cfset local.errorMsg={}/>
        <!---phone Number validation starts here--->
        <cfif patternValidationObj.isEmpty(local.phoneNumber)>
            <cfset local.errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validNumber(local.phoneNumber)>
            <cfset local.errorMsg.msg="Invalid Phone Number!!Only number Allowed"/>
        <cfelseif len(local.phoneNumber) NEQ 10>
            <cfset local.errorMsg.msg="Invalid Phone Number!! Length should be of 10"/> 
        <cfelse>
            <cftry>
                <cfset local.user = databaseServiceObj.getUser(phoneNumber=local.phoneNumber)/>
                <cfif local.user.recordCount GT 0>
                    <cfset local.errorMsg.msg = 'Sorry this phone number has already been taken'/>
                </cfif> 
            <cfcatch type="any">
                <cfset local.errorMsg['error']='Some error occurred.Please try after sometimes'/>
            </cfcatch>
            </cftry>   
        </cfif>
        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate username pattern and unique--->
    <cffunction  name="validateUsername" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argument--->
        <cfargument name="usrUsername" type="string" required="true">
        <!---declaring a variable for further uses--->
        <cfset local.username = trim(arguments.usrUsername)/>
        <!---declaring a structure for error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(local.username)>
            <cfset local.errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validUsername(local.username)>
            <cfset local.errorMsg.msg="Username should contain only alphabets, numbers, (_ @ .)"/>
        <cfelseif len(local.username) GT 8>
            <cfset local.errorMsg.msg="Username should of length 8 characters long"/>
        <cfelse>
            <cftry>
                <cfset local.isUsernamePresent = databaseServiceObj.isUserPresent(username)/>
                <cfif local.isUsernamePresent>  
                    <cfset local.errorMsg.msg="Username already taken"/>
                </cfif>
            <cfcatch type="any">
                <cfset local.errorMsg['error'] = "Some error occurred"/>
            </cfcatch>
            </cftry>   
        </cfif>
        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate password pattern--->
    <cffunction  name="validatePassword" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argumnents--->
        <cfargument  name="usrPassword" type="string" required="true">
        <!---declaring variable to store the usrPassword for further uses--->
        <cfset local.password=trim(arguments.usrPassword)/>
        <!---declaring variable for error msg--->
        <cfset local.errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(local.password)>
            <cfset local.errorMsg.msg="Please provide a password!!"/>
        <cfelseif len(local.password) GT 15 and len(local.password) LT 8 >
            <cfset local.errorMsg.msg="Password length must be within 8-15!!">
        <cfelseif NOT patternValidationObj.validPassword(local.password)>
            <cfset local.errorMsg.msg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>

        <cfreturn local.errorMsg />
    </cffunction>

    <!---function to validate valid DOB--->
    <cffunction  name="validateDOB" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argumnents--->
        <cfargument name="usrDOB" type="string" required="true">
        <!---declaring variable to store the usrDOB for further uses--->
        <cfset local.dob=arguments.usrDOB/>
        <!---declaring variable for error msg--->
        <cfset local.errorMsg={}/>
        <!---validation starts here--->
        <cfif NOT IsDate(local.dob)>
            <cfset local.errorMsg.msg="Not a Valid date format!!">
        <cfelse>
            <cfset local.dob=dateTimeFormat(local.dob, "MM/dd/yyyy") />
            <cfif Year(local.dob) GT Year(now())-2 OR Year(local.dob) LT Year(now())-80 >
                <cfset local.errorMsg.msg="Should be greater than 2 years and less than 80 years old"/>
            </cfif>
        </cfif>

        <cfreturn local.errorMsg />
    </cffunction>

    <!---function to validate any valid text--->
    <cffunction  name="validateText" access="remote" returnformat="json" returntype="struct" output="false">
        <!---defining argumnents--->
        <cfargument name="usrText" type="string" required="true">
        <!---declaring variable to store the text for further uses--->
        <cfset local.text=trim(arguments.usrText)/>
        <!---declaring variable for error msg--->
        <cfset local.errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(local.text)>
            <cfset local.errorMsg.msg = "Mandatory Field!!"/>
        <cfelseif NOT patternvalidationObj.ValidText(local.text)>
            <cfset local.errorMsg.msg="Should contain only alphabets, number and ',''/''&' "/>
        </cfif>

        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate valid pincode--->
    <cffunction  name="validatePincode" access="remote" output="false" returnType="struct">
        <!---defining argumnents--->
        <cfargument name="usrPincode" type="string" required="true">
        <!---declaring variable to store the usrPincode for further uses--->
        <cfset local.pincode = trim(arguments.usrPincode) />
        <!---declaring variable for error msg--->
        <cfset local.errorMsg={}/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(local.pincode)>
            <cfset local.errorMsg.msg="Mandatory Field"/>
        <cfelseif (NOT patternValidationObj.validNumber(local.pincode)) and (len(local.pincode) NEQ 6)>
            <cfset local.errorMsg.msg="Invalid Pincode.Must be Number of 6 digit and should contain only Number">
        </cfif>

        <cfreturn local.errorMsg />
    </cffunction>

    <!---function to validate experience--->
    <cffunction name="validateExperience" access="remote" output="false" returnType="struct">
        <!---defining argumnents--->
        <cfargument name="usrExperience" type="string" required="true">
        <!---declaring variable to store the usrExperience for further uses--->
        <cfset local.experience = trim(arguments.usrExperience)/>
        <!---declaring variable for error msg--->
        <cfset local.errorMsg ={}/>
        <!---validation starts here--->
        <cfif NOT patternValidationObj.validNumber(local.experience)>
            <cfset local.errorMsg.msg="Invalid Experience. Only Integer allowed."/>
        <cfelseif experience GT 99 and local.experience LT 0>
            <cfset local.errorMsg.msg="Experience must be within 0 to 99"/>
        </cfif>

        <cfreturn local.errorMsg/>
    </cffunction>

 

</cfcomponent>

