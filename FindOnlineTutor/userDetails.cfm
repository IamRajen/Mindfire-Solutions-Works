<!---
Project Name: FindOnlineTutor.
File Name: userDetails.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: This page will be only displayed to all. And contains information about the user
--->
<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" scriptPath="Script/searchBatch.js">

    <cfif NOT structKeyExists(url, 'user') OR url.user EQ ''>
        <cflocation  url="assignments_mindfire/FindOnlineTutor/">
    </cfif>

    <!---creating objects--->
    <cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset local.profileServiceObj = createObject("component","FindOnlineTutor.Components.profileService")/>
    <!---fetching user details--->
    <cfset local.userDetails = local.profileServiceObj.getUserDetails(userId = url.user)>


    <div class="container">
        <!---if the logged in user is a student then his/her all request will be retrieve--->
        <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student'>
            <cfset local.myRequest = local.batchServiceObj.getMyRequests()/>
            <!---if successfully batches are retrieved then those will be displayed here--->
            <cfset local.requestIds = {}>
            <!---looping through the requests and storing it into the structure for further use--->
            <cfloop query="local.myRequest.Requests">
                <cfset local.requestIds['#batchId#'] = '#requestStatus#'>
            </cfloop>
        </cfif>
        <!---displaying the user overview--->
        <div class="p-5">
            <h3 class="text-secondary">Overview:</h3>
            <cfoutput query="local.userDetails.overview">
                <cfinclude  template="Include/userOverview.cfm">
            </cfoutput>
        </div>
        <!---displaying the user address--->
        <div class="p-5">
            <h3 class="text-secondary">Address:</h3>
            <div class="container border shadow rounded p-4">
                <cfset local.currentRow = 1/>
                <cfoutput query="local.userDetails.address">
                    <small class="text-primary">
                        <cfif local.currentRow == 1>
                            Current Address : 
                        <cfelse>
                            Alternative Address : 
                        </cfif>
                    </small>
                    <cfinclude  template="Include/address.cfm">
                </cfoutput>
            </div>
        </div>
        <!---displaying the batches overview if and only if user is teacher--->
        <cfif (structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher') OR local.userDetails.overview.isTeacher>
            <div class="p-5">
                <h3 class="text-secondary">Batches:</h3>
                <cfif local.userDetails.batch.recordCount EQ 0>
                    <cfif local.userDetails.overview.isTeacher>
                        <p class="py-5 m-5 w-100 alert alert-info text-center">This Teacher doesn't have any Batches</p>
                    <cfelse>
                        <p class="py-5 m-5 w-100 alert alert-info  text-center">This student doesn't have any Batches of yours</p>
                    </cfif>
                <cfelse>
                    <cfoutput query="local.userDetails.batch">
                        <cfinclude  template="Include/batchOverview.cfm">
                    </cfoutput>
                </cfif>
                
            </div>
        </cfif>
    </div>
</cf_header>
