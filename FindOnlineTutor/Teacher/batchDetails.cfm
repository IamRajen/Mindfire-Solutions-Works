<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/editBatchDetails.js">

    <cfif NOT structKeyExists(url, "batch") OR url.batch EQ ''>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor">
    </cfif>
    <!---creating object for getting the batch data--->
    <cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>
    <!---getting the information required for this page--->
    <cfset batchInfo = batchServiceObj.getBatchDetailsById(url.batch)/>
    <!---all output processes start from here--->

    <cfif structIsEmpty(batchInfo)>
        <p class="alert alert-secondary py-5 w-100 m-5 text-center">Sorry, No such batch exixts</p>
    <cfelse>
        <!---if batch information is retrieved succesfully then this if block gets executed--->
        <h1 class="d-inline text-info"><cfoutput>#batchInfo.overview.batchName#</cfoutput>
            <span id="batchType" class="text-danger h6 ml-2">
                <cfoutput>#batchInfo.overview.batchType#</cfoutput>
            </span>
        </h1>
        <hr>

        <cfoutput query="batchInfo.overview">
            <cfinclude  template="../Include/batchOverview.cfm">
        </cfoutput>

        <cfif session.stLoggedInUser.userId EQ batchInfo.overview.batchOwnerId>
            <div class="row m-3 p-3 shadow rounded  text-center">
                <div class="col-md-3">
                    <h3 class="text-dark">Batch Tag</h3>
                </div>
                <div class="col-md-4">
                    <input type="text" placeholder="add tag..." id="batchTag" name="batchTag" class="form-control d-block">
                    <span class="text-danger d-block"></span>    
                </div>
                <div class="col-md-4">
                    <input type="button" class="btn btn-info px-4" value="Add" onClick="addTag()">
                </div>
            </div>
            <cfinclude  template="../Include/batchAddress.cfm">
        <cfelse>
            <h4 class="text-secondary m-2">Batch Address:</h4>
            <hr>
            <div class="m-3 border p-4 rounded shadow">
                <cfif isQuery(batchInfo.address)>
                    <cfoutput query="batchInfo.Address">
                        <cfinclude  template="../Include/address.cfm">
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
        </cfif>
        
        
        
        <!---this div contains all the other batch deatils except the overview--->
        <div class="row m-3 mt-5">
            <cfinclude  template="../Include/batchTiming.cfm">
            <cfif batchInfo.overview.batchOwnerId EQ session.stLoggedInUser.userId>
                <cfinclude  template="../Include/batchNotification.cfm">
                <cfinclude  template="../Include/batchRequest.cfm">
                <cfinclude  template="../Include/batchEnrolledStudent.cfm">
            </cfif>         
        </div>

        <h4 class="text-secondary">Feedbacks</h4>
        <hr>
        <div class="row my-3">
            <cfif batchInfo.feedback.recordCount EQ 0>
                <p class="alert alert-secondary p-5 d-block w-100 text-center">This batch not have any feedback yet</p>
            <cfelse>
                <cfoutput query="batchInfo.feedback">
                    <cfinclude  template="../Include/batchFeedback.cfm">
                </cfoutput>
            </cfif>
        </div>

        <!---all output processes ends here--->


        <!---all models starts from here--->

            <!---The Edit Batch Timing Modal --->
            <div class="modal fade" id="editBatchTimeModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form id="editBatchTiming">
                            <!---model header--->
                            <div class="modal-header">
                                <h5 class="modal-title"><cfoutput>#batchInfo.overview.batchName#</cfoutput> Batch Time</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <!---div for displaying the msg if some error occurred while retrieving the data--->
                            <div id="errorEditBatchTiming" class="alert alert-danger pt-5 hidden">
                                <p class="d-block text-danger"></p>
                            </div>
                            <!---modal body--->
                            <div id="editBatchTimingModelBody" class="modal-body">
                                <div id="batchTimingDesign">
                                    <!---the edit timing columns will be added here--->
                                </div>    
                            </div>
                            <!---modal footer--->
                            <div id="editBatchTimingfooter" class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">Save changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!--- The Edit Batch Modal --->
            <div class="modal fade" id="editBatchModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form id="editBatchOverview">
                            <!-- Modal Header -->
                            <div class="modal-header">
                                <h4 class="modal-title pl-5">Batch Information</h4>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                            <!---div for displaying the msg if some error occurred while retrieving the data--->
                            <div id="errorEditBatchDetails" class="alert alert-danger pt-5 hidden">
                                <p class="d-block text-danger"></p>
                            </div>
                            
                            <!-- Modal body -->
                            <div id="editBatchOverviewModelBody" class="modal-body">
                                <!---Batch name field--->
                                    <div class="row m-3">
                                        <label class="text-info" class="control-label"  for="batchName">Batch Name:<span class="text-danger">*</span></label>
                                        <div class="col-md-12">
                                            <input type="text" id="editBatchName" name="batchName" placeholder="Batch Name" class="form-control d-block" onblur="checkBatchName(this)">
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                    </div>
                                    
                                <!---Batch type field--->
                                    <div class="row m-3">
                                        <label class="text-info" class="control-label"  for="batchType">Batch Type:<span class="text-danger">*</span></label>
                                        <div class="col-md-12">
                                            <label><input type="radio" name="editBatchType" value="coaching">Coaching Center</label>
                                        </div>
                                        <div class="col-md-12">
                                            <label><input type="radio" name="editBatchType" value="home">Student Home</label>
                                        </div>
                                        <div class="col-md-12">
                                            <label><input type="radio" name="editBatchType" value="online">Online</label>
                                        </div>  
                                    </div>

                                <!---Batch detail--->
                                    <div class="row m-3">
                                        <label class="text-info" for="batchDetail">Batch Details:<span class="text-danger">*</span></label>
                                        <div class="col-md-12">
                                            <textarea class="form-control" rows="5" id="editBatchDetails" onblur="checkBatchDetails(this)"></textarea>
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                    </div>
                                
                                <!---Batch Start date End date--->
                                    <div class="row m-3 ">
                                        <div class="col-md-6">
                                            <label class="text-info" class="control-label"  for="startDate">Start Date:<span class="text-danger">*</span></label>
                                            <input type="date" id="editBatchStartDate" name="startDate" class="form-control d-block" onblur="checkDate(this)">
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-info" class="control-label"  for="endDate">End Date:<span class="text-danger">*</span></label>
                                            <input type="date" id="editBatchEndDate" name="endDate" class="form-control d-block" onblur="checkDate(this)">
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                    </div>
                                <!---Batch Capacity fee--->
                                    <div class="row m-3 ">
                                        <div class="col-md-6">
                                            <label class="text-info" class="control-label"  for="batchCapacity">Batch capacity:<span class="text-danger">*</span></label>
                                            <input type="text" id="editBatchCapacity" name="batchCapacity" class="form-control d-block" onblur="checkCapacityFee(this)"/>
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-info" class="control-label"  for="batchFee">Batch fee(In Rupees):<span class="text-danger">*</span></label>
                                            <input type="text" id="editBatchFee" name="batchFee" class="form-control d-block" onblur="checkCapacityFee(this)">
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                    </div>

                            </div>
                            <!-- Modal footer -->
                            <div id="editBatchOverviewfooter" class="modal-footer">
                                <input type="submit" class="btn btn-danger" value="Done">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!--- The add notification model --->
            <div class="modal fade" id="addBatchNotificationModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form id="addBatchNotification">
                            <!-- Modal Header -->
                            <div class="modal-header">
                                <h4 class="modal-title pl-5">Batch Notification</h4>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                            <!-- Modal body -->
                            <div class="modal-body">
                                <!---Notification title field--->
                                    <div class="row m-3">
                                        <label class="text-info" class="control-label"  for="notificationTitle">Notification Title:<span class="text-danger">*</span></label>
                                        <div class="col-md-12">
                                            <input type="text" id="notificationTitle" name="notificationTitle" placeholder="Notification Title" class="form-control d-block">
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                    </div>

                                <!---Notification detail field--->
                                    <div class="row m-3">
                                        <label class="text-info" for="notificationDetails">Notification Details:<span class="text-danger">*</span></label>
                                        <div class="col-md-12">
                                            <textarea class="form-control" rows="5" id="notificationDetails" name="notificationDetails" placeholder="Details of Notification"></textarea>
                                            <span class="text-danger small float-left"></span>
                                        </div>
                                    </div>
                            </div>
                            <!-- Modal footer -->
                            <div class="modal-footer">
                                <input type="submit" class="btn btn-danger" value="Done">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!--- The view Batch notification Modal --->
            <div class="modal fade" id="viewBatchNotificationModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <!-- Modal Header -->
                        <div class="modal-header">
                            <h4 class="modal-title">Notification</h4>
                            <button class="btn btn-danger d-inline float-right px-3 py-1" onclick="deleteNotification(this)">Delete</button>
                        </div>
                        <!-- Modal body -->
                        <div id="notificationSuccess" class="modal-body">
                            <p id="viewNotificationId" class="hidden"></p>
                            <h4 id="viewNotificationTitle" class="text-primary d-inline"></h4>
                            <small id="viewNotificationDateTime" class="float-right text-secondary d-inline bg-light px-3 border"></small>
                            <p id="viewNotificationDetails" class="alert alert-secondary border p-2 m-2 text-secondary"></p>
                        
                        </div>
                    </div>
                </div>
            </div>

        <!---all models ends here--->


    </cfif>
    
</cf_header>