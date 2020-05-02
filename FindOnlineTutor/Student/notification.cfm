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

    <div class="container">
        <!---if warning key is present then --->
        <cfif structKeyExists(notificationInfo, "warning")>

        </cfif>
        <!---if some error ocuured while retrieving the notifiaction--->
        <cfif structKeyExists(notificationInfo, "error")>

        </cfif>
    </div>

    <div class="modal fade" id="showNotification">
        <div class="modal-dialog">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title pl-2">Notification Details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <!-- Modal body -->
                <div class="modal-body">
                    <h4 id="notificationTitle" class="text-primary d-inline"></h4>
                    <small id="notificationDateTime" class="float-right text-secondary d-inline bg-light px-3 border"></small>
                    <p id="notificationDetail" class="alert alert-secondary border p-2 m-2 text-secondary"></p>
                </div>
                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn button-color shadow" data-dismiss="modal">Done</button>
                </div>
            </div>
        </div>
    </div>
</cf_header>