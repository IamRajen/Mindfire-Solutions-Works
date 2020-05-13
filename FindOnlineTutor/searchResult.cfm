<!---
Project Name: FindOnlineTutor.
File Name: searchResult.cfm.
Created In: 23rd Apr 2020
Created By: Rajendra Mishra.
Functionality: This file show the search result of teachers for batches.
--->
<cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
    <cflocation  url="/assignments_mindfire/FindOnlineTutor">
</cfif>
<cfset isStudent = false>
<!---creating objects of batch service component--->
<cfset batchServiceObj  = createObject("component","FindOnlineTutor.Components.batchService")/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm" scriptPath="Script/searchBatch.js">

<cfinclude  template="Include/searchForm.cfm">

<div class="container">

    <!---if user is a student then we will provide the additional information about enrollment--->
    <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student'>
        <cfset isStudent = true/>
        <cfset myRequest = batchServiceObj.getMyRequests()/>
        <!---if successfully batches are retrieved then those will be displayed here--->
        <cfset requestIds = {}>
        <!---looping through the requests and storing it into the structure for further use--->
        <cfloop query="myRequest.Requests">
            <cfset requestIds['#batchId#'] = '#requestStatus#'>
        </cfloop>
        
    </cfif>

    <!---filter options will be displayed--->
    <div id="filterDiv" class="row p-3 mt-4">
        <div class="col-md-3">
            <label class="text-primary" >Filter Options :</label>
        </div>
        <div class="col-md-3">
            <input class="form-check-input" type="radio" name="filterOption" id="nearBy" value="batchesNearMe" <cfif NOT structKeyExists(url, "query")>checked</cfif>>
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
        <p class="hidden"><cfoutput>#isStudent#</cfoutput></p>
    </div>

    <!---if any search is performed then if condition will get executed else it will give the nearBy batches--->
	<cfif structKeyExists(url, "query") AND url.query NEQ ''>
		<cfset batches = batchServiceObj.getSearchBatches(url.query)>
        
    <cfelse>
        <!---display the users near by batches--->
        <cfset batches = batchServiceObj.getNearByBatch(country='' , state='')/>
    </cfif>
    <cfif structIsEmpty(batches) OR (structKeyExists(batches, 'batch') AND batches.batch.recordCount EQ 0)>
        <p class="alert alert-info py-3 text-center rounded">Sorry, We don't have any batches.</p>
    <cfelseif structKeyExists(batches, "batch") >
        <div id="batchesDiv">
            <cfoutput query="batches.batch">
                <cfinclude  template="Include/batchOverview.cfm">
            </cfoutput>
        </div>
    <cfelseif structKeyExists(batches, "error") OR structKeyExists(batches.batch, "error")>
        <!---if some error occurred while retrieving the data error msg will be displayed--->
        <p class="alert alert-danger py-3 text-danger text-center rounded">Some error occured while retrieving your batches. Please, try after sometime.</p>
    </cfif>
    
</div>

</cf_header>