<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/batchDetails.js">

    <cfif NOT structKeyExists(url, "batch")>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor">
    </cfif>
    
    <!---creating object for getting the batch data--->
    <cfset local.batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>
    <!---getting the information required for this page--->
    <cfset local.batchInfo = local.batchServiceObj.getBatchDetailsById(url.batch)/>

    
    <div class="container">
        
        <cfset local.myRequest = local.batchServiceObj.getMyRequests()/>
        <!---if successfully batches are retrieved then those will be displayed here--->
        <cfset local.requestIds = {}>
        <!---looping through the requests and storing it into the structure for further use--->
        <cfloop query="local.myRequest.Requests">
            <cfset local.requestIds['#batchId#'] = '#requestStatus#'>
        </cfloop>
        <!---if batch information is retrieved succesfully then this if block gets executed--->
        <h1 class="d-inline text-info"><cfoutput>#local.batchInfo.overview.batchName#</cfoutput>
            <span id="batchType" class="text-danger h6 ml-2">
                <cfoutput>#local.batchInfo.overview.batchType#</cfoutput>
            </span>
        </h1>
        <hr>
        <cfoutput query="local.batchInfo.overview">
            <cfinclude  template="../Include/batchOverview.cfm">
        </cfoutput>
        
        <div class="row m-3 mt-5">
            <cfinclude  template="../Include/batchTiming.cfm">
            <!---if the student is enrolled then only notification will display--->
            <cfif  structKeyExists(local.requestIds, "#url.batch#") AND local.requestIds["#url.batch#"] EQ 'Approved'>           
                <cfinclude  template="../Include/batchNotification.cfm">   
            </cfif>
        </div>
        
        <!---if the student is enrolled then only feedback textarea will display--->
        <cfif  structKeyExists(local.requestIds, "#url.batch#") AND local.requestIds["#url.batch#"] EQ 'Approved' AND local.batchInfo.overview.startDate LT now()>
            <div class="container shadow p-3">
                <label class="control-label text-primary"  for="feedback">Feedback:</label>
                <textarea type="text" id="feedback" name="feedback" rows="5"  placeholder="Your feedback here...." class="form-control d-inline"></textarea>
                <span class="text-danger d-block"></span>
                <button id="submitFeedback" class="btn button-color shadow my-2">Submit</button>
            </div>
        </cfif>

        <!---batch feedback--->   
        <h4 class="text-secondary m-2">Batch Feedbacks:</h4>
        <hr>
        <div id="feedbackSection" class="row mt-3">
            <cfoutput query="local.batchInfo.feedback">
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