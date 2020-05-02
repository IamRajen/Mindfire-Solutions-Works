
<div class="row m-3 p-3 shadow  rounded">
    <p id="batchId" class="hidden"><cfoutput>#batchInfo.overview.batch.batchId#</cfoutput></p>
    <div class="col-md-12 border-bottom pb-2 mb-2">
        <h3 class=" text-dark d-inline">Overview</h3>
        <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
            <button class="btn btn-danger d-inline float-right px-3 py-1" data-toggle="modal" data-target="#editBatchModal" onclick="loadBatchOverview()">Edit</button>
        </cfif>
    </div>
    
    <div class="col-md-12">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Description: </span><cfoutput>#batchInfo.overview.batch.batchDetails#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Start Date: </span><cfoutput>#batchInfo.overview.batch.startDate#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">End Date: </span><cfoutput>#batchInfo.overview.batch.endDate#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Batch Capacity: </span><cfoutput>#batchInfo.overview.batch.capacity#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Enrolled: </span><cfoutput>#batchInfo.overview.batch.enrolled#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Fee: </span><cfoutput>#batchInfo.overview.batch.fee#</cfoutput></p>
    </div> 
</div>