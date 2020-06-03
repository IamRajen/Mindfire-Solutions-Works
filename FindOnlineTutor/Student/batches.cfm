<!---
Project Name: FindOnlineTutor.
File Name: batch.cfm.
Created In: 26th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a cfm file containing the batches which are been enrolled by the student.
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">
    <!---creating component object and retrieving batches of user--->
    <cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset local.batchInfo = local.batchServiceObj.getMyBatch()/>
    <cfset local.myRequest = local.batchServiceObj.getMyRequests()/>
    <!---if successfully batches are retrieved then those will be displayed here--->
    <cfset local.requestIds = {}>
    <!---looping through the requests and storing it into the structure for further use--->
    <cfloop query="local.myRequest.Requests">
        <cfset local.requestIds['#batchId#'] = '#requestStatus#'>
    </cfloop>

    <div class="container">
        <h1 class="my-5 text-sencondary">Your enrolled Batches will displayed here</h1>
        
        <div id="batchDiv" class="m-3">
            <cfif local.batchInfo.batch.recordCount EQ 0>
                <div class="alert alert-secondary pt-5 pb-5 rounded-top">
                    <p class="text-secondary text-center">You haven't created any batch. You can create it by clicking on "Add New Batch" button at top right side.</p>
                </div>
            <cfelse>
                <cfoutput query="local.batchInfo.batch">
                    <cfinclude  template="../Include/batchOverview.cfm">
                </cfoutput>
            </cfif>
        </div>
    </div>

</cf_header>