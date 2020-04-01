

<cfcomponent output="false">
    <!---onsubmit validation--->
    <cffunction  name="validateForm" access="remote" output="false" returnformat="json" returntype="struct">

        <!---defining arguments--->
        <cfargument  name="profilePhoto" type="string" required="true"/>
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

        <!---creating a struct for erro messages and calling the required functions--->
        <cfset errorMsgs={}>
        <cfset errorMsgs.validatedSuccessfully=true/>
<!---         <cfset errorMsg.profilePhoto=validateProfilePhoto(arguments.profilePhoto)> --->
        <cfset errorMsgs.firstName=validateName(arguments.firstName)/>
        <cfset errorMsgs.lastName=validateName(arguments.lastName)/>
        <cfset errorMsgs.emailAddress=validateEmail(arguments.emailAddress)/>
        <cfset errorMsgs.primaryPhoneNumber=validatePhoneNumber(arguments.primaryPhoneNumber)/>
        <cfif arguments.alternativePhoneNumber NEQ ''>
            <cfset errorMsgs.alternativePhoneNumber=validatePhoneNumber(arguments.alternativePhoneNumber)/>
        </cfif>
        <cfset errorMsgs.dob=validateDOB(arguments.dob)/>
        <cfset errorMsgs.username=validateUsername(arguments.username)/>
        <cfset errorMsgs.password=validatePassword(arguments.password)/>
        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset errorMsgs.confirmPassword={"error":"password not matched!!"}/>
        </cfif>
        <cfif arguments.isTeacher EQ 1>
            <cfset errorMsgs.experience=validateExperience(arguments.experience)/>
        <cfelse>
            <cfset arguments.experience=0/>
        </cfif>
        
        <cfset errorMsgs.currentAddress=validateText(arguments.currentAddress)/>
        <cfset errorMsgs.currentCountry=validateText(arguments.currentCountry)/>
        <cfset errorMsgs.currentState=validateText(arguments.currentState)/>
        <cfset errorMsgs.currentCity=validateText(arguments.currentCity)/>
        <cfset errorMsgs.currentPincode=validatePincode(arguments.currentPincode)/>
        <cfif arguments.havingAlternativeAddress>
            <cfset errorMsgs.alternativeAddress=validateText(arguments.alternativeAddress)/>
            <cfset errorMsgs.alternativeCountry=validateText(arguments.alternativeCountry)/>
            <cfset errorMsgs.alternativeState=validateText(arguments.alternativeState)/>
            <cfset errorMsgs.alternativeCity=validateText(arguments.alternativeCity)/>
            <cfset errorMsgs.alternativePincode=validatePincode(arguments.alternativePincode)/>
        </cfif>
        <cfif arguments.bio NEQ ''>
            <cfset errorMsgs.bio=validateText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif structKeyExists(errorMsgs, key) and key NEQ 'validatedSuccessfully'>
                <cfset errorMsgs.validatedSuccessfully=false/>
                <cfif errorMsgs[key]['error'] NEQ ''>
                    <cfreturn errorMsgs/>
                </cfif>
                 
            </cfif>
        </cfloop>
        
        <!---if successfully validated do Registration Work--->
        <cfset errorMsgs.validatedSuccessfully=true/>
        <cfquery >
        INSERT INTO [dbo].[User] 
        (userId,registrationDate,firstName,lastName,emailid,username,password,dob,bio,isTeacher,yearOfExperience,homeLocation,otherLocation,online)
        VALUES ('15',#now()#,'#arguments.firstName#', '#arguments.lastName#', '#arguments.emailAddress#', 
                '#arguments.username#', '#arguments.password#', '#arguments.dob#','#arguments.bio#',#arguments.isTeacher#,
                #arguments.experience#,0,0,0);

        </cfquery>
        <cfreturn errorMsgs/>

    </cffunction>

    <!---function for checking empty string--->
    <cffunction  name="isEmpty" access="public" returntype="boolean">
        <cfargument  name="text" type="string" required="true">
        <cfif trim(arguments.text) EQ ''>
            <cfreturn true/>
        </cfif>  
        <cfreturn false/>
    </cffunction>

    <!---function to validate valid photo--->
    <cffunction  name="validateProfilePhoto" access="remote" returnformat="json" returntype="struct" output="false"> 
        <cfargument  name="profilePhoto" type="string" required="true"/>
        
    </cffunction>

    <!---function to validate name--->
    <cffunction name="validateName" access="remote" returnformat="json" returntype="struct" output="false">
        <cfargument  name="usrName" type="string" required="true">
        <cfset errorMsg={"error"=""}/>
        <cfif isEmpty(arguments.usrName)>
            <cfset errorMsg.error="Mandatory field!!"/>
            <cfreturn errorMsg/>
        </cfif>
        <cfset name=trim(arguments.usrName)/>
        <cfif NOT isValid("regex", name, "^[A-Za-z']+$")>
            <cfset errorMsg.error="Invalid Name.Only Alphabets allowed without spaces."/>
        <cfelseif len(name) GT 20>
            <cfset errorMsg.error="Should be less than 20 characters!!"/>
        </cfif>
        <cfreturn errorMsg/> 
    </cffunction>

    <!---function to validate email pattern--->
    <cffunction  name="validateEmail" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrEmail" type="string" required="true">
        <cfset email=trim(arguments.usrEmail) />
        <cfset errorMsg={"error"=""}/>
        <cfif email EQ ''>
            <cfset errorMsg.error="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", email,"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")>
            <cfset errorMsg.error="Invalid Email Address."/>
        <cfelse>    
            <cfquery name="emailId">
                SELECT emailId
                FROM [dbo].[User]
                WHERE emailId='#email#';
            </cfquery>
            <cfif emailId.recordCount GTE 1>
                <cfset errorMsg.error = "Email Address Already Exists!!">
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate phone number pattern--->
    <cffunction  name="validatePhoneNumber" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument name="usrPhoneNumber" type="string" required="true">
        <cfset var phoneNumber = arguments.usrPhoneNumber/>
        <cfset var errorMsg={"error"=""}/>
        <cfif phoneNumber EQ ''>
            <cfset errorMsg.error = "Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", phoneNumber, "^[^0-1][0-9]{9}$")>
            <cfset errorMsg.error = "Invalid Phone Number!!Only number Allowed"/>
        <cfelse>
            <cfquery name="phoneNumberExists">
                SELECT phoneNumber
                FROM [dbo].[UserPhoneNumber] 
                WHERE phoneNumber='#phoneNumber#'
            </cfquery>
            <cfif phoneNumberExists.recordCount EQ 1>
                <cfset errorMsg.error = "Phone number already exists!!">
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate username pattern and unique--->
    <cffunction  name="validateUsername" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument name="usrName" type="string" required="true">
        <cfset var username = arguments.usrName/>
        <cfset var errorMsg={"error"=""}/>
        <cfif username EQ ''>
            <cfset errorMsg.error = "Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", username, "^[a-zA-Z0-9_@]+$")>
            <cfset errorMsg.error = "Username should contain only alphabets, numbers, (_ @ .) and 8 characters long"/>
        <cfelse>
            <cfquery name="users">
                SELECT username
                FROM [dbo].[User]
                WHERE username='#username#';
            </cfquery>
            <cfif users.recordCount EQ 1>
                <cfset errorMsg.error = "Username already taken!!">
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate password pattern--->
    <cffunction  name="validatePassword" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrPassword" type="string" required="true">
        <cfset password=trim(arguments.usrPassword)/>
        <cfset var errorMsg={"error"=""}/>
        <cfif password EQ ''>
            <cfset errorMsg.error="Please provide a password!!"/>
        <cfelseif len(password) GT 15 and len(password) LT 8 >
            <cfset errorMsg.error="Password length must be within 8-15!!">
        <cfelseif NOT isValid("regex", password,"^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$")>
            <cfset errorMsg.error="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate valid DOB--->
    <cffunction  name="validateDOB" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrDOB" type="string" required="true">
        <cfset dob=arguments.usrDOB/>
        <cfset errorMsg={"error"=""}/>
        <cfif NOT IsDate(dob)>
            <cfset errorMsg.error="Not a Valid date format!!">
        <cfelse>
            <cfset dob=dateTimeFormat(dob, "MM/dd/yyyy") />
            <cfif Year(dob) GT Year(now())-2 OR Year(dob) LT Year(now())-80 >
                <cfset errorMsg.error = "Should be greater than 2 years and less than 80 years old"/>
            </cfif>
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate any valid text--->
    <cffunction  name="validateText" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrText" type="string" required="true">
        <cfset var text=trim(arguments.usrText)/>
        <cfset errorMsg={"error"=""}/>
        <cfif text EQ ''>
            <cfset errorMsg.error = "Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", text, "^[a-zA-Z0-9\s,'-]*$")>
            <cfset errorMsg.error="Should contain only alphabets, number and ',''/''&' "/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate valid pincode--->
    <cffunction  name="validatePincode" access="remote" output="false" returnType="any">
        <cfargument  name="usrPincode" type="string" required="true">
        <cfset pincode = arguments.usrPincode />
        <cfset errorMsg = {"error"=""}/>
        <cfif pincode EQ ''>
            <cfset errorMsg.error="Mandatory Field"/>
        <cfelseif NOT isValid("regex", pincode, "^[0-9]{6}$")>
            <cfset errorMsg.error = "Invalid Pincode.Must be Number of 6 digit">
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate experience--->
    <cffunction  name="validateExperience" access="remote" output="false" returnType="any">
        <cfargument name="usrExperience" type="string" required="true">
        <cfset experience = trim(arguments.usrExperience)/>
        <cfset errorMsg = {"error"=""}/>
        <cfif experience GT 99 and experience LT 0>
            <cfset errorMsg.error="Experience must be within 0 to 99"/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

</cfcomponent>