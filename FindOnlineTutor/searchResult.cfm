<!---
Project Name: FindOnlineTutor.
File Name: searchResult.cfm.
Created In: 23rd Apr 2020
Created By: Rajendra Mishra.
Functionality: This file show the search result of teachers for batches.
--->
<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" profilePath="profile.cfm">
<div class="container">
    <cfinclude  template="Include/searchForm.cfm">
    <cfif structKeyExists(url, "query")>
        <!---when some data is given for search--->
         <cfset databaseServiceObj = createObject("component","FindOnlineTutor/Components/databaseService")/>
         <cfset batches = databaseServiceObj.searchQuery(url.Query)/>
         <cfif  structKeyExists(batches, "batches")>
            <cfif batches.batches.recordCount GT 0>
                <!---if search result got some data then filter option will be displayed--->
                <div class="container px-5">
                    <div class="row">
                        <div class="col-sm-2 m-1">
                            <p class="text-primary float-right m-1">Filter by:-</p> 
                        </div>
                        <div class="col-sm-2 text-center m-1 ">
                            <p class="bg-secondary text-center section-div p-1 text-light">By Country</p>
                        </div>
                        <div class="col-sm-2 text-center m-1 ">
                            <p class="bg-secondary text-center section-div p-1 text-light">By state</p>
                        </div>
                        <div class="col-sm-2 text-center m-1 ">
                            <p class="bg-secondary text-center section-div p-1 text-light">By Rating</p>
                        </div>
                        <div class="col-sm-2 text-center m-1 ">
                            <p class="bg-secondary text-center section-div p-1 text-light">By Days</p>
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