<!---
Project Name: FindOnlineTutor.
File Name: batch.cfm.
Created In: 26th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a cfm file containing the batches which are been enrolled by the student.
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">

<div class="container">

    <h1>Your enrolled Batches will displayed here</h1>
    <cfset batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset batchInfo = batchServiceObj.getMyBatch()/>
    <div id="batchDiv" class="m-3">
        <cfif structKeyExists(batchInfo, "error")>
            <div class="alert alert-danger pt-3 pb-3 rounded-top">
                <p class="text-danger text-center"><cfoutput>#batchInfo.error#</cfoutput></p>
            </div>
        <cfelseif batchInfo.batches.recordCount EQ 0>
            <div class="alert alert-secondary pt-5 pb-5 rounded-top">
                <p class="text-secondary text-center">You haven't created any batch. You can create it by clicking on "Add New Batch" button at top right side.</p>
            </div>
        <cfelse>
            <cfoutput query="batchInfo.batches">
                <cfinclude  template="../Include/batchOverview.cfm">
                <!---
                <a href="batchesDetails.cfm?id=#batchId#" class="row m-3 p-3 shadow rounded">
                    <div class="col-md-12 border-bottom pb-2">
                        <h3 class=" text-dark d-inline">#batchName#<span class="text-info h6 ml-2">#batchType#</span></h3>
                        <small class="bg-danger float-right d-inline rounded p-1 text-light mx-1">Notification</small> 
                    </div>
                    
                    <div class="col-md-12">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Description: </span>#batchDetails#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Start Date: </span>#startDate#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">End Date: </span>#endDate#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Batch Capacity: </span>#capacity#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Enrolled: </span>#enrolled#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Fee: </span>#fee#</p>
                    </div> 
                    
                </a>--->
            </cfoutput>
        </cfif>
    </div>
</div>
</cf_header>