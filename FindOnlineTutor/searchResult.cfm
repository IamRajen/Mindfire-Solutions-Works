<!---
Project Name: FindOnlineTutor.
File Name: searchResult.cfm.
Created In: 23rd Apr 2020
Created By: Rajendra Mishra.
Functionality: This file show the search result of teachers for batches.
--->
<!---creating objects of batch service component--->
<cfset batchServiceObj  = createObject("component","FindOnlineTutor.Components.batchService")/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm" scriptPath="Script/searchBatch.js">

<div class="container">
    <cfif structKeyExists(session, "stLoggedInUser")>
        <!---display the users near by batches--->
        <cfset myNearBatches = batchServiceObj.getNearByBatch(country='' , state='')/>
        <cfif structKeyExists(myNearBatches, "batch")>
            <!---if successfully batches are retrieved then those will be displayed here--->
            <!---filter options will be displayed--->
            <div class="row p-3 mt-4">
                <div class="col-md-3">
                    <label class="text-primary" >Filter Options :</label>
                </div>
                <div class="col-md-3">
                    <input class="form-check-input" type="radio" name="filterOption" id="nearBy" value="batchesNearMe" checked>
                    <label class="form-check-label" for="nearBy">
                        Batches Near You
                    </label>
                </div>
                <div class="col-md-3">
                    <input class="form-check-input" type="radio" name="filterOption" id="country" value="batchesInCountry">
                    <label class="form-check-label" for="country">
                        Filter by Country
                    </label>
                    <select id="batchCountry" name="currentCountry" class="form-control w-75 hidden">
                        <option value="">-select country-</option>
                    </select>
                </div>
                <div id="batchStateDiv" class="col-md-3 hidden">
                    <input class="form-check-input" type="radio" name="filterOption" id="state" value="batchesInState">
                    <label class="form-check-label" for="state">
                        Filter By State
                    </label>
                    <select id="batchState" name="currentState" class="form-control w-75 hidden">
                        <option value="">-select state-</option>
                    </select>
                </div>
            </div>
            <div id="batchesDiv">
                <cfoutput query="myNearBatches.batch">
                    <a href="batchesDetails.cfm?id=#batchId#" class="row m-3 p-3 shadow bg-light rounded">
                        <div class="col-md-12 border-bottom pb-2">
                            <h3 id="batchName" class=" text-dark d-inline">#batchName#</h3>
                            <span id="batchType" class="text-info h6 ml-2">#batchType#</span>
                            <button class="btn btn-success float-right d-inline rounded text-light shadow" onclick="enrollStudent()">Enroll</button> 
                        </div>
                        <div class="col-md-12 py-2">
                            <span class="text-info h6 mr-2">Description: </span>
                            <p id="batchDetails" class="d-inline text-dark m-2">#batchDetails#</p>
                        </div> 
                        <div class="col-md-4 py-2">
                            <span class="text-info h6 mr-2">Start Date: </span>
                            <p id="batchStartDate" class="d-inline text-dark m-2">#startDate#</p>
                        </div> 
                        <div class="col-md-4 py-2">
                            <span class="text-info h6 mr-2">End Date: </span>
                            <p id="batchEndDate" class="d-inline text-dark m-2">#endDate#</p>
                        </div> 
                        <div class="col-md-4 py-2">
                            <span class="text-info h6 mr-2">Batch Capacity: </span>
                            <p id="batchCapacity" class="d-inline text-dark m-2">#capacity#</p>
                        </div> 
                        <div class="col-md-4 py-2">
                            <span class="text-info h6 mr-2">Enrolled: </span>
                            <p id="batchEnrolled" class="d-inline text-dark m-2">#enrolled#</p>
                        </div> 
                        <div class="col-md-4 py-2">
                            <span class="text-info h6 mr-2">Fee: </span>
                            <p id="batchFee" class="d-inline text-dark m-2">#fee#</p>
                        </div> 
                        <div class="col-md-12 py-2">
                            <span class="text-info h6 mr-2">Address: </span>
                            <p id="batchAddress" class="d-inline text-dark m-2">#address#, #city#, #state#, #country#-#pincode#</p>
                        </div> 
                    </a>
                </cfoutput>
            </div>
        <cfelseif structKeyExists(myNearBatches, "error") OR structKeyExists(myNearBatches.batches, "error")>
            <!---if some error occurred while retrieving the data error msg will be displayed--->
            <div class="alert alert-danger pt-3 pb-3 rounded-top">
                <p class="text-danger text-center">Some error occured while retrieving your batches. Please, try after sometime.</p>
            </div>
        </cfif>
    <cfelse>
        <!---display 20 batches having start date greater than current date and time --->

    </cfif>
</div>

</cf_header>