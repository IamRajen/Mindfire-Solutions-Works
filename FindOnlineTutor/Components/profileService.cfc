<!---
Project Name: FindOnlineTutor.
File Name: profileService.cfc.
Created In: 6th May 2020
Created By: Rajendra Mishra.
Functionality: This file contains some functions helps in user profile.
--->

<cfcomponent output="false">
    <cfset databaseServiceObj = createObject("component","databaseService")/>
    <!---function to get the user profile information--->
    <cffunction  name="getUserDetails" output="false" access="remote" returntype="struct" retrunformat="json">
        <!---arguments--->
        <cfargument  name="userId" type="numeric" required="true">
        <!---structure to store the function information--->
        <cfset var getUserDetailsInfo = {}/>
        <!---process starts from here--->
        <cftry>
            <!---user overview--->
            <cfset getUserDetailsInfo.overview = databaseServiceObj.getUser(userId = arguments.userId)/>
            <cfif structKeyExists(getUserDetailsInfo.overview, "error")>
                <cfthrow detail="#getUserDetailsInfo.overview.error#"/>
            </cfif>

            <!---user address--->
            <cfset getUserDetailsInfo.address = databaseServiceObj.getMyAddress(arguments.userId)>
            <cfif structKeyExists(getUserDetailsInfo.address, "error")>
                <cfthrow detail = "#getUserDetailsInfo.address.error#">
            </cfif>

            <!---user batch--->
            <cfif getUserDetailsInfo.overview.user.isTeacher EQ 1>
                <cfset getUserDetailsInfo.batch = databaseServiceObj.getUserBatch(teacherId=arguments.userId)/>
            <cfelse>
                <cfset getUserDetailsInfo.batch = databaseServiceObj.getUserBatch(studentId=arguments.userId)/>
            </cfif>
            <cfif structKeyExists(getUserDetailsInfo.batch, "error")>
                <cfthrow detail = "#getUserDetailsInfo.batch.error#">
            </cfif>

        <cfcatch type="any">
            <cflog  text="profileService: getUserDetails()-> #cfcatch# #cfcatch.detail#">
            <cfset getUserDetailsInfo.error = "Some error occurred.Please try after sometime">
        </cfcatch>
        </cftry>
        <cfreturn getUserDetailsInfo/>
    </cffunction>
</cfcomponent>