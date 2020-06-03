<!---
Project Name: FindOnlineTutor.
File Name: students.cfm.
Created In: 28th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a page that contains all the students list of the logged in teacher
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">

    <cfset local.batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset local.profileServiceObj = createObject("component","FindOnlineTutor.Components.profileService")/>
    <cfset local.myStudents = local.batchServiceObj.getMyStudent()/>
    
    <div class="p-3 my-4 shadow rounded">
        <!---displaying the batch students--->
        <cfif structKeyExists(local.myStudents, "students")>
            <cfif local.myStudents.students.recordCount EQ 0>
                <p class="alert alert-info py-5 m-5 text-center w-100">You don't have any enrolled student yet</p>
            <cfelse>
                <h3 class=" text-dark d-inline">Batch Students</h3>
                <div  class="overflow-auto mt-4" style="height: 409px;">
                <!---if no student available a blank msg while be diplayed--->
                <table class="table border">
                    <thead>
                        <tr  class="bg-light">
                        <th class="text-dark" scope="col">Sl.No.</th>
                        <th class="text-dark" scope="col">Number of Batches</th>
                        <th class="text-dark" scope="col">Enrolled Student</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset local.studentNumber = 1/>
                        <cfoutput query="local.myStudents.students">
                            <cfset local.userName = local.profileServiceObj.getName(studentId)/>
                            <cfif NOT structKeyExists(local.userName, "error")>
                                <tr class="border-bottom">
                                    <td>#local.studentNumber#</td>
                                    <td><p class="text-dark">#numberOfBatches#</p></td>
                                    <td><a class="text-dark" href="../userDetails.cfm?user=#studentId#">#local.userName.name.name#</a></td>
                                </tr>
                                <cfset local.studentNumber = local.studentNumber+1/> 
                            </cfif>
                    </cfoutput>
                    </tbody>
                </table>
            </cfif>
        
        </cfif> 
    </div>

</cf_header>