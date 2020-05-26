<cfset searchQuery = ''/>
<cfif structKeyExists(url, "query")>
    <cfset searchQuery = url.QUERY/>
</cfif>

<cfset local.colorArray = ['alert-info','alert-warning', 'alert-danger', 'alert-secondary', 'alert-success', 'alert-dark']/>
		
<form class="form-inline my-1 my-lg-0 px-2 py-3" method="get" action="searchResult.cfm">
    <div class="text-center d-block w-100 ">
        <input name="query" class="w-50 form-control py-4 search-bar border-secondary" type="search" placeholder="Search Subject.." 
        aria-label="Search" value="<cfoutput>#searchQuery#</cfoutput>"><input src="Images/searchLogo.png" class="btn border-secondary border-left-0 my-2 search-button" type="image">
    </div> 
    <div class='px-5 w-100 text-center my-1'>
        <cfset trendingWords = local.batchServiceObj.getTrendingWord()/>
        <small class='text-dark text-center d-inline p-2'><i><b>Trending: </b></i></small>
        <cfif isQuery(trendingWords.words)>
            <cfoutput query="trendingWords.words">
                <cfset local.color = randRange(1, arrayLen(local.colorArray))/>
                <a class="link mx-3 px-3 #local.colorArray[local.color]# section-div text-dark p-1" href="searchResult.cfm?query=#tag#">#tag#</a>
            </cfoutput>
        </cfif>
    </div>
</form>
<hr class="w-25 m-auto bg-secondary mb-3">