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
            <cfset var myAddress = databaseServiceObj.getMyAddress(userId = session.stLoggedInUser.UserId)/>
            <cfset var newBatch = databaseServiceObj.insertBatch(
                #session.stloggedinUser.userID#, name, type, details, startDate,endDate,LSParseNumber(capacity),
                LSParseNumber(fee), 0,myAddress.address.userAddressId[1],"")/>
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
            <cftransaction>
                <cftry>
                    <!---insertion process starts from here--->
                    <cfset var batchNotification = databaseServiceObj.insertBatchNotification(
                        arguments.batchId, arguments.notificationTitle, arguments.notificationDetails
                    )/>
                    <!---getting the key of the inserted notification--->
                    <cfset var batchNotificationId = batchNotification.notification.GENERATEDKEY/>
                    <!---getting all enrolled students of this batch--->
                    <cfset var enrolledStudents = databaseServiceObj.getEnrolledStudent(arguments.batchId)/>
                    <cfif structKeyExists(enrolledStudents, "error")>
                        <cfthrow detail = "#enrolledStudents.error#"/>
                    <cfelseif structKeyExists(enrolledStudents, "enrolledStudents")>
                        <cflog  text="hello">
                        <!---looping through the students--->
                        <cfloop query="enrolledStudents.enrolledStudents">
                            
                            <cfset var insertedNotificationStatus = databaseServiceObj.insertNotificationStatus
                                                        (batchNotificationId, batchEnrolledStudentId, 0)/>
                            <cfif structKeyExists(insertedNotificationStatus, "error")>
                                <cfthrow detail = "#insertedNotificationStatus.error#">
                            </cfif>
                        </cfloop>
                    </cfif>
                    
                    <!---if every query get successfully executed then commit actoin get called--->
                    <cftransaction action="commit" />
                <cfcatch type="any">
                    <cflog  text="batchService: addNotification()-> #cfcatch# #cfcatch.detail#">
                    <cfset batchNotification.error = "some error occurred.Please try after sometimes"/>
                </cfcatch>
                </cftry>

                <cfif structKeyExists(batchNotification, "error")>
                    <cfset errorMsgs["insertion"]=false/>
                <cfelse>
                    <cfset errorMsgs["insertion"]=true/>
                </cfif>
            </cftransaction>
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

    <!---function to update the batch address id--->
    <cffunction  name="updateBatchAddressId" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressId" type="numeric" required="true">
        <!---calling funtion and initializing it into the returning variable--->
        <cfset var updateInfo = databaseServiceObj.updateBatchAddressId(arguments.batchId, arguments.addressId)/>
        <cfreturn updateInfo/>
    </cffunction>

    <!---function to update the batch address link--->
    <cffunction  name="updateBatchAddressLink" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressLink" type="string" required="true">
        <!---calling funtion and initializing it into the returning variable--->
        <cfset var updateInfo = databaseServiceObj.updateBatchAddressLink(arguments.batchId, arguments.addressLink)/>
        <cfreturn updateInfo/>
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
        <cfelseif (arguments.batchType NEQ 'online') AND (arguments.batchType NEQ 'home') AND (arguments.batchType NEQ 'coaching')>
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
        <!---creating a structure for returning data--->
        <cfset var batches={}/>
        <!---calling required function as user type--->
        <cfif session.stLoggedInUser.role EQ 'Teacher'>
            <cfset batches=databaseServiceObj.collectTeacherBatch(session.stLoggedInUser.userID)/>
        <cfelseif session.stLoggedInUser.role EQ 'Student'> 
            <cfset batches=databaseServiceObj.collectStudentBatch(session.stLoggedInUser.userId)/>
        </cfif>
        <cfreturn batches/>
    </cffunction>

    <!---function to get the batch information like overview timing and feedbacks by it's Id--->
    <cffunction  name="getBatchDetailsByID" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for storing the returned value from database function call--->
        <cfset var batchDetails = {}/>

        <cftry> 
            <!---checking the batch is of the requested user--->
            <cfset batchDetails.overview = getBatchOverviewById(arguments.batchId)/>
            <cfif structKeyExists(batchDetails.overview, "error")>
                <cfthrow detail = "#batchDetails.overview.error#">
            </cfif>
            <cfset batchDetails.timing = getBatchTimingById(arguments.batchId)/>
            <cfif structKeyExists(batchDetails.timing, "error")>
                <cfthrow detail = "#batchDetails.timing.error#">
            </cfif>
            <!---getting the batch address--->
            <cfif structKeyExists(session, 'stLoggedInUser') AND session.stLoggedInUser.role EQ 'Teacher'>
                <cfset batchDetails.address = databaseServiceObj.getMyAddress(userId = session.stLoggedInUser.UserId)/>
            <cfelse>
                <cfif batchDetails.overview.batch.batchType EQ 'online'>
                    <cfset batchDetails.address = batchDetails.overview.batch.addressLink/>
                <cfelse>
                    <cfset batchDetails.address = databaseServiceObj.getMyAddress(addressId = batchDetails.overview.batch.addressId)/>
                </cfif>
            </cfif>

            <!---getting the notifications of batch--->
            <cfif structKeyExists(session, "stLoggedInUser")>
                <!---if student is enrolled then only he will get the notification--->
                <cfif session.stLoggedInUser.role EQ 'Student'>
                    <cfset var isEnrolled = databaseServiceObj.isStudentEnrolled(arguments.batchId, session.stLoggedInUser.userId)/>
                </cfif>
                <cfif session.stLoggedInUser.role EQ 'Teacher' OR isEnrolled.enrolled>
                    <cfset batchDetails.notification = getBatchNotifications(arguments.batchId)/>
                </cfif>
            </cfif>
            <cfif structKeyExists(batchDetails, "notification") AND structKeyExists(batchDetails.notification, "error")>
                <cfthrow detail = "#batchDetails.notification.error#">
            </cfif>

            <cfif structKeyExists(session, 'stLoggedInUser') AND session.stLoggedInUser.role EQ 'Teacher'>
                <cfset batchDetails.request = getBatchRequests(arguments.batchId)/>
                <cfset batchDetails.enrolledStudent =databaseServiceObj.getEnrolledStudent(batchId=arguments.batchId)/>
            </cfif>
            <cfif structKeyExists(batchDetails, "request") AND structKeyExists(batchDetails.request, "error")>
                <cfthrow detail = "#batchDetails.request.error#">
            </cfif>
            <cfset batchDetails.feedback = databaseServiceObj.retrieveBatchFeedback(arguments.batchId)/> 
        <cfcatch type="any">
            <cflog  text="#cfcatch# #cfcatch.detail#">
            <cfset batchDetails.error = "Some error occurred.Please try after sometime"/>
        </cfcatch>
        </cftry>
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

    <!---function to get the batch notification --->
    <cffunction  name="getBatchNotifications" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">

        <!---declaring a structure for returning the value of batch overview--->
        <cfset var batchNotification= databaseServiceObj.getBatchNotifications(arguments.batchId)/>
        <cfreturn batchNotification/>
    </cffunction>

    <!---function to all the notification of the user--->
    <cffunction  name="getMyNotification" output="false" access="remote" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="notificationStatusId" type="numeric" required="false">
        <cfargument  name="notificationId" type="numeric" required="false">
        
        <cfif structKeyExists(arguments, "notificationStatusId") AND structKeyExists(arguments, "notificationId")>
            <cfset notificationInfo = databaseServiceObj.markNotificationAsRead(arguments.notificationStatusId, arguments.notificationId)/>
        <cfelseif NOT structKeyExists(session, "stLoggedInUser")>
            <cfset notificationInfo.warning = "Sorry you are not logged in"/>
        <cfelseif session.stLoggedInUser.role EQ 'Student'>
            <cfset notificationInfo = databaseServiceObj.getMyNotification(session.stLoggedInUser.userId)/>
        </cfif>
        <cfreturn notificationInfo/>
    </cffunction>


    <!---function to delete notification from notification table using it's iD--->
    <cffunction  name="deleteNotification" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---calling the database function for deleting the notification--->
        <cfset var notificationInfo = databaseServiceObj.deleteNotification(arguments.batchNotificationId)/>
        <cfreturn notificationInfo/>
    </cffunction> 

    <!---function to get the nearby batches of user--->
    <cffunction  name="getNearByBatch" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="country" type="string" required="false">
        <cfargument  name="state" type="string" required="false">

        <cfif arguments.country NEQ '' AND arguments.state EQ ''>
            <!---calling function for retrieving the batches by country--->
            <cfset var batches = databaseServiceObj.getNearByBatch(country=arguments.country)/>
        <cfelseif arguments.state NEQ ''>
            <!---calling function for retrieving the batches by state--->
            <cfset var batches = databaseServiceObj.getNearByBatch(country=arguments.country, state=arguments.state)/>
        <cfelseif NOT structKeyExists(session, "stLoggedInUser")>
            <cfset var batches = databaseServiceObj.getNearByBatch(pincode='')/>
        <cfelse>
            <!---calling function for retrieving the near by batches--->
            <cfset var userAddress = databaseServiceObj.getMyAddress(userId = session.stLoggedInUser.UserId)/>
            <cfif structKeyExists(userAddress, "Address")>
                <cfset var batches = databaseServiceObj.getNearByBatch(pincode=left(userAddress.Address.PINCODE[1],3))/>
            <cfelse>
                <cfset batches.error = "some error occurred. Please, try after sometimes."/>
            </cfif>
        </cfif>

        <cfreturn batches/>
    </cffunction>

    <!---function to make a request to batch for enrollment--->
    <cffunction  name="makeRequest" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for returning purpose for status of the request--->
        <cfset var requestStatus = {}/>
        <!---checking if the user is already requested for the batch--->
        <cfset var isRequested = databaseServiceObj.getMyRequests(studentId=session.stLoggedInUser.userId, batchId=arguments.batchId)/>
        <cfif structKeyExists(isRequested, "error")>
            <cflog  text="#cfcatch.detail#">
            <cfset requestStatus['error'] = "failed to make a request. Please try after sometime"/>
        <cfelseif isRequested.requests.recordCount GT 0>
            <cflog  text="error">
            <cfset requestStatus['warning'] = "Already you have requested for this batch. check your request status in your request option"/>
        <cfelseif isRequested.requests.recordCount EQ 0>
            <cfset requestStatus = databaseServiceObj.insertRequest(arguments.batchId, session.stLoggedInUser.userId, "Pending")/>
        </cfif>

        <cfreturn requestStatus/>
    </cffunction>

    <!---function to get the requests of the user made previously--->
    <cffunction  name="getBatchRequests" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for returning the structure of requested data--->
        <cfset var requestInfo = {}/>
        <cfset requestInfo = databaseServiceObj.getBatchRequests(arguments.batchId)/>

        <cfreturn requestInfo/>
    </cffunction>

    <!---function to get the user requests--->
    <cffunction  name="getMyRequests" access="remote" output="false" returntype="struct" returnformat="json">
        <!---variable to store the returned data from database service--->
        <cfset var requestInfo={}/>
        <!---calling the function as per the user--->
        <cfif session.stLoggedInUser.role EQ 'Teacher'>
            <cfset requestInfo=databaseServiceObj.getMyRequests(teacherId=session.stLoggedInUser.userId)/>
        <cfelseif session.stLoggedInUser.role EQ 'Student'>
            <cfset requestInfo=databaseServiceObj.getMyRequests(studentId=session.stLoggedInUser.userId)/>
        </cfif>
        <cfreturn requestInfo/>
    </cffunction>

    <!---fucntion to update the batch request status--->
    <cffunction  name="updateBatchRequest" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <cfargument  name="requestStatus" type="string" required="true">
        <!---structure containing the request action info--->
        <cfset var updateInfo = {}/>
        <!---get the details of request--->
        <cfset var requestDetailInfo = databaseServiceObj.getRequestDetails(arguments.batchRequestId)/>
        <cfif structKeyExists(requestDetailInfo, "error")>
            <cfset updateInfo.error = requestDetailInfo.error/>
        <cfelseif structKeyExists(requestDetailInfo, "requestDetails") AND requestDetailInfo.requestDetails.batchOwnerId EQ session.stLoggedInUser.userID>
            <cfset updateInfo = databaseServiceObj.updateBatchRequest(arguments.batchRequestId, arguments.requestStatus)/>
        </cfif>
        <cfreturn updateInfo/>
    </cffunction>

    <!---function to get the batch enrolled student--->
    <cffunction  name="getMyStudent" access="remote" output="false" returntype="struct" returnformat="json">
        <!---variable to get the students info--->
        <cfset var enrolledStudentInfo ={}/>
        <!---checking if the user is teacher or not--->
        <cfif session.stLoggedInUser.role EQ 'Teacher'>
            <cfset enrolledStudentInfo = databaseServiceObj.getEnrolledStudent(teacherId=session.stLoggedInUser.userId)/>
        <cfelse>
            <cfset enrolledStudentInfo.warning = "Sorry, You don't have any students"/>
        </cfif>
        
        <cfreturn enrolledStudentInfo/>
    </cffunction>

    <!---function to submit the feedback--->
    <cffunction  name="submitFeedback" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="feedback" type="string" required="false">
        <cfargument  name="rating" type="numeric" required="true">
        <!---returning the structure--->
        <cfset var feedbackSubmitInfo = {}/>
        <!---variable for student is enrolled--->
        <cfset var isEnrolled = false/>
        <cfset var enrolledStudentId = ''/>
        <!---if the user is enrolled to batch--->
        <cfset checkEnrollment = databaseServiceObj.collectStudentBatch(session.stLoggedInUser.userId)/>
        <!---if error occurred--->
        <cfif structKeyExists(checkEnrollment, "error")>
            <cfset feedbackSubmitInfo.error = "Some error occurred.Please, try after sometime"/>
        <cfelseif structKeyExists(checkEnrollment, "batches")>
            <!---loop over the batch data--->
            <cfloop query="checkEnrollment.batches">
                <cfif arguments.batchId EQ batchId>
                    <cfset isEnrolled = true/>
                    <cfset enrolledStudentId =batchEnrolledStudentId>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
        <cfif NOT structKeyExists(feedbackSubmitInfo, "error") AND isEnrolled>
            <cfset feedbackSubmitInfo = databaseServiceObj.insertFeedback(arguments.batchId, enrolledStudentId, 
                                                                            arguments.feedback, arguments.rating)/>
        </cfif>
        
        <cfreturn feedbackSubmitInfo>
    </cffunction>

    <!---function to get the feedbacks of particular batch--->
    <cffunction  name="retrieveBatchFeedback" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---struct--->
        <cfset var retrieveBatchFeedbackInfo = databaseServiceObj.retrieveBatchFeedback(arguments.batchId)/>
        <cfreturn retrieveBatchFeedbackInfo>
    </cffunction>
</cfcomponent>