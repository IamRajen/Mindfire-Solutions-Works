<!---
Project Name: FindOnlineTutor.
File Name: batchService.cfc.
Created In: 16th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file contains the functions which help to give required services to batches..!!
--->

<cfcomponent output="false">

    <cfset patternvalidationObj = createObject("component","patternValidation")/>
    <cfset databaseServiceObj = createObject("component","databaseService")/>
    <!---function to create a new batch--->
    <cffunction  name="createBatch" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining argumnents--->
        <cfargument  name="batchName" type="string" required="true">
        <cfargument  name="batchType" type="string" required="true">
        <cfargument  name="batchDetails" type="string" required="true">
        <cfargument  name="batchStartDate" type="string" required="true">
        <cfargument  name="batchEndDate" type="string" required="true">
        <cfargument  name="batchCapacity" type="string" required="true">
        <cfargument  name="batchFee" type="string" required="true">

        <!---creating a variable for returning the msg as per required--->
        <cfset var errorMsgs["validatedSuccessfully"] = true/>

        <!---creating a trimmed variable of every arguments--->
        <cfset var name=trim(arguments.batchName)/>
        <cfset var type=trim(arguments.batchType)/>
        <cfset var details=trim(arguments.batchDetails)/>
        <cfset var startDate=trim(arguments.batchStartDate)/>
        <cfset var endDate=trim(arguments.batchEndDate)/>
        <cfset var capacity=trim(arguments.batchCapacity)/>
        <cfset var fee=trim(arguments.batchFee)/>

        <!---validating the argumnents--->
        <cfset var errorMsgs['batchName'] = validateBatchName(name)/>
        <cfset var errorMsgs['batchType'] = validateBatchType(type)/>
        <cfset var errorMsgs['batchDetails'] = validateBatchDetails(details)/>
        <cfset var errorMsgs['batchStartDate'] = validateBatchDate(startDate)/>
        <cfset var errorMsgs['batchEndDate'] = validateBatchDate(endDate)/>
        <cfset var errorMsgs['batchCapacity'] = validateBatchCapacity(capacity)/>
        <cfset var errorMsgs['batchFee'] = validateBatchFee(fee)/>

        <cfif NOT structKeyExists(errorMsgs['batchStartDate'], 'msg') AND NOT structKeyExists(errorMsgs['batchEndDate'], 'msg')>
            <cfif dateTimeFormat(arguments.batchStartDate, "MM/dd/yyyy") GT dateTimeFormat(arguments.batchEndDate, "MM/dd/yyyy")>
                <cfset errorMsgs['batchEndDate']={'msg':'End date should more than start date'}/>
            </cfif>
        </cfif>

        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and structKeyExists(errorMsgs[key],"msg")>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif errorMsgs["validatedSuccessfully"]>

            <cfset var newBatch = databaseServiceObj.insertBatch(
                #session.stloggedinUser.userID#, name, type, details, startDate,endDate,LSParseNumber(capacity),
                LSParseNumber(fee), 0)/>
            <cfif structKeyExists(newBatch, "error")>
                <cfset errorMsgs["error"]=true/>
            <cfelseif structKeyExists(newBatch, "newBatchId")>
                <cfset errorMsgs["createdSuccessfully"]=true/>
            </cfif>

        </cfif>

        <cfreturn errorMsgs/>
        

    </cffunction>

    <!---function to add notification--->
    <cffunction  name="addNotification" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="notificationTitle" type="string" required="true">
        <cfargument  name="notificationDetails" type="string" required="true">
        <!---creating a struture for returning purpose--->
        <cfset var errorMsgs = {}/>
        <cfset errorMsgs["validatedSuccessfully"]= true/>
        <!---validation works start from here--->
        <cfif (NOT patternValidationObj.validText(arguments.notificationTitle)) OR arguments.notificationTitle EQ ''>
            <cfset errorMsgs["notificationTitle"] = "Mandatory field and Should contain only alphanumeric characters and [_@./&:+-] symbols."/>
            <cfset errorMsgs["validatedSuccessfully"]=false/>
        <cfelseif len(arguments.notificationTitle) GT 20>
            <cfset errorMsgs["notificationTitle"] = "Field should not contain more than 20 characters"/>
            <cfset errorMsgs["validatedSuccessfully"]=false/>
        </cfif>
        <cfif (NOT patternValidationObj.validText(arguments.notificationDetails)) OR arguments.notificationDetails EQ ''>
            <cfset errorMsgs["notificationDetails"] = "Mandatory field and Should contain only alphanumeric characters and [_@./&:+-] symbols."/>
            <cfset errorMsgs["validatedSuccessfully"]=false/>
        <cfelseif len(arguments.notificationDetails) GT 200>
            <cfset errorMsgs["notificationDetails"] = "Field should not contain more than 200 characters"/>
            <cfset errorMsgs["validatedSuccessfully"]=false/>
        </cfif>

        <cfif errorMsgs["validatedSuccessfully"]>
            <!---insertion process starts from here--->
            <cfset var batchNotification = databaseServiceObj.insertBatchNotification(
                arguments.batchId, arguments.notificationTitle, arguments.notificationDetails
            )/>
            <cfif structKeyExists(batchNotification, "error")>
                <cfset errorMsgs["insertion"]=false/>
            <cfelse>
                <cfset errorMsgs["insertion"]=true/>
            </cfif>
        </cfif>
        <cfreturn errorMsgs/>
    </cffunction>

    <!---function to create a new batch--->
    <cffunction  name="updateBatch" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining argumnents--->
        <cfargument  name="batchId" type="any" required="true">
        <cfargument  name="editBatchName" type="string" required="true">
        <cfargument  name="editBatchType" type="string" required="true">
        <cfargument  name="editBatchDetails" type="string" required="true">
        <cfargument  name="editBatchStartDate" type="string" required="true">
        <cfargument  name="editBatchEndDate" type="string" required="true">
        <cfargument  name="editBatchCapacity" type="string" required="true">
        <cfargument  name="editBatchFee" type="string" required="true">

        <!---creating a variable for returning the msg as per required--->
        <cfset var errorMsgs["validatedSuccessfully"] = true/>

        <!---creating a trimmed variable of every arguments--->
        <cfset var name=trim(arguments.editBatchName)/>
        <cfset var type=trim(arguments.editBatchType)/>
        <cfset var details=trim(arguments.editBatchDetails)/>
        <cfset var startDate=trim(arguments.editBatchStartDate)/>
        <cfset var endDate=trim(arguments.editBatchEndDate)/>
        <cfset var capacity=trim(arguments.editBatchCapacity)/>
        <cfset var fee=trim(arguments.editBatchFee)/>

        <!---validating the argumnents--->
        <cfset var errorMsgs['editBatchName'] = validateBatchName(name)/>
        <cfset var errorMsgs['editBatchType'] = validateBatchType(type)/>
        <cfset var errorMsgs['editBatchDetails'] = validateBatchDetails(details)/>
        <cfset var errorMsgs['editBatchStartDate'] = validateBatchDate(startDate)/>
        <cfset var errorMsgs['editBatchEndDate'] = validateBatchDate(endDate)/>
        <cfset var errorMsgs['editBatchCapacity'] = validateBatchCapacity(capacity)/>
        <cfset var errorMsgs['editBatchFee'] = validateBatchFee(fee)/>

        <cfif NOT structKeyExists(errorMsgs['editBatchStartDate'], 'msg') AND NOT structKeyExists(errorMsgs['editBatchEndDate'], 'msg')>
            <cfif dateTimeFormat(arguments.editBatchStartDate, "MM/dd/yyyy") GT dateTimeFormat(arguments.editBatchEndDate, "MM/dd/yyyy")>
                <cfset errorMsgs['editBatchEndDate']={'msg':'End date should more than start date'}/>
            </cfif>
        </cfif>

        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and structKeyExists(errorMsgs[key],"msg")>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>


        <cfif errorMsgs["validatedSuccessfully"]>

            <!---if successfully validated updation works starts from here--->
            <cflog  text="#arguments.batchId#">
            <cfset var editBatchOverview = databaseServiceObj.updateBatch(
                #arguments.batchId#, name, type, details, startDate,endDate,LSParseNumber(capacity),
                LSParseNumber(fee))/>
            <cfif structKeyExists(editBatchOverview, "error")>
                <cfset errorMsgs["error"]=true/>
            <cfelse>
                <cfset errorMsgs["updatedSuccessfully"]=true/>
            </cfif>

        </cfif>

        <cfreturn errorMsgs/>
        

    </cffunction>

    <!---function to create a new batch--->
    <cffunction  name="updateBatchTiming" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="Monday" type="struct" required="true">
        <cfargument  name="Tuesday" type="struct" required="true">
        <cfargument  name="Wednesday" type="struct" required="true">
        <cfargument  name="Thrusday" type="struct" required="true">
        <cfargument  name="Friday" type="struct" required="true">
        <cfargument  name="Saturday" type="struct" required="true">
        <cfargument  name="Sunday" type="struct" required="true">  
        <!---creating a week structure which basically converts the batch day to number--->
        <cfset var weekDays = {"Monday":"1","Tuesday":"2", "Wednesday":"3", "Thrusday":"4", "Friday":"5", "Saturday":"6", "Sunday":"7"}/>
        <!---creating a variable for storing the batch number of the update request--->
        <cfset var batchNumber = arguments.batchId/>
        <cfset var batchDeleted = structDelete(arguments, "batchId")/>     
        <!---declaring a structure for returning the result--->
        <cfset var errorMsgs = {}/>
        <cfset errorMsgs["validatedSuccessfully"] = true/>
        <cfset var day = 0/>
        <!---looping the arguments for checking the errors for validation--->
        <cfloop collection="#arguments#" item="item">
            <cfif arguments[item].startTime NEQ '' and arguments[item].endTime NEQ ''>
                <cfif NOT patternValidationObj.validTime(arguments[item].startTime)>
                    <cfset errorMsgs["#day#"]["startTime"] = "Invalid time"/>
                    <cfset errorMsgs["validatedSuccessfully"] = false/>
                </cfif>
                <cfif NOT patternValidationObj.validTime(arguments[item].endTime)>
                    <cfset errorMsgs["#day#"]["endTime"] = "Invalid time"/>
                    <cfset errorMsgs["validatedSuccessfully"] = false/>
                </cfif>
                <cfif NOT structKeyExists(errorMsgs, "#item#")>
                    <cfset var startTime = TimeFormat(arguments[item].startTime,"HH:mm")/>
                    <cfset var endTime = TimeFormat(arguments[item].endTime,"HH:mm")/>
                    <cfif startTime GT endTime>
                        <cfset errorMsgs["#day#"]["endTime"]="end time should be more than start time"/>
                        <cfset errorMsgs["validatedSuccessfully"] = false/>
                    </cfif>
                </cfif>
            <cfelseif arguments[item].startTime NEQ '' and arguments[item].endTime EQ ''>
                <cfset errorMsgs["#day#"]["endTime"] = "Must also have the end time or you can keep both blank."/>
                <cfset errorMsgs["validatedSuccessfully"] = false/>
            <cfelseif arguments[item].startTime EQ '' and arguments[item].endTime NEQ ''>
                <cfset errorMsgs["#day#"]["startTime"] = "Must also have the start time or you can keep both blank."/>
                <cfset errorMsgs["validatedSuccessfully"] = false/>
            </cfif>
            <cfset day = day+1 />
            
        </cfloop>
        <!---calling update function for updating the timing--->
        <cfif errorMsgs["validatedSuccessfully"]>
            <!---using transaction for updating with respect to their id's--->
            <cfset var isCommit=false/>
            <cftransaction>
                <cftry>
                    <cfloop collection="#arguments#" item="item">
                        <cfif arguments[item].startTime NEQ '' and arguments[item].endTime NEQ ''>
                            <cfif arguments[item].batchTimingId NEQ ''>
                                <!---update the timing--->
                                <cfset var updateBatchTiming = databaseServiceObj.updateBatchTime
                                    (arguments[item].batchTimingId, arguments[item].startTime, arguments[item].endTime)/>
                                <cfif structKeyExists(updateBatchTiming, "error")>
                                    <cfthrow detail = "updateError :#updateBatchTiming.error#"/>
                                </cfif>
                            <cfelse>
                                <!---insert the timing--->
                                <cfset var insertBatchTiming = databaseServiceObj.insertBatchTime
                                    (batchNumber, arguments[item].startTime, arguments[item].endTime, weekDays[item])/>
                                    <cflog  text="#batchNumber#">
                                <cfif structKeyExists(insertBatchTiming, "error")>
                                    <cfthrow detail = "insertError: #insertBatchTiming.error#"/>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfloop>   
    
                    <!---if every query get successfully executed then commit actoin get called--->
                    <cftransaction action="commit" />
                    <cfset isCommit=true />
                    
                <cfcatch type="any">
                    <!---if some error occured while transaction then the whole transaction will be rollback--->
                    <cftransaction action="rollback" />
                </cfcatch>
                </cftry>
            </cftransaction>
            <cfset errorMsgs.commit = isCommit/>
        </cfif>

        <cfreturn errorMsgs/>
    </cffunction>

    <!---function to validate the batch name--->
    <cffunction  name="validateBatchName" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchName" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchName)>
            <cfset errorMsg.msg="Mandatory Field.Please provide your batch name!!"/>
        <cfelseif NOT patternValidationObj.validHeading(arguments.batchName)>
            <cfset errorMsg.msg="Only alphabets and spaces allowed"/>
        <cfelseif len(arguments.batchName) GT 20>
            <cfset errorMsg.msg="batch name should be within 20 characters."/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate the batch details--->
    <cffunction  name="validateBatchDetails" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchDetails" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchDetails)>
            <cfset errorMsg.msg="Mandatory Field.Please provide your batch details!!"/>
        <cfelseif NOT patternValidationObj.validLargeText(arguments.batchDetails)>
            <cfset errorMsg.msg="Only alphabets and spaces allowed"/>
        <cfelseif len(arguments.batchDetails) GT 300>
            <cfset errorMsg.msg="batch details should be within 300 characters."/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate the batch type--->
    <cffunction  name="validateBatchType" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchType" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchType)>
            <cfset errorMsg.msg="Mandatory Field.Please provide your batch type!!"/>
        <cfelseif (arguments.batchType NEQ 'online') AND (arguments.batchType NEQ 'homeLocation') AND (arguments.batchType NEQ 'otherLocation')>
            <cfset errorMsg.msg="Invalid batch type please select from the required fields."/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate the batch dates--->
    <cffunction  name="validateBatchDate" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchDate" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchDate)>
            <cfset errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT isDate(arguments.batchDate)>
            <cfset errorMsg.msg="Not a Valid date!!"/>
        <cfelse>
            <cfset var providedDate = dateTimeFormat(arguments.batchDate, "MM/dd/yyyy")>
            <cfif providedDate LT #now()#>
                <cfset errorMsg.msg="Date should be more than today date"/>
            </cfif>
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate batch capacity--->
    <cffunction  name="validateBatchCapacity" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchCapacity" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchCapacity)>
            <cfset errorMsg.msg="Mandatory Field.Please provide your batch capacity!!"/>
        <cfelseif NOT patternValidationObj.validNumber(arguments.batchCapacity)>
            <cfset errorMsg.msg="Only numbers allowed!!"/>
        <cfelseif LSParseNumber(arguments.batchCapacity) GT 30000>
            <cfset errorMsg.msg="Batch Capacity must be within 30000"/>
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate batch fee--->
    <cffunction  name="validateBatchFee" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchFee" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset var errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchFee)>
            <cfset errorMsg.msg="Mandatory Field.Please provide your batch Fee!!"/>
        <cfelseif NOT patternValidationObj.validNumber(arguments.batchFee)>
            <cfset errorMsg.msg="Only numbers allowed!!"/>
        <cfelseif LSParseNumber(arguments.batchFee) GT 1000000>
            <cfset errorMsg.msg="Batch Fee should not exceed 10Lacs"/>
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>

    <!---function to retrieve the all batches of specific teacher--->
    <cffunction  name="getMyBatch" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="userId" type="any" required="true"/>
        <!---creating a structure for returning data--->
        <cfset var batches={}/>
        <!---calling required function as user type--->
        <cfif session.stLoggedInUser.role EQ 'Teacher'>
            <cfset batches=databaseServiceObj.collectTeacherBatch(session.stLoggedInUser.userID)/>
<!---         <cfelseif session.stLoggedInUser.role EQ 'Student'> --->
            
        </cfif>
        <cfreturn batches/>
    </cffunction>

    <!---function to get the batch information like overview timing and feedbacks by it's Id--->
    <cffunction  name="getBatchDetailsByID" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for storing the returned value from database function call--->
        <cfset var batchDetails = {}/>
        <cfset batchDetails.overview = getBatchOverviewById(arguments.batchId)/>
        <cfset var batchDetails.timing = getBatchTimingById(arguments.batchId)/>
        <cfset var batchDetails.notification = getBatchNotifications(arguments.batchId)/>
        
        <cfreturn batchDetails/>
        
    </cffunction>

    <!---function to get the batch overview --->
    <cffunction  name="getBatchOverviewById" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a structure for returning the value of batch overview--->
        <cfset var batchOverview = databaseServiceObj.getBatchByID(arguments.batchId)/>
        <cfreturn batchOverview/>
    </cffunction>

    <!---function to get the batch timing --->
    <cffunction  name="getBatchTimingById" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a structure for returning the value of batch overview--->
        <cfset var batchTiming = databaseServiceObj.getBatchTime(arguments.batchId)/>
        <!---creating the timing array of batch --->
        <cfset var days = ["Monday","Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday", "Sunday"]/>
        <cfset var timeArray = [{},{},{},{},{},{},{}]/>
        <!---returning structure of batch timing --->
        <cfset var timing = {}/>
        <!---looping over batch timing to create a structure of timing--->
        <cfif structKeyExists(batchTiming, "time")>
            <cfset var rowNum = 1/>
            <cfloop query="batchTiming.time">
                <cfset timeArray[#batchTiming.time.day#]['#days[batchTiming.time.day]#']=QueryGetRow(batchTiming.time, rowNum)/>
                <cfset rowNum = rowNum+1/>
            </cfloop>
            <cfloop from="1" to="#arrayLen( timeArray )#" index="i">
                <cfif structIsEmpty(timeArray[i])>
                    <cfset timeArray[i]['#days[i]#'] = {}/>
                </cfif>
            </cfloop>
            <cfset timing.time = timeArray/>
        <cfelse>
            <cfset timing = batchTiming/>
        </cfif>
        <cfreturn timing/>
    </cffunction>

    <!---function to get the batch timing --->
    <cffunction  name="getNotificationById" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---declaring a structure for returning the value of batch notification--->
        <cfset var notificationInfo = databaseServiceObj.getNotificationByID(arguments.batchNotificationId)/>
        <cfreturn notificationInfo/>
    </cffunction>

    <!---function to get the batch feedback --->
    <cffunction  name="getBatchNotifications" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a structure for returning the value of batch overview--->
        <cfset var batchFeedback = databaseServiceObj.getBatchNotifications(arguments.batchId)/>
        <cfreturn batchFeedback/>
    </cffunction>

    <!---function to delete notification from notification table using it's iD--->
    <cffunction  name="deleteNotification" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---calling the database function for deleting the notification--->
        <cfset var notificationInfo = databaseServiceObj.deleteNotification(arguments.batchNotificationId)/>
        <cfreturn notificationInfo/>
    </cffunction> 

</cfcomponent>