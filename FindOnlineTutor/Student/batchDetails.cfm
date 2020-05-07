<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/batchDetails.js">

    <cfif NOT structKeyExists(url, "batch")>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor">
    </cfif>
    
    <!---creating object for getting the batch data--->
    <cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>
    <!---getting the information required for this page--->
    <cfset batchInfo = batchServiceObj.getBatchDetailsById(url.batch)/>
    
    <div class="container">
        <cfset myRequest = batchServiceObj.getMyRequests()/>
        <!---if successfully batches are retrieved then those will be displayed here--->
        <cfset requestIds = {}>
        <!---looping through the requests and storing it into the structure for further use--->
        <cfloop query="myRequest.Requests">
            <cfset requestIds['#batchId#'] = '#requestStatus#'>
        </cfloop>
        <!---if batch information is retrieved succesfully then this if block gets executed--->
        <h1 class="d-inline text-info"><cfoutput>#batchInfo.overview.batch.batchName#</cfoutput><span id="batchType" class="text-danger h6 ml-2"><cfoutput>#batchInfo.overview.batch.batchType#</cfoutput></span></h1>
        <hr>
        <cfoutput query="batchInfo.overview.batch">
            <cfinclude  template="../Include/batchOverview.cfm">
        </cfoutput>
        
        <div class="row m-3 mt-5">
            <cfinclude  template="../Include/batchTiming.cfm">
            <cfinclude  template="../Include/batchNotification.cfm">   
        </div>
        <div class="container shadow p-3">
            <label class="control-label text-primary"  for="feedback">Feedback:</label>
			<textarea type="text" id="feedback" name="feedback" rows="5"  placeholder="Your feedback here...." class="form-control d-inline"></textarea>
            <span></span>
			<button id="submitFeedback" class="btn button-color shadow my-2">Submit</button>
        </div>
        <div id="feedbackSection" class="row mt-3">
            <cfoutput query="batchInfo.feedback.feedback">
                <cfinclude  template="../Include/batchFeedback.cfm">
            </cfoutput>
        </div>
    </div>

    <div class="modal fade" id="showNotification">
        <div class="modal-dialog">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title pl-2">Notification Details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <!-- Modal body -->
                <div class="modal-body">
                    <h4 id="notificationTitle" class="text-primary d-inline"></h4>
                    <small id="notificationDateTime" class="float-right text-secondary d-inline bg-light px-3 border"></small>
                    <p id="notificationDetail" class="alert alert-secondary border p-2 m-2 text-secondary"></p>
                </div>
                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn button-color shadow" data-dismiss="modal">Done</button>
                </div>
            </div>
        </div>
    </div>
</cf_header>