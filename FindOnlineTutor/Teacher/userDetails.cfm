<!---
Project Name: FindOnlineTutor.
File Name: teachersDetails.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the detail information about the teacher
--->

<cfset local.profileServiceObj = createObject("component","FindOnlineTutor.Components.profileService")/>
<cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset local.userDetails = local.profileServiceObj.getUserDetails(userId = url.user)>


<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">

<div class="container">
    
    <div class="p-5">
        <h3 class="text-secondary">Overview:</h3>
        <cfoutput query="local.userDetails.overview">
            <cfinclude  template="../Include/userOverview.cfm">
        </cfoutput>
    </div>

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
                <cfinclude  template="../Include/address.cfm">
            </cfoutput>
        </div>
    </div>

    <div class="p-5">
        <h3 class="text-secondary">Batches:</h3>
        <cfoutput query="local.userDetails.batch">
            <cfinclude  template="../Include/batchOverview.cfm">
        </cfoutput>
    </div>
</div>
</cf_header>