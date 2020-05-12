
<div class="row m-3 p-3 shadow  rounded">

    <p id="batchId" class="hidden"><cfoutput>#batchId#</cfoutput></p>

    <div class="col-md-12 border-bottom pb-2 mb-2">
        <h3 class=" text-dark d-inline"><cfoutput>#batchName#</cfoutput><span class="text-info h6 ml-2"><cfoutput>#batchType#</cfoutput></span></h3>
        <div id="requestStatus" class="d-inline">

            <!---if logged in user is a teacher--->
            <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
                <!---if logged in user batch will displayed it will have a edit button on it--->
                <cfif structKeyExists(url, "batch") AND session.stLoggedInUser.userId EQ batchOwnerId>
                    <button class="btn button-color d-inline float-right px-3 py-1" data-toggle="modal" data-target="#editBatchModal" onclick="loadBatchOverview()">Edit</button>
                </cfif>

            <!---if user not logged in  or visitor--->
            <cfelseif NOT structKeyExists(session, "stLoggedInUser")>
                <button class="btn button-color px-3 float-right shadow rounded disabled">Enroll</a>
                
            <!---if user is a student or any user details having having is been displayed--->
            <cfelseif structKeyExists(url, "user") OR 
                    (structKeyExists(session, "stLoggedInUser") AND (session.stLoggedInUser.role EQ 'Student') AND (structKeyExists(url, "batch")) )>
                <cfif structKeyExists(requestIds, "#batchId#") AND requestIds["#batchId#"] EQ 'Pending'>
                    <button class="btn button-color float-right d-inline rounded text-light shadow mx-1 disabled">Pending...</button> 
                <cfelseif structKeyExists(requestIds, "#batchId#") AND requestIds["#batchId#"] EQ 'Approved'>
                    <small class="alert alert-success mt-2 text-success d-inline float-right p-1 px-2">Enrolled</small> 
                <cfelse>
                    <button class="btn button-color float-right d-inline rounded text-light shadow mx-1" onclick="enrollStudent(this)">Enroll</button> 
                </cfif>
            </cfif>
        </div>
        <a href="batchDetails.cfm?batch=<cfoutput>#batchId#</cfoutput>" class="btn button-color px-3 float-right shadow rounded mx-2"
        <cfif structKeyExists(url, "batch")>
            hidden
        </cfif>
        >Details</a>
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

    <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher' AND structKeyExists(batchInfo, "tag")>
        <!---display tag --->
        <div id="batchTagDiv" class="col-md-12 my-2">
            <h6 class="d-inline mx-3">Tags:</h6>
            <cfoutput query="batchInfo.Tag.TAGS">
                <cfinclude  template="batchTag.cfm">
            </cfoutput>
        </div>
    </cfif>
</div>
