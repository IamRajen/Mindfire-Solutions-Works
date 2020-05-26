<!---
Project Name: FindOnlineTutor.
File Name: batches.cfm.
Created In: 15th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a batch page which contains all the related information for a teacher
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/batchValidation.js">

<cfset batchServiceObj = createObject("component","FindOnlineTutor/Components/batchService")/>

<!---Display the batches---> 
    <cfset batchInfo = batchServiceObj.getMyBatch()/>
    
    <div id="batchDiv" class="m-3">
        <cfif batchInfo.batch.recordCount EQ 0>
            <div class="alert alert-secondary pt-5 pb-5 rounded-top">
                <p class="text-secondary text-center">You haven't created any batch. You can create it by clicking on "Add New Batch" button at top right side.</p>
            </div>
        <cfelse>
            <h1 class="d-inline text-info">Batches</h1>
            <button type="button" class="btn button-color shadow float-right" data-toggle="modal" data-target="#addNewBatch">
                Add new Batch
            </button>
            <hr>
            <cfoutput query="batchInfo.batch">
                <cfinclude  template="../Include/batchOverview.cfm">
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
                                <input type="text" id="inputBatchName" name="batchName" placeholder="Batch Name" class="form-control d-block" onblur="checkBatchName(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>
                        
                        <!---Batch type field--->
                        <div class="row m-3">
                            <label class="text-info" class="control-label"  for="inputBatchType">Batch Type:<span class="text-danger">*</span></label>
                            <div class="col-md-12">
                                <label><input type="radio" name="inputBatchType" value="coaching" checked> Coaching Center</label>
                            </div>
                            <div class="col-md-12">
                                <label><input type="radio" name="inputBatchType" value="home" > Student Home</label>
                            </div>
                            <div class="col-md-12">
                                <label><input type="radio" name="inputBatchType" value="online" > Online</label>
                            </div>  
                        </div>

                        <!---Batch detail--->
                        <div class="row m-3">
                            <label class="text-info" for="inputBatchDetail">Batch Details:<span class="text-danger">*</span></label>
                            <div class="col-md-12">
                                <textarea class="form-control" rows="5" id="inputBatchDetails" onblur="checkBatchDetails(this)"></textarea>
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>

                        <!---batch tag names section--->
                        <div class="row m-3">
                            <small class='alert alert-info py-2 text-center text-info'>Tag names helps in improves the higher chances to be searched</small> 
                            <label class="text-info w-100" for="inputBatchDetail">Batch Tags:<span class="text-danger">*</span></label>
                            <div class="col-md-8">
                                <input type="text" id="inputBatchTag" name="inputBatchTag" placeholder="Tags" class="form-control d-block">
                                <span class="text-danger small float-left"></span>
                            </div>
                            <div class="col-md-2">
                                <input type="button" class="btn btn-info px-4" value="Add" onClick="addTag()">
                            </div>
                        </div>
                        <div id="tagDiv" class="row m-3">
                        </div>
                    
                        <!---Batch Start date End date--->
                        <div class="row m-3 ">
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="inputBtartDate">Start Date:<span class="text-danger">*</span></label>
                                <input type="date" id="inputBatchStartDate" name="inputBtartDate" class="form-control d-block" onblur="checkDate(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="inputBndDate">End Date:<span class="text-danger">*</span></label>
                                <input type="date" id="inputBatchEndDate" name="inputBndDate" class="form-control d-block" onblur="checkDate(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                        </div>
                        <!---Batch Capacity fee--->
                        <div class="row m-3 ">
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="inputBatchCapacity">Batch capacity:<span class="text-danger">*</span></label>
                                <input type="text" id="inputBatchCapacity" name="inputBatchCapacity" class="form-control d-block" onblur="checkCapacityFee(this)">
                                <span class="text-danger small float-left"></span>
                            </div>
                            <div class="col-md-6">
                                <label class="text-info" class="control-label"  for="inputBatchFee">Batch fee(In Rupees):<span class="text-danger">*</span></label>
                                <input type="text" id="inputBatchFee" name="inputBatchFee" class="form-control d-block" onblur="checkCapacityFee(this)">
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