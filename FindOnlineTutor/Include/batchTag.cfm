<div class="p-1 m-1 alert alert-info rounded d-inline-block tag">
    <small id="<cfoutput>#batchTagId#</cfoutput>" class="text-info mx-1">
        <cfoutput>#tagName#</cfoutput>
    </small>
    <cfif structKeyExists(url, "batch")>
        <button type="button" class="close mx-1" onclick="deleteTag(this)">&times;</button>
    </cfif>
</div>