<!---
Project Name: FindOnlineTutor.
File Name: databaseService.cfc.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file has services/functions related to the data in the database.
--->

<cfcomponent output="false">

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

</cfcomponent>