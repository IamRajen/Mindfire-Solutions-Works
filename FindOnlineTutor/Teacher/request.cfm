<!---
Project Name: FindOnlineTutor.
File Name: request.cfm.
Created In: 28th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a request page which contains all the requests of the particular teacher's batches
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/processRequest.js">

    <!---creating a object of batch service and retriving the requests--->
    <cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset local.myRequests = local.batchServiceObj.getMyRequests()/>
    
    <div class="container">
        <!---if any occurred--->
        <cfif local.myRequests.requests.recordCount EQ 0>
            <div class="alert alert-secondary pt-5 pb-5 rounded-top">
                <p class="text-secondary text-center">You don't have any Request yet.</p>
            </div>
        <cfelse>
            <table class="table table-striped shadow ">
                <thead>
                    <tr  class="bg-info">
                    <th class="text-light" scope="col">ID</th>
                    <th class="text-light" scope="col">Date</th>
                    <th class="text-light" scope="col">Time</th>
                    <th class="text-light" scope="col">Batch</th>
                    <th class="text-light" scope="col">Student</th>
                    <th class="text-light" scope="col">Status</th>
                    <th class="text-light text-center" scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="local.myRequests.requests">
                        <tr>
                            <th>#batchRequestId#.</th>
                            <td>#dateFormat(requestDateTime)#</td>
                            <td>#timeFormat(requestDateTime)#</td>
                            <td><a class="text-dark" href="batchDetails.cfm?batch=#batchId#">#batchName#</a></td>
                            <td><a class="text-dark" href="../userDetails.cfm?user=#userId#">#student#</a></td>
                            <td>
                                <cfif requestStatus EQ 'Pending'>
                                    <p class="alert alert-warning p-1 text-center">
                                <cfelseif requestStatus EQ 'Approved'>
                                    <p class="alert alert-success p-1 text-center">
                                <cfelseif requestStatus EQ 'Rejected'>
                                    <p class="alert alert-danger p-1  text-center">
                                </cfif>
                                #requestStatus#
                                    </p>
                            </td>
                            <cfif requestStatus EQ 'Pending'>
                                <td class="text-center">
                                    <button class="btn btn-info m-1" onclick="updateRequest(#batchRequestId#, this)">Approve</button>
                                    <button class="btn btn-danger m-1" onclick="updateRequest(#batchRequestId#, this)">Reject</button>
                                </td>
                            <cfelse>
                                <td><p class="text-center  p-1">Action been taken</p></td>
                            </cfif>
                            
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        </cfif>
        
    </div>

</cf_header>