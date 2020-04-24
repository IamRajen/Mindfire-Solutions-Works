<!---
Project Name: FindOnlineTutor.
File Name: searchResult.cfm.
Created In: 23rd Apr 2020
Created By: Rajendra Mishra.
Functionality: This file show the search result of teachers for batches.
--->
<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm">
<!--- <cfset myFunctionObj = createObject("component","FindOnlineTutor.Components.myFunction")/>
<cfset keywords = arrayToList(myFunctionObj.removeStopWords(url.query)) />
<cfdump  var="#words#"> --->
<div class="container">
    <cfinclude  template="Include/searchForm.cfm">
    <cfif structKeyExists(url, "query")>
        <!---when some data is given for search--->
         <cfset databaseServiceObj = createObject("component","FindOnlineTutor/Components/databaseService")/>
         <cfset batches = databaseServiceObj.searchQuery(url.query)/>
         <cfif  structKeyExists(batches, "batches")>
            <cfif batches.batches.recordCount GT 0>
                <!---if search result got some data then filter option will be displayed--->
                <div class="container">
                    <div class="row my-2">
                        <div class="col-sm-2 text-center my-1">
                            <select id="inputCountry" class="form-control section-div">
                                <option class="section-div" value="">Country</option>
                                <option selected>India</option>
                            </select>
                        </div>
                        <div class="col-sm-2 text-center my-1">
                            <select id="inputState" class="form-control section-div">
                                <option class="section-div" value="">State</option>
                                <option class="section-div">India</option>
                            </select>
                        </div>
                        <div class="col-sm-2 text-center my-1">
                            <select id="inputRating" class="form-control section-div">
                                <option class="section-div" value="">Rating</option>
                                <option value="4">Above 4</option>
                                <option value="3">Above 3</option>
                                <option value="2">Above 2</option>
                                <option value="1">Above 1</option>
                            </select>
                        </div>
                        <div class="col-sm-2 text-center my-1">
                            <select id="inputFee" class="form-control section-div">
                                <option class="section-div" value="">Fee</option>
                                <option class="section-div">India</option>
                            </select>
                        </div>
                        <div class="col-sm-2 text-center my-1">
                            <select id="inputState" class="form-control section-div">
                                <option class="section-div" value="">Duration</option>
                                <option class="section-div">India</option>
                            </select>
                        </div>
                        <div class="col-sm-2 text-center my-1">
                            <select id="inputCountry" class="form-control section-div">
                                <option class="section-div" value="">Start Date</option>
                                <option class="section-div">India</option>
                            </select>
                        </div>
                    </div>
                    <div class="row my-2">
                        <div class="col-sm-2 text-center mx-2">
                            <label class="form-check-label text-primary">Filter by Days:</label>
                        </div>
                        <div class="col-sm-1 text-center mx-2">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Monday</label>
                        </div>
                        <div class="col-sm-1 text-center mx-2">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Tuesday</label>
                        </div>
                        <div class="col-sm-1 text-center mx-2">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Wednesday</label>
                        </div>
                        <div class="col-sm-1 text-center mx-5">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Thrusday</label>
                        </div>
                        <div class="col-sm-1 text-center mx-1">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Friday</label>
                        </div>
                        <div class="col-sm-1 text-center mx-2">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Saturday</label>
                        </div>
                        <div class="col-sm-1 text-center mx-2">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Sunday</label>
                        </div>
                    </div>
                </div>
                <cfoutput query="batches.batches">
                    <a href="batchesDetails.cfm?id=#batchId#" class="row m-3 p-3 shadow bg-light rounded">
                        <div class="col-md-12 border-bottom pb-2">
                            <h3 class=" text-dark d-inline">#batchName#<span class="text-info h6 ml-2">#batchType#</span></h3>
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
            <cfelse>
                <div class="alert alert-secondary p-5">
                    <h2 class="d-block text-dark text-center m-2 p-5">Sorry we didn't got any BATCH of your choice.</h2>
                </div>
            </cfif>
         </cfif>
    <cfelse>
        <div class="alert alert-secondary p-5">
            <p class="d-block text-dark m-2 p-5">You haven't searched for any subjects or courses. You can search this by typing in the search box and hitting the search botton.</p>
        </div>
    </cfif>
</div>
</cf_header>