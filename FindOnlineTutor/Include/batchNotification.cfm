<!---Notication Section start from here--->
<div class="col-md-6 p-1 mb-4">
    <div class="p-3 shadow rounded">
        <!---displaying the batch notification--->
        <h3 class=" text-dark d-inline">Notification</h3>
        <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.userId EQ local.batchInfo.overview.batchOwnerId>
            <button class="btn button-color shadow d-inline float-right px-3 py-1" data-toggle="modal" data-target="#addBatchNotificationModal">Add</button>
        </cfif>
        <hr>
        <!---if no available a blank msg while be diplayed--->
        <cfif local.batchInfo.notification.recordCount EQ 0>
            <div  style="max-width: 500px; height: 409px;">
                <p class="d-block text-dark m-2 alert alert-secondary">No notification is added yet. You can create one by clicking add button at the top-right corner.</p>
            </div>
        <cfelse>
        <!---display the notifications--->
        <div class="overflow-auto" style="max-width: 500px; height: 409px;">
            <cfoutput query="local.batchInfo.NOTIFICATION">
                <cfset notificationTime = #TimeFormat(dateTime,"h:mm:ss tt")#/>
                <cfset notificationDate = #DateFormat(dateTime,"d mmm yyyy")#/>
                <cfset today = #dateFormat(now(),"d mmm yyyy")#/>
                
                <div class="row m-2" onclick="loadNotification(this)">
                    <div class="col-md-12">
                        <h5 class="text-primary d-inline">#notificationTitle#</h5>
                        <p id="notificationId" class="hidden">#batchNotificationId#</p>
                        <small class="text-secondary d-inline float-right">
                            <cfif #dateCompare(today, notificationDate)#>
                                #notificationDate#
                            <cfelse>
                                #notificationTime#
                            </cfif>
                        </small>
                    </div>
                    <div class="col-md-12">
                        <p class="d-block text-secondary">#notificationDetails#</p>
                    </div>
                </div>
                
                
                <hr>
            </cfoutput>
        </div>
        </cfif> 
    </div>
</div>
<!---Notication Section ends here--->