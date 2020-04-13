<!---
Project Name: FindOnlineTutor.
File Name: databaseService.cfc.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file has services/functions related to the data in the database.
--->

<cfcomponent output="false">

    <!---get user details--->
    <cffunction  name="getMyProfile" access="public" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var userDetails=''/>
        <cfset var userPhoneNumber={}/>
        <cfset var profileInfo = {}/>
        <cftry>
            <cfquery name="userDetails">
                SELECT firstName, lastName, emailId, username, password, dob, yearOfExperience, homeLocation, otherLocation, online, bio
                FROM [dbo].[User]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>

            <cfset userPhoneNumber = getMyPhoneNumber(#arguments.userId#)/>

        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
            <cfset profileInfo.error="Some Error occurred while fetching the profile data. Please, try after sometimes!!"/>
        </cfcatch>

        </cftry>
        <cfif NOT structKeyExists(profileInfo, "error")>
            <cfset profileInfo.userDetails=#userDetails#/>
            <cfset profileInfo.userPhoneNumber=#userPhoneNumber#/>
        </cfif>
        <cfreturn profileInfo/>

    </cffunction>

    <!---get user addresses--->
    <cffunction  name="getMyAddress" access="remote" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var userAddress={}/>
        <cfset var address = ''>
        <cftry>
            <cfquery name="address">
                SELECT address,country,state,city,pincode
                FROM [dbo].[UserAddress]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
            <cfset userAddress.error="Some Error occurred while fetching the data. Please, try after sometimes!!"/>
        </cfcatch>
        </cftry>
        <cfset userAddress.address = address>
        <cfreturn userAddress/>
    </cffunction>

    <!---get user phone number--->
    <cffunction  name="getMyPhoneNumber" access="remote" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var userPhoneNumber={}/>
        <cfset var phoneNumber = ''>
        <cftry>
            <cfquery name="phoneNumber">
                SELECT phoneNumber 
                FROM [dbo].[UserPhoneNumber]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
            <cfset userPhoneNumber.error="Some Error occurred while fetching the phone numbers. Please, try after sometimes!!"/>
        </cfcatch>
        </cftry>
        <cfset userPhoneNumber.phoneNumber = phoneNumber/>
        <cfreturn userPhoneNumber/>
    </cffunction>

    <!---function to get the userId with respect to the username--->
    <cffunction name="getUserId" access="remote" output="false" returntype="struct" returnformat='json'>
        <cfargument  name="username" type="string" required="true">
        <cfset var userId = {} />
        <cftry>
            <cfquery name="id">
                SELECT userId
                FROM [dbo].[User]
                WHERE username=<cfqueryparam value="#arguments.username#" cfsqltype='cf_sql_varchar'>
            </cfquery>
        <cfcatch type="any">
            <cflog text="#arguments.username# : #cfcatch.detail#">
            <cfset userId.error="failed to retrieve user id. Please, try after sometime!!"/>
        </cfcatch>
        </cftry>
        <cfset userId.id=id.userId/>
        <cfreturn userId />
    </cffunction>


    <!---update user profile--->
    <!---<cffunction  name="updateUserProfile" output="false">
        <!---arguments declaration--->
        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="primaryPhoneNumber" type="string" required="true"/>
        <cfargument  name="alternativePhoneNumber" type="string" required="false"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="password" type="string" required="true"/>
        <cfargument  name="confirmPassword" type="string" required="true"/>
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

        <!---creating object of validation.cfc for validation--->
        <cfset var validationObj = createObject("component","FindOnlineTutor/Components/validation");

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset errorMsgs={}>
        <cfset errorMsgs["validatedSuccessfully"]=true/>
        <!--- <cfset errorMsg.profilePhoto=validateProfilePhoto(arguments.profilePhoto)> --->
        <cfset errorMsgs["firstName"]=validationObj.validateName(arguments.firstName)/>
        <cfset errorMsgs["lastName"]=validationObj.validateName(arguments.lastName)/>
        <cfset errorMsgs["emailAddress"]=validationObj.validateEmail(arguments.emailAddress)/>
        <cfset errorMsgs["primaryPhoneNumber"]=validationObj.validatePhoneNumber(arguments.primaryPhoneNumber)/>

        <cfif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber NEQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]=validationObj.validatePhoneNumber(arguments.alternativePhoneNumber)/>
        <cfelseif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber EQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]="Alternative number should not be same.You can keep this blank."/>
        </cfif>

        <cfset errorMsgs["dob"]=validateDOB(arguments.dob)/>
        <cfset errorMsgs["password"]=validationObj.validatePassword(arguments.password)/>

        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset errorMsgs["confirmPassword"]="password not matched!!"/>
        </cfif>

        
        <cfset errorMsgs["currentAddress"]=validationObj.validateText(arguments.currentAddress)/>
        <cfset errorMsgs["currentCountry"]=validationObjvalidateText(arguments.currentCountry)/>
        <cfset errorMsgs["currentState"]=validationObj.validateText(arguments.currentState)/>
        <cfset errorMsgs["currentCity"]=validationObj.validateText(arguments.currentCity)/>
        <cfset errorMsgs["currentPincode"]=validationObj.validatePincode(arguments.currentPincode)/>

        <cfif arguments.havingAlternativeAddress>
            <cfset errorMsgs["alternativeAddress"]=validationObjvalidateText(arguments.alternativeAddress)/>
            <cfset errorMsgs["alternativeCountry"]=validationObj.validateText(arguments.alternativeCountry)/>
            <cfset errorMsgs["alternativeState"]=validationObj.validateText(arguments.alternativeState)/>
            <cfset errorMsgs["alternativeCity"]=validationObj.validateText(arguments.alternativeCity)/>
            <cfset errorMsgs["alternativePincode"]=validationObj.validatePincode(arguments.alternativePincode)/>
        </cfif>
        
        <cfif arguments.bio NEQ ''>
            <cfset errorMsgs["bio"]=validationObj.validateText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully'>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfif errorMsgs[key] NEQ ''>
                    <cfreturn errorMsgs/>
                </cfif> 
            </cfif>
        </cfloop>



    </cffunction>--->

</cfcomponent>