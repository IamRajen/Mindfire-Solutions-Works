
<div class="row m-3 p-3 shadow  rounded">

    <p id="batchId" class="hidden"><cfoutput>#batchId#</cfoutput></p>

    <div class="col-md-12 border-bottom pb-2 mb-2">
        <h3 id="batchName" class=" text-dark d-inline"><cfoutput>#batchName#</cfoutput><span id="batchType" class="text-info h6 ml-2"><cfoutput>#batchType#</cfoutput></span></h3>
        
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
                    (structKeyExists(session, "stLoggedInUser") AND (session.stLoggedInUser.role EQ 'Student') )>
                <cfif structKeyExists(requestIds, "#batchId#") AND requestIds["#batchId#"] EQ 'Pending'>
                    <button class="btn button-color float-right d-inline rounded text-light shadow mx-1 disabled">Pending...</button> 
                <cfelseif structKeyExists(requestIds, "#batchId#") AND requestIds["#batchId#"] EQ 'Approved'>
                    <small class="alert alert-success mt-2 text-success d-inline float-right p-1 px-2">Enrolled</small> 
                <cfelse>
                    <button class="btn button-color float-right d-inline rounded text-light shadow mx-1" onclick="enrollStudent(this)">Enroll</button> 
                </cfif>
            </cfif>
        </div>

        <a id="batchDetail" href="batchDetails.cfm?batch=<cfoutput>#batchId#</cfoutput>" class="btn button-color px-3 float-right shadow rounded mx-2"
        <cfif structKeyExists(url, "batch")>
            hidden
        </cfif>
        >Details</a>
    </div>
    
    <div class="col-md-12">
        <span class="text-info h6 mr-2 d-inline">Description: </span>
        <p id="batchDescription" class="d-inline text-dark m-2"><cfoutput>#batchDetails#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <span class="text-info h6 mr-2 d-inline-block">Start Date: </span>
        <p id="batchStartDate" class="text-dark m-2 d-inline-block"><cfoutput>#startDate#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <span class="text-info h6 mr-2 d-inline-block">End Date: </span>
        <p id="batchEndDate" class="d-inline-block text-dark m-2"><cfoutput>#endDate#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <span class="text-info h6 mr-2 d-inline-block">Batch Capacity: </span>
        <p id="batchCapacity" class="d-inline-block text-dark m-2"><cfoutput>#capacity#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <span class="text-info h6 mr-2 d-inline-block">Enrolled: </span>
        <p id="batchEnrolled" class="d-inline-block text-dark m-2"><cfoutput>#enrolled#</cfoutput></p>
    </div> 
    <div class="col-md-4">
        <span class="text-info h6 mr-2 d-inline-block">Fee: </span>
        <p id="batchFee" class="d-inline-block text-dark m-2"><cfoutput>#fee#</cfoutput></p>
    </div> 

    <cfif NOT structKeyExists(url, "batch")>
        <div class="col-md-12 py-2">
            <span class="text-info h6 mr-2">Address: </span>
            <cfif batchType EQ 'online'>
                <p id="batchAddress" class="d-inline text-dark m-2">Online</p>
            <cfelse>
                <p id="batchAddress" class="d-inline text-dark m-2">
                    <cfoutput>#address#, #city#, #state#, #country#-#pincode#</cfoutput>
                </p>
            </cfif>
        </div> 
    </cfif>

    <cfif structKeyExists(session, "stLoggedInUser") AND batchOwnerId EQ session.stLoggedInUser.userId>
        <cfset tag = batchServiceObj.getBatchTag(batchId)/>
        <!---display tag --->
        <div id="batchTagDiv" class="col-md-12 my-2">
            <h6 class="d-inline mx-3">Tags:</h6>
            <cfoutput query="tag.TAGS">
                <cfinclude  template="batchTag.cfm">
            </cfoutput>
        </div>
    </cfif>
</div>
