<cfset searchQuery = ''/>
<cfif structKeyExists(url, "query")>
    <cfset searchQuery = url.QUERY/>
</cfif>
<form class="form-inline my-2 my-lg-0 p-5" method="get" action="searchResult.cfm">
    <div class="text-center d-block w-100">
        <input name="query" class="w-50 form-control mr-sm-2 py-4 section-div shadow" type="search" placeholder="Search Subject.." aria-label="Search" value="<cfoutput>#searchQuery#</cfoutput>">
        <button class="btn btn-dark my-2 my-sm-0 px-3 py-2 section-div shadow" type="submit">Search</button>
    </div> 
</form>