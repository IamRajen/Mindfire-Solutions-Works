
<div class="row m-3 p-3 shadow  rounded">

    <p id="batchId" class="hidden"><cfoutput>#batchId#</cfoutput></p>

    <div class="col-md-12 border-bottom pb-2 mb-2">
        <h3 class=" text-dark d-inline"><cfoutput>#batchName#</cfoutput><span class="text-info h6 ml-2"><cfoutput>#batchType#</cfoutput></span></h3>
        
        <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
            <cfif structKeyExists(url, "batch")>
                <button class="btn button-color d-inline float-right px-3 py-1" data-toggle="modal" data-target="#editBatchModal" onclick="loadBatchOverview()">Edit</button>
            <cfelse>
                <a href="batchDetails.cfm?batch=<cfoutput>#batchId#</cfoutput>" class="btn button-color px-3 float-right shadow rounded">Details</a>
            </cfif>
        <cfelseif structKeyExists(url, "user") OR (structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student' AND NOT structKeyExists(url, "batch"))>
            <a href="batchDetails.cfm?batch=<cfoutput>#batchId#</cfoutput>" class="btn button-color px-3 float-right shadow rounded">Details</a>
        </cfif>
    </div>
    
    <div class="col-md-12">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Description: </span><cfoutput>#batchDetails#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Start Date: </span><cfoutput>#startDate#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">End Date: </span><cfoutput>#endDate#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Batch Capacity: </span><cfoutput>#capacity#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Enrolled: </span><cfoutput>#enrolled#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Fee: </span><cfoutput>#fee#</cfoutput></p>
    </div> 
</div>