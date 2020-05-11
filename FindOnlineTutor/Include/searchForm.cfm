<cfset searchQuery = ''/>
<cfif structKeyExists(url, "query")>
    <cfset searchQuery = url.QUERY/>
</cfif>
<form class="form-inline my-2 my-lg-0 p-5" method="get" action="searchResult.cfm">
    <div class="text-center d-block w-100 ">
        <input name="query" class="w-50 form-control py-4 search-bar border-secondary" type="search" placeholder="Search Subject.." 
        aria-label="Search" value="<cfoutput>#searchQuery#</cfoutput>"><input src="Images/searchLogo.png" class="btn border-secondary border-left-0 my-2 search-button" type="image">
    </div> 
    <small class='text-secondary text-center w-100 p-2'><i>Search for batches and hit the search key.</i></small>
</form>