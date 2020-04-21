<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/editBatchDetails.js">

    <cfif NOT structKeyExists(url, "id")>
        <cflocation  url="/assignments_mindfire/FindOnlineTutor">
    </cfif>
    <!---creating object for getting the batch data--->
    <cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>

    <!---getting the information required for this page--->
    <cfset batchInfo = batchServiceObj.getBatchDetailsById(url.id)/>

    <!---all output processes start from here--->
    <cfif structKeyExists(batchInfo.overview, "batch")>
        <!---if batch information is retrieved succesfully then this if block gets executed--->
        <h1 class="d-inline text-info"><cfoutput>#batchInfo.overview.batch.batchName#</cfoutput><span class="text-danger h6 ml-2"><cfoutput>#batchInfo.overview..batch.batchType#</cfoutput></span></h1>
        <hr>

        <!---Batch Overview Section start from here--->
        <div class="row m-3 p-3 shadow bg-light rounded">
            <p id="batchId" class="hidden"><cfoutput>#batchInfo.overview.batch.batchId#</cfoutput></p>
            <div class="col-md-12 border-bottom pb-2 mb-2">
                <h3 class=" text-dark d-inline">Overview</h3>
                <button class="btn btn-danger d-inline float-right px-3 py-1" data-toggle="modal" data-target="#editBatchModal" onclick="loadBatchOverview()">Edit</button>
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
        <!---Notication Section ends here--->
        
        <!---this div contains all the other batch deatils except the overview--->
        <div class="row m-3 mt-5">
            <!---Batch timing Section start from here--->
            <cfif structKeyExists(batchInfo.timing, "time")>
                <!---displaying the batch timing--->
                
                    <div class="col-md-6 p-3 mb-4 shadow bg-light rounded">

                        <h3 class=" text-dark d-inline">Timing</h3>
                        <button class="btn btn-danger d-inline float-right px-3 py-1" data-toggle="modal" data-target="#editBatchTimeModal" onclick="loadBatchTiming()">Edit</button>
                        <hr>
                        <!---if no timing available a blank msg while be diplayed--->
                        <!---display the timing with specific day--->
                        <table class="table table-striped">
                            <thead>
                                <tr  class="bg-info">
                                <th class=" text-light" scope="col">Day</th>
                                <th class=" text-light" scope="col">Start Time</th>
                                <th class=" text-light" scope="col">End Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!---looping over the array of batch timing--->
                                <cfloop from="1" to="#arrayLen(batchInfo.timing.time)#" index="i">
                                    <!---getting the key of structure containing the data--->
                                    <cfset key = structKeyList(batchInfo.timing.time[i])/>
                                    <cfoutput>
                                        <tr>
                                            <th scope="row">#key#</th>
                                            <td>
                                                <cfif structIsEmpty(batchInfo.timing.time[i][key])>
                                                    -- : --
                                                <cfelse>
                                                    #timeFormat(batchInfo.timing.time[i][key].startTime)#
                                                </cfif>
                                            </td>
                                            <td>
                                                <cfif structIsEmpty(batchInfo.timing.time[i][key])>
                                                    -- : --
                                                <cfelse>
                                                    #timeFormat(batchInfo.timing.time[i][key].endTime)#
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfoutput>
                                </cfloop>
                            </tbody>
                        </table>
                    
                    </div>
            <cfelseif structKeyExists(batchInfo.timing, "error")>
                <!---if some error occurred while retriving the timing of batch an error msg while be diplayed--->
                <div class="alert alert-danger pt-3 m-2 mb-5">
                    <p class="d-block text-danger m-2"><cfoutput>#batchInfo.timing.error#</cfoutput></p>
                </div>
            </cfif> 
            <!---Batch timing Section ends here--->

            <!---Notication Section start from here--->

            <!---Notication Section ends here--->

            <!---Request Section start from here--->

            <!---Request Section ends here--->

            <!---Enrolled Section start from here--->

            <!---Enrolled Section ends here--->
            
        </div>

        <!---Feedback Section start from here--->

        <!---Feedback Section end here--->

        <!---all output processes ends here--->

        <!---all models starts from here--->
        <!---The Edit Batch Timing Modal --->
        <div class="modal fade" id="editBatchTimeModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="editBatchTiming">
                        <!---model header--->
                        <div class="modal-header">
                            <h5 class="modal-title"><cfoutput>#batchInfo.overview.batch.batchName#</cfoutput> Batch Time</h5>
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
                                        <label><input type="radio" name="editBatchType" value="otherLocation">Coaching Center</label>
                                    </div>
                                    <div class="col-md-12">
                                        <label><input type="radio" name="editBatchType" value="homeLocation">Student Home</label>
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
        <!---all models ends here--->

    <cfelse>
        <!---if failed to retrived the details an erro msg will displayed--->
        <div class="alert alert-danger pt-3 m-2 mb-5">
            <p class="d-block text-danger m-2"><cfoutput>#batchInfo.overview.error#</cfoutput></p>
        </div>
    </cfif>
</cf_header>