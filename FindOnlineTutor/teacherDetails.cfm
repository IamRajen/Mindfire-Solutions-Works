<!---
Project Name: FindOnlineTutor.
File Name: teachersDetails.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the detail information about the teacher
--->

<cfset databaseServiceObj = createObject("component","FindOnlineTutor.Components.databaseService")/>
<cfset userOverview = databaseServiceObj.getTeacher(userId=url.user)/>
<cfset userAddress = databaseServiceObj.getMyAddress(url.user)/>
<cfset userBatch = databaseServiceObj.collectTeacherBatch(teacherId=url.user)/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">
<div class="container">
    <div class="p-5">
        <h3 class="text-secondary">Overview:</h3>
        <cfoutput query="userOverview.user">
            <cfinclude  template="Include/userOverview.cfm">
        </cfoutput>
    </div>
    <div class="p-5">
        <h3 class="text-secondary">Address:</h3>
        <div class="container border shadow rounded p-4">
            <cfset currentRow = 1/>
            <cfoutput query="userAddress.address">
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

    <div class="p-5">
        <h3 class="text-secondary">Batches:</h3>
        <cfoutput query="userBatch.batches">
            <cfinclude  template="Include/batchOverview.cfm">
        </cfoutput>
    </div>
</cf_header>