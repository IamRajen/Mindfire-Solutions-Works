<!---Enrolled Section start from here--->
<div class="col-md-4 p-1 mb-4">
    <div class="p-3 shadow rounded">
        <div  class="overflow-auto" style="height: 409px;">
            <!---displaying the batch students--->
            <h3 class=" text-dark d-inline">Batch Students</h3>
            <hr>
            <!---if no student available a blank msg while be diplayed--->
            <table class="table table-striped">
                <thead>
                    <tr  class="bg-info">
                    <th class="text-light" scope="col">Enrolled Date</th>
                    <th class="text-light" scope="col">Enrolled Time</th>
                    <th class="text-light" scope="col">Enrolled Student</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="batchInfo.enrolledStudent">
                        <tr>
                            <td>#dateFormat(enrolledDateTime)#</td>
                            <td>#timeFormat(enrolledDateTime)#</td>
                            <td><a class="text-dark" href="userDetails.cfm?user=#userId#">#student#</a></td>
                        </tr>
                </cfoutput>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!---Enrolled Section ends here--->