<cfcomponent output="false">

    <cffunction  name="validateForm" access="remote" output="false" returnformat="json" returntype="any">

        <cfargument  name="profilePhoto" type="string" required="true">
        <cfargument  name="firstName" type="string" required="true">
        <cfargument  name="lastName" type="string" required="true">
        <cfargument  name="emailAddress" type="string" required="true">
        <cfargument  name="primaryPhoneNumber" type="string" required="true">
        <cfargument  name="alternativePhoneNumber" type="string" required="false">
        <cfargument  name="dob" type="string" required="true">
        <cfargument  name="username" type="string" required="true">
        <cfargument  name="password" type="string" required="true">
        <cfargument  name="confirmPassword" type="string" required="true">
        <cfargument  name="experience" type="string" required="false">
        <cfargument  name="currentAddress" type="string" required="true">
        <cfargument  name="currentCountry" type="string" required="true">
        <cfargument  name="currentState" type="string" required="true">
        <cfargument  name="currentCity" type="string" required="true">
        <cfargument  name="currentPincode" type="string" required="true">
        <cfargument  name="alternativeAddress" type="string" required="false">
        <cfargument  name="alternativeCountry" type="string" required="false">
        <cfargument  name="alternativeState" type="string" required="false">
        <cfargument  name="alternativeCity" type="string" required="false">
        <cfargument  name="alternativePincode" type="string" required="false">
        <cfargument  name="bio" type="string" required="false">

        <cfset errorMsg={}>
        <cfset errorMsg.profilePhoto=validateProfilePhoto(arguments.profilePhoto)>
        <cfset errorMsg.firstName=validateName(arguments.firstName)>
        <cfset errorMsg.lastName=validateName(arguments.lastName)>
        <cfset errorMsg.emailAddress=validateEmail(arguments.emailAddress)>
        <cfset errorMsg.primaryPhoneNumber=validatePhoneNumber(arguments.primaryPhoneNumber)>
        <cfset errorMsg.alternativePhoneNumber=validatePhoneNumber(arguments.alternativePhoneNumber)>
        <cfset errorMsg.dob=validateDOB(arguments.dob)>
        <cfset errorMsg.username=validateUsername(arguments.username)>
        <cfset errorMsg.password=validatePassword(arguments.password)>
        <cfset errorMsg.confirmPassword=validatePassword(arguments.confirmPassword)>
        <cfset errorMsg.experience=validateExperience(arguments.experience)>
        <cfset errorMsg.currentAddress=validateText(arguments.currentAddress)>
        <cfset errorMsg.currentCountry=validateText(arguments.currentCountry)>
        <cfset errorMsg.currentState=validateText(arguments.currentState)>
        <cfset errorMsg.currentCity=validateText(arguments.currentCity)>
        <cfset errorMsg.currentPincode=validatePincode(arguments.currentPincode)>
        <cfset errorMsg.alternativeAddress=validateText(arguments.alternativeAddress)>
        <cfset errorMsg.alternativeCountry=validateText(arguments.alternativeCountry)>
        <cfset errorMsg.alternativeState=validateText(arguments.alternativeState)>
        <cfset errorMsg.alternativeCity=validateText(arguments.alternativeCity)>
        <cfset errorMsg.alternativePincode=validatePincode(arguments.alternativePincode)>
        <cfset errorMsg.bio=validateText(arguments.bio)>
        


    </cffunction>

    

    <cffunction  name="validateProfilePhoto" access="remote" returnformat="json" returntype="struct" output="false">
        <cfargument  name="profilePhoto" type="string" required="true"/>
        
    </cffunction>

    <cffunction  name="validateName" access="remote" returnformat="json" returntype="struct" output="false">
        <cfargument  name="usrName" type="string" required="true">
        <cfset name=trim(arguments.usrName)/>
        <cfset errorMsg={"error"=""}/>
        <cfif name EQ ''>
            <cfset errorMsg.error="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", name, "/^[A-Za-z']+$/")>
            <cfset errorMsg.error="Invalid Name.Only Alphabets allowed without spaces."/>
        <cfelseif len(name) GT 20>
            <cfset errorMsg.error="Should be less than 20 characters!!"/>
        </cfif>
        <cfreturn errorMsg/> 
    </cffunction>

    <cffunction  name="validateEmail" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrEmail" type="string" required="true">
        <cfset email=trim(arguments.usrEmail) />
        <cfset errorMsg={"error"=""}/>
        <cfif email EQ ''>
            <cfset errorMsg.error="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", email,"/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/")>
            <cfset errorMsg.error="Invalid Email Address."/>
        <cfelse>    
            <cfquery name="emailId">
                SELECT emailId
                FROM [dbo].[User]
                WHERE emailId='#email#';
            </cfquery>
            <cfif emailId.recordCount EQ 1>
                <cfset errorMsg.error = "Email Address Already Exists!!">
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <cffunction  name="validatePhoneNumber" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument name="usrPhoneNumber" type="string" required="true">
        <cfset var phoneNumber = arguments.usrPhoneNumber/>
        <cfset var errorMsg={"error"=""}/>
        <cfif phoneNumber EQ ''>
            <cfset errorMsg.error = "Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", phoneNumber, "/^[^0-1][0-9]{9}$/")>
            <cfset errorMsg.error = "Invalid Phone Number!!Only number Allowed">
        <cfelse>
            <cfquery name="phoneNumberExists">
                SELECT phoneNumber
                FROM [dbo].[UserPhoneNumber] 
                WHERE phoneNumber='#phoneNumber#'
            </cfquery>
            <cfif phoneNumberExists.recordCount EQ 1>
                <cfset errorMsg.error = false>
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <cffunction  name="validateUsername" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument name="usrName" type="string" required="true">
        <cfset var username = arguments.usrName/>
        <cfset var errorMsg={"error"=""}/>
        <cfif username EQ ''>
            <cfset errorMsg.error = "Mandatory Field!!"/>
        <cfelseif isValid("regex", username, "/^[a-zA-Z0-9_@]+$/")>
            <cfset errorMsg.error = "Username should contain only alphabets, numbers, (_ @ .) and 8 characters long"/>
        <cfelse>
            <cfquery name="users">
                SELECT username
                FROM [dbo].[User]
                WHERE username='#username#';
            </cfquery>
            <cfif users.recordCount EQ 1>
                <cfset errorMsg.msg = false>
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <cffunction  name="validatePassword" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrPassword" type="string" required="true">
        <cfset password=trim(arguments.usrPassword)/>
        <cfset var errorMsg={"error"=""}/>
        <cfif password EQ ''>
            <cfset errorMsg="Please provide a password!!"/>
        <cfelseif len(password)>15 and len(password)<8 >
            <cfset errorMsg="Password length must be within 8-15!!">
        <cfelseif NOT isValid("regex", password,"/^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$/")>
            <cfset errorMsg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <cffunction  name="validateDOB" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrDOB" type="string" required="true">
        <cfset var dob=arguments.usrDOB/>
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

    <cffunction  name="validateText" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validatePincode" access="public" output="false" returnType="string">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateBio" access="public" output="false" returnType="string">
        <cfargument  name="usrUsername" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateExperience" access="public" output="false" returnType="string">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

</cfcomponent>