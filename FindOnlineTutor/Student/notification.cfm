<!---
Project Name: FindOnlineTutor.
File Name: notification.cfm.
Created In: 30th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a cfm file containing the all notification .
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/notification.js">

    <!---creating the batchService object--->
    <cfset batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
    <cfset notificationInfo = batchServiceObj.getMyNotification()/>
    <cfdump  var="#notificationInfo#">

    <div class="container">
        <!---if warning key is present then 
        <cfif structKeyExists(notificationInfo, "warning")>

        </cfif>
        <!---if some error ocuured while retrieving the notifiaction--->
        <cfif structKeyExists(notificationInfo, "error")>

        </cfif>
        <!---displaying the notifications--->
        <cfif structKeyExists(notificationInfo, "notifications")>
            <!---<table class="table">
                <thead>
                    <tr  class="bg-info">
                    <th class="text-light" scope="col">No.</th>
                    <th class="text-light" scope="col">Notification Title</th>
                    <th class="text-light" scope="col">Batch</th>
                    <th class="text-light" scope="col">Date</th>
                    <th class="text-light" scope="col">Time</th>
                    <th class="text-light" scope="col"></th>
                    </tr>
                </thead>
                <cfif notificationInfo.notifications.recordCount EQ 0>
                    <div class="alert alert-secondary pt-5 pb-5 rounded-top">
                        <p class="text-secondary text-center">You don't have any Notification.</p>
                    </div>
                </cfif>
                <tbody>
                    <cfset notificationNumber = 1/>
                    <cfoutput query="notificationInfo.notifications">
                        <tr 
                            <cfif notificationStatus EQ 0> 
                                class="font-weight-bold"
                            <cfelse>
                                class="font-weight-light"
                            </cfif>
                        >
                            <th scope="row">#notificationNumber#.</th>
                            <td class="text-capitalize">#notificationTitle#</td>
                            <td>#batchName#</td>
                            <td>#dateFormat(dateTime)#</td>
                            <td>#timeFormat(dateTime)#</td>
                            <td><button class="btn btn-success rounded px-3">View</button></td>
                        </tr>
                        <cfset notificationNumber = notificationNumber+1/>
                    </cfoutput>
                </tbody>
            </table>--->
        </cfif>--->
    </div>
</cf_header>