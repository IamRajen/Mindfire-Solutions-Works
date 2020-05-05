<!---card for teacher overview--->
<div class="col-sm-12 mt-3">
    <div class="border rounded shadow p-5 mx-5 my-3">
        <div class="pb-3">
            <h4 class="d-inline text-secondary">
                <cfif isTeacher>
                    Teacher
                <cfelse>
                    Student
                </cfif>
            </h4>
            <cfif NOT structKeyExists(url, "user")>
                <a href="teacherDetails.cfm?user=<cfoutput>#userId#</cfoutput>" class="btn button-color px-3 float-right shadow rounded">Details</a>
            </cfif>
        </div>
        <hr>
        <h3 class="p-0 m-0"><cfoutput>#User#</cfoutput></h3>
        <cfset facilities = ''/>
        <cfif HomeLocation>
            <cfset facilities = "{ Home }"/>
        </cfif>
        <cfif otherLocation>
            <cfset facilities = facilities&" { Coaching Center } "/>
        </cfif>
        <cfif online>
            <cfset facilities = facilities&" { Online }"/>
        </cfif>
        <small class="d-block text-info mb-2 ml-5"><cfoutput>#facilities#</cfoutput></small>
        <cfset userAddress = databaseServiceObj.getMyAddress(userId)/>
        <div class="mb-2 mt-3">
            <small class="text-info my-2">Address :</small>
            <cfif structKeyExists(userAddress, "error")>
                <p class="d-inline ml-2 alert alert-danger"><cfoutput>#userAddress.error#</cfoutput></p>
            <cfelse>
                <p class="d-inline ml-2">
                    <cfoutput>
                        #userAddress.ADDRESS.address[1]#, #userAddress.ADDRESS.city[1]#, #userAddress.ADDRESS.state[1]#, #userAddress.ADDRESS.country[1]# -  #userAddress.ADDRESS.pincode[1]# 
                    </cfoutput>
                </p>
            </cfif>
            
        </div class="mb-2">
        <div class="mb-2">
            <small class="text-info my-2">Email Id:</small>
            <p class="d-inline ml-2"><cfoutput>#emailId#</cfoutput></p> 
        </div>
        <cfset age = year(now()) - year(dob)/>
        <div class="mb-2">
            <small class="text-info my-2">Age:</small>
            <p class="d-inline ml-2"><cfoutput>#age#</cfoutput></p>
        </div>
        <cfif isTeacher>
            <div class="mb-2">
                <small class="text-info my-2">Experience:</small>
                <p class="d-inline ml-2"><cfoutput>#yearOfExperience#</cfoutput> Yrs.</p>
            </div>
        </cfif>
        
        <small class="text-info my-2 d-block">Bio:</small>
        <p class="ml-2"><cfoutput>#bio#</cfoutput></p>

    </div>
</div>