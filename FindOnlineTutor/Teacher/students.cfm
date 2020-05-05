<!---
Project Name: FindOnlineTutor.
File Name: students.cfm.
Created In: 28th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a page that contains all the students list of the logged in teacher
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">

    <cfset batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset myStudents = batchServiceObj.getMyStudent()/>

    <div class="p-3 my-4 shadow bg-light rounded">
        <!---displaying the batch students--->
        <h3 class=" text-dark d-inline">Batch Students</h3>
        <hr>
        <div  class="overflow-auto" style="height: 409px;">
            <cfif structKeyExists(myStudents, "enrolledStudents")>
                
                <!---if no student available a blank msg while be diplayed--->
                <table class="table table-striped">
                    <thead>
                        <tr  class="bg-info">
                        <th class="text-light" scope="col">Enrolled Date</th>
                        <th class="text-light" scope="col">Enrolled Time</th>
                        <th class="text-light" scope="col">Enrolled Batch</th>
                        <th class="text-light" scope="col">Enrolled Student</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="myStudents.enrolledStudents">
                            <tr>
                                <td>#dateFormat(enrolledDateTime)#</td>
                                <td>#timeFormat(enrolledDateTime)#</td>
                                <td><a class="text-dark" href="batchesDetails.cfm?id=#batchId#">#batchName#</a></td>
                                <td><a class="text-dark" href="../userDetails.cfm?id=#studentId#">#Student#</a></td>
                            </tr>
                    </cfoutput>
                    </tbody>
                </table>
                    
            <cfelseif structKeyExists(batchInfo.request, "error")>
                <!---if some error occurred while retriving the requests of batch an error msg while be diplayed--->
                <div class="alert alert-danger pt-3 m-2 mb-5">
                    <p class="d-block text-danger m-2"><cfoutput>#batchInfo.request.error#</cfoutput></p>
                </div>
            </cfif> 
        </div>
    </div>

</cf_header>