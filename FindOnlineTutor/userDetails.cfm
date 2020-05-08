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
<cfset batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset profileServiceObj = createObject("component","FindOnlineTutor.Components.profileService")/>
<!---fetching user details--->
<cfset userDetails = profileServiceObj.getUserDetails(userId = url.user)>


    <div class="container">

        <cfif structKeyExists(userDetails, "error")>
            <p class="w-100 p-5 my-5 alert alert-secondary text-center">
                <cfoutput>
                    #userDetails.error#
                </cfoutput>
            </p>
        <cfelse>
            <!---if the logged in user is a student then his/her all request will be retrieve--->
            <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student'>
                <cfset myRequest = batchServiceObj.getMyRequests()/>
                <!---if successfully batches are retrieved then those will be displayed here--->
                <cfset requestIds = {}>
                <!---looping through the requests and storing it into the structure for further use--->
                <cfloop query="myRequest.Requests">
                    <cfset requestIds['#batchId#'] = '#requestStatus#'>
                </cfloop>
            </cfif>
            <!---displaying the user overview--->
            <div class="p-5">
                <h3 class="text-secondary">Overview:</h3>
                <cfoutput query="userDetails.overview.user">
                    <cfinclude  template="Include/userOverview.cfm">
                </cfoutput>
            </div>
            <!---displaying the user address--->
            <div class="p-5">
                <h3 class="text-secondary">Address:</h3>
                <div class="container border shadow rounded p-4">
                    <cfset currentRow = 1/>
                    <cfoutput query="userDetails.address.address">
                        <small class="text-primary">
                            <cfif currentRow == 1>
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
            <cfif (structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher') OR userDetails.overview.user.isTeacher>
                <div class="p-5">
                    <h3 class="text-secondary">Batches:</h3>
                    <cfif userDetails.batch.batches.recordCount EQ 0>
                        <p class="py-5 m-5 w-100 alert alert-info">This student doesn't have any batches of yours</p>
                    <cfelse>
                        <cfoutput query="userDetails.batch.batches">
                            <cfinclude  template="Include/batchOverview.cfm">
                        </cfoutput>
                    </cfif>
                    
                </div>
            </cfif>
        </cfif>
    </div>
</cf_header>
