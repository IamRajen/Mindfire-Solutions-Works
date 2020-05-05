<cfset userAddress = databaseServiceObj.getMyAddress(url.Id)/>

<div class="p-3 shadow rounded border">
    <cfset currentRow = 1/>
    <cfoutput query="userAddress.Address">
        <small class="text-primary">
            <cfif currentRow == 1>
                Current Address : 
            <cfelse>
                Alternative Address : 
            </cfif>
        </small>
        <p class="ml-2">
            #address#, #city#, #state#, #country# -  #pincode# 
        </p>
        <cfset currentRow = currentRow+1/>
    </cfoutput>
</div>