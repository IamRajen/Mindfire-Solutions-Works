<!---Batch timing Section start from here--->
<div class="col-md-6 p-1 mb-4">
    <div class="p-3 shadow rounded">
        <cfif structKeyExists(batchInfo.timing, "time")>
            <!---displaying the batch timing--->
            <h3 class=" text-dark d-inline">Timing</h3>
            <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.userId EQ batchInfo.overview.batchOwnerId>
                <button class="btn button-color shadow d-inline float-right px-3 py-1" data-toggle="modal" data-target="#editBatchTimeModal" onclick="loadBatchTiming()">Edit</button>
            </cfif>
            <hr>
            <!---if no timing available a blank msg while be diplayed--->
            <!---display the timing with specific day--->
            <table class="table table-striped">
                <thead>
                    <tr  class="bg-info">
                    <th class="text-light" scope="col">Day</th>
                    <th class="text-light" scope="col">Start Time</th>
                    <th class="text-light" scope="col">End Time</th>
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
                
        <cfelseif structKeyExists(batchInfo.timing, "error")>
            <!---if some error occurred while retriving the timing of batch an error msg while be diplayed--->
            <div class="alert alert-danger pt-3 m-2 mb-5">
                <p class="d-block text-danger m-2"><cfoutput>#batchInfo.timing.error#</cfoutput></p>
            </div>
        </cfif> 
    </div>
</div>
<!---Batch timing Section ends here--->