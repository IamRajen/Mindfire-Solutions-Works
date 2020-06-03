<div class="row m-3 p-3 shadow rounded  text-center">
    <div class="col-md-3">
        <h3 class="text-dark">Batch Address</h3>
    </div>
    
    <!---if the batch type is online--->
    <cfif local.batchInfo.overview.batchType EQ 'online'>
        <div class="col-md-6">
            <input type="text" id="addressLink" name="addressLink" placeholder="Batch link address" class="form-control d-block" value="<cfoutput>#local.batchInfo.overview.addressLink#</cfoutput>">
            <span></span>
        </div>
        <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
            <div class="col-md-3">
                <button class="btn button-color  d-inline px-3 py-1" onclick="updateBatchAddress('addressLink')">Update</button>
            </div>
        </cfif>
    </cfif>

    <!---if the batch type is home--->
    <cfif local.batchInfo.overview.batchType EQ 'home'>
        <!---display the user current address here--->
        <p class="p-3 bg-white">
            <cfoutput>#local.batchInfo.address.Address[1]#, #local.batchInfo.address.city[1]#, #local.batchInfo.Address.state[1]#,
                #local.batchInfo.address.country[1]#, #local.batchInfo.address.pincode[1]#
            </cfoutput>
        </p>
    </cfif>

    <!---if the batch type is coaching--->
    <cfif local.batchInfo.overview.batchType EQ 'coaching'>
        <!---populating the options address field of user--->
        <div class="col-md-6">
            <select id="addressId" name="addressId" class="form-control d-block">
                <cfoutput query="local.batchInfo.address">
                    <option value="#userAddressId#" 
                    <cfif local.batchInfo.overview.addressId EQ userAddressId> 
                        selected="selected"
                    </cfif>>#address#, #city#, #state#, #country# - #pincode#
                    </option>
                </cfoutput>
            </select>
        </div>
        <div class="col-md-3">
            <button class="btn button-color shadow d-inline px-3 py-1" onclick="updateBatchAddress('addressId')">Update</button>
        </div>
    </cfif>
</div>