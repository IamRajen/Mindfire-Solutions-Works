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
        <cfset var userAddress=''/>
        <cfset var userPhoneNumber=''/>
        <cfset var profileInfo = {}/>
        <cftry>
            <cfquery name="userDetails">
                SELECT firstName, lastName, emailId, username, password, dob, yearOfExperience, homeLocation, otherLocation, online, bio
                FROM [dbo].[User]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
            <cfquery name="userAddress">
                SELECT address,country,state,city,pincode
                FROM [dbo].[UserAddress]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
            <cfquery name="userPhoneNumber">
                SELECT phoneNumber 
                FROM [dbo].[UserPhoneNumber]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>

        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
            <cfset profileInfo.error="Some Error occurred while fetching the data. Please, try after sometimes!!"/>
        </cfcatch>

        </cftry>
        <cfif NOT structKeyExists(profileInfo, "error")>
            <cfset profileInfo.userDetails=#userDetails#/>
            <cfset profileInfo.userAddress=#userAddress#/>
            <cfset profileInfo.userPhoneNumber=#userPhoneNumber#/>
        </cfif>
        <cfreturn profileInfo/>

    </cffunction>

</cfcomponent>