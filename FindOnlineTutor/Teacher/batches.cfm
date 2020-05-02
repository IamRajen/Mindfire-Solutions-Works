<!---
Project Name: FindOnlineTutor.
File Name: batches.cfm.
Created In: 15th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a batch page which contains all the related information for a teacher
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/batchValidation.js">

<h1 class="d-inline text-info">Batches</h1>

<button type="button" class="btn button-color shadow float-right" data-toggle="modal" data-target="#addNewBatch">
    Add new Batch
</button>
<hr>

<!---Display the batches---> 
    <cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>
    <cfset batchInfo = batchServiceObj.getMyBatch()/>

    <div id="batchDiv" class="m-3">
        <cfif structKeyExists(batchInfo, "error")>
            <div class="alert alert-danger pt-3 pb-3 rounded-top">
                <p class="text-danger text-center">#batchInfo.error#</p>
            </div>
        <cfelseif batchInfo.batches.recordCount EQ 0>
            <div class="alert alert-secondary pt-5 pb-5 rounded-top">
                <p class="text-secondary text-center">You haven't created any batch. You can create it by clicking on "Add New Batch" button at top right side.</p>
            </div>
        <cfelse>
            <cfoutput query="batchInfo.batches">
                <a href="batchesDetails.cfm?id=#batchId#" class="row m-3 p-3 shadow bg-white rounded">
                    <div class="col-md-12 border-bottom pb-2">
                        <h3 class=" text-dark d-inline">#batchName#<span class="text-info h6 ml-2">#batchType#</span></h3>
                        <small class="bg-danger float-right d-inline rounded p-1 text-light mx-1">Request</small>
                    </div>
                    
                    <div class="col-md-12">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Description: </span>#batchDetails#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Start Date: </span>#startDate#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">End Date: </span>#endDate#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Batch Capacity: </span>#capacity#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Enrolled: </span>#enrolled#</p>
                    </div> 
                    <div class="col-md-4">
                        <p class="d-block text-dark m-2"><span class="text-info h6 mr-2">Fee: </span>#fee#</p>
                    </div> 
                    
                </a>
            </cfoutput>
        </cfif>
    </div>

<!--- The Modal --->
    <div class="modal fade" id="addNewBatch">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="newBatch">
                    <!-- Modal Header -->
                    <div class="modal-header">
                        <h4 class="modal-title pl-5">Batch Information</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    
                    <!-- Modal body -->
                    <div class="modal-body">
                        <!---Batch name field--->
                        <div class="row m-3">
                            <label class="text-info" class="control-label"  for="batchName">Batch Name:<span class="text-danger">*</span></label>
                            <div class="col-md-12">
                                <input type="text" id="batchName" name="batchName" placeholder="Batch Name" class="form-control d-block" onblur="checkBatchName(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>
                        
                        <!---Batch type field--->
                        <div class="row m-3">
                            <label class="text-info" class="control-label"  for="batchType">Batch Type:<span class="text-danger">*</span></label>
                            <div class="col-md-12">
                                <label><input type="radio" name="batchType" value="coaching" checked>Coaching Center</label>
                            </div>
                            <div class="col-md-12">
                                <label><input type="radio" name="batchType" value="home" >Student Home</label>
                            </div>
                            <div class="col-md-12">
                                <label><input type="radio" name="batchType" value="online" >Online</label>
                            </div>  
                        </div>

                        <!---Batch detail--->
                        <div class="row m-3">
                            <label class="text-info" for="batchDetail">Batch Details:<span class="text-danger">*</span></label>
                            <div class="col-md-12">
                                <textarea class="form-control" rows="5" id="batchDetails" onblur="checkBatchDetails(this)"></textarea>
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>
                    
                        <!---Batch Start date End date--->
                        <div class="row m-3 ">
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="startDate">Start Date:<span class="text-danger">*</span></label>
                                <input type="date" id="batchStartDate" name="startDate" class="form-control d-block" onblur="checkDate(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="endDate">End Date:<span class="text-danger">*</span></label>
                                <input type="date" id="batchEndDate" name="endDate" class="form-control d-block" onblur="checkDate(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>
                        <!---Batch Capacity fee--->
                        <div class="row m-3 ">
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="batchCapacity">Batch capacity:<span class="text-danger">*</span></label>
                                <input type="text" id="batchCapacity" name="batchCapacity" class="form-control d-block" onblur="checkCapacityFee(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="batchFee">Batch fee(In Rupees):<span class="text-danger">*</span></label>
                                <input type="text" id="batchFee" name="batchFee" class="form-control d-block" onblur="checkCapacityFee(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>

                    </div>
                    <!-- Modal footer -->
                    <div id="buttonDiv" class="modal-footer">
                        <input type="submit" class="btn btn-danger" value="Create">
                    </div>
                </form>
                
            </div>
        </div>
    </div>

</cf_header>