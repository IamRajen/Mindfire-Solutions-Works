<!---
Project Name: FindOnlineTutor.
File Name: batchDetails.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: This page will be only displayed to students and visitors
--->
<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">

    <!---if batch id is not present in the url then it will be shifted to homepage--->
    <cfif NOT structKeyExists(url, "batch") OR url.batch EQ ''>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor">
    <!---else if any teachers try to go to this link then he/she will be shifted to their teachers section--->
    <cfelseif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor/Teacher/batchDetails.cfm?batch=#url.batch#">
    </cfif>

    <!---creating object for getting the batch data--->
    <cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>
    <!---getting the information required for this page--->
    <cfset batchInfo = batchServiceObj.getBatchDetailsByID(url.batch)/>

    <div class="container">
        <cfif NOT structKeyExists(batchInfo, "error")>
            <!---if batch information is retrieved succesfully then this if block gets executed--->
            <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student'>
                <cfset myRequest = batchServiceObj.getMyRequests()/>
                <!---if successfully batches are retrieved then those will be displayed here--->
                <cfset requestIds = {}>
                <!---looping through the requests and storing it into the structure for further use--->
                <cfloop query="myRequest.Requests">
                    <cfset requestIds['#batchId#'] = '#requestStatus#'>
                </cfloop>
            </cfif>
            <h4 class="text-secondary m-2">Batch Overview:</h4>
            <hr>
            <cfoutput query="batchInfo.overview.batch">
                <cfinclude  template="Include/batchOverview.cfm">
            </cfoutput>
             

            <h4 class="text-secondary m-2">Batch Address:</h4>
            <hr>
            <div class="m-3 border p-4 rounded shadow">
                <cfif isStruct(batchInfo.address)>
                    <cfoutput query="batchInfo.Address.Address">
                        <cfinclude  template="Include/address.cfm">
                    </cfoutput>
                <cfelseif batchInfo.address EQ ''>
                    <p>No information is available</p>
                <cfelseif batchInfo.address NEQ ''>
                    <span>Link:-</span>
                    <a href="<cfoutput>#batchInfo.address#</cfoutput>">
                        <cfoutput>
                            #batchInfo.address#
                        </cfoutput>
                    </a>
                </cfif>
                
            </div>
            
            <!---timing,notification--->
            <div class="row m-3 mt-5">
                <cfinclude  template="Include/batchTiming.cfm">
                <cfif   structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student' AND 
                        structKeyExists(requestIds, "#url.batch#") AND requestIds["#url.batch#"] EQ 'Approved'>

                    <cfinclude  template="Include/batchNotification.cfm">
                </cfif>     
            </div>

            <cfif   structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student' AND 
                    structKeyExists(requestIds, "#url.batch#") AND requestIds["#url.batch#"] EQ 'Approved'>  
                      
                <!---feedback textarea for only enrolled student--->
                <div class="container shadow p-3">
                    <label class="control-label text-primary"  for="feedback">Feedback:</label>
                    <textarea type="text" id="feedback" name="feedback" rows="5"  placeholder="Your feedback here...." class="form-control d-inline"></textarea>
                    <span></span>
                    <button id="submitFeedback" class="btn button-color shadow my-2">Submit</button>
                </div>
            </cfif>

             <!---batch feedback--->   
            <h4 class="text-secondary m-2">Batch Feedbacks:</h4>
            <hr>
            <div id="feedbackSection" class="row mt-3">
                <cfif batchInfo.feedback.feedback.recordCount EQ 0>
                    <p class="alert alert-secondary p-5 d-block w-100 text-center">This batch not have any feedback yet</p>
                <cfelse>
                    <cfoutput query="batchInfo.Feedback.feedback">
                        <cfinclude  template="Include/batchFeedback.cfm">
                    </cfoutput>
                </cfif>
            </div>
        <!---if some error occurred then it will so some error msg---> 
        <cfelseif structKeyExists(batchInfo, "error")>
            <p class="m-5 py-5 text-center alert alert-danger w-100">batchInfo.error</p>
        </cfif>
        
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