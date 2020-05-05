<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">

    <cfif NOT structKeyExists(url, "batch")>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor">
    </cfif>
    <!---creating object for getting the batch data--->
    <cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>
    <!---getting the information required for this page--->
    <cfset batchInfo = batchServiceObj.getBatchDetailsByID(url.batch)/>
    
    <div class="container">
        <cfif NOT structKeyExists(batchInfo, "error")>
            <!---if batch information is retrieved succesfully then this if block gets executed--->
            
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
            
            <div class="row m-3 mt-5">
                <cfinclude  template="Include/batchTiming.cfm">  
            </div>
            
            <h4 class="text-secondary m-2">Batch Feedbacks:</h4>
            <hr>
            <div class="row mt-3">
                <cfif batchInfo.feedback.feedback.recordCount EQ 0>
                    <p class="alert alert-secondary p-5 d-block w-100 text-center">This batch not have any feedback yet</p>
                <cfelse>
                    <cfoutput query="batchInfo.Feedback.feedback">
                        <cfinclude  template="Include/batchFeedback.cfm">
                    </cfoutput>
                </cfif>
            </div>
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