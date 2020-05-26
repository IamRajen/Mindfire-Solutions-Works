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
    <cfset myFunctionObj = createObject("component","myFunction")/>

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
        <cfargument  name="batchTag" type="string" required="true">
        <!---deserializing the batch tags--->
        <cfset tags = deserializeJSON(arguments.batchTag)>
        <!---creating a variable for returning the msg as per required--->
        <cfset local.errorMsgs["validatedSuccessfully"] = true/>

        <!---creating a trimmed variable of every arguments--->
        <cfset local.name=trim(arguments.batchName)/>
        <cfset local.type=trim(arguments.batchType)/>
        <cfset local.details=trim(arguments.batchDetails)/>
        <cfset local.startDate=trim(arguments.batchStartDate)/>
        <cfset local.endDate=trim(arguments.batchEndDate)/>
        <cfset local.capacity=trim(arguments.batchCapacity)/>
        <cfset local.fee=trim(arguments.batchFee)/>

        <!---validating the argumnents--->
        <cfset local.errorMsgs['batchName'] = validateBatchName(local.name)/>
        <cfset local.errorMsgs['batchType'] = validateBatchType(local.type)/>
        <cfset local.errorMsgs['batchDetails'] = validateBatchDetails(local.details)/>
        <cfset local.errorMsgs['batchStartDate'] = validateBatchDate(local.startDate)/>
        <cfset local.errorMsgs['batchEndDate'] = validateBatchDate(local.endDate)/>
        <cfset local.errorMsgs['batchCapacity'] = validateBatchCapacity(local.capacity)/>
        <cfset local.errorMsgs['batchFee'] = validateBatchFee(local.fee)/>

        <cfif NOT structKeyExists(local.errorMsgs['batchStartDate'], 'msg') AND NOT structKeyExists(local.errorMsgs['batchEndDate'], 'msg')>
            <cfif dateTimeFormat(local.startDate, "MM/dd/yyyy") GT dateTimeFormat(local.endDate, "MM/dd/yyyy")>
                <cfset local.errorMsgs['batchEndDate']={'msg':'End date should more than start date'}/>
            </cfif>
        </cfif>

        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#local.errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and structKeyExists(local.errorMsgs[key],"msg")>
                <cfset local.errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif local.errorMsgs["validatedSuccessfully"]>
            <cftransaction> 
                <cftry>
                    <cfset local.myAddress = databaseServiceObj.getMyAddress(userId = session.stLoggedInUser.UserId)/>
                    <!---inserting the batch and getting the id--->
                    <cfset local.newBatch = databaseServiceObj.insertBatch(
                        #session.stloggedinUser.userID#, local.name, local.type, local.details, local.startDate,
                        local.endDate,LSParseNumber(local.capacity),
                        LSParseNumber(local.fee), 0,local.myAddress.userAddressId[1],"")/>
                    <!---looping over the tag array and inserting it into the tag table--->
                    <cfloop array="#tags#" index="tag">
                        <cfset local.newTag = databaseServiceObj.insertBatchTag(local.newBatch.generatedKey, tag)/>
                    </cfloop>
                    <cftransaction action="commit" />
                    <cfset local.errorMsgs["key"]=local.newBatch.generatedKey/>
                <cfcatch type="any">
                    <cflog  text="batchService: createBatch()-> #cfcatch#  #cfcatch.detail#">
                    <cfset local.errorMsgs["error"] = "Failed to create the batch. Please try after sometimes"/>
                    <cftransaction action="rollback" />
                </cfcatch>
                </cftry>
            </cftransaction>
        </cfif>
        <cfreturn local.errorMsgs/>
        

    </cffunction>

    <!---function to add batchTags into batchTag table--->
    <cffunction  name="insertBatchTag" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="tag" type="string" required="true">
        <!---structure to store the function info--->
        <cfset local.insertBatchTagInfo['validatedSuccessfully'] = true/>
        <!---validation starts here--->
        <cfif arguments.tag EQ ''>
            <cfset local.insertBatchTagInfo['validatedSuccessfully'] = false/>
            <cfset local.insertBatchTagInfo['tag'] = "Tag should not be empty"/>
        <cfelseif NOT patternValidationObj.validText(arguments.tag)>
            <cfset local.insertBatchTagInfo['validatedSuccessfully'] = false/>
            <cfset local.insertBatchTagInfo['tag'] = "Tag should contain only alphabets , numbers and spaces"/>
        </cfif>
        <!---if validated succesfully--->
        <cfif local.insertBatchTagInfo['validatedSuccessfully']>
            <cftry>
                <!--- get all batch tag--->
                <cfset local.batchTag = databaseServiceObj.getBatchTag(arguments.batchId)/>
                <cfloop query="batchTag">
                    <cfif tagName EQ arguments.tag>
                        <cfset local.insertBatchTagInfo.warning = "Sorry this tag is already been taken"/>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif NOT structKeyExists(local.insertBatchTagInfo, "warning")>
                    <cfset local.insertTag = databaseServiceObj.insertBatchTag(arguments.batchId, arguments.tag)/>
                    <cfset local.insertBatchTagInfo['key'] = local.insertTag.generatedKey/>
                </cfif>
            <cfcatch type="any">
                <cflog  text="batchService: insertBatchTagInfo()-> #cfcatch#  #cfcatch.detail#">
                <cfset local.insertBatchTagInfo['error'] = "Some error occurred."/>
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.insertBatchTagInfo/>
    </cffunction>

    <!---function to add notification--->
    <cffunction  name="addNotification" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="notificationTitle" type="string" required="true">
        <cfargument  name="notificationDetails" type="string" required="true">
        <!---creating a struture for returning purpose--->
        <cfset local.errorMsgs["validatedSuccessfully"]= true/>
        <!---validation works start from here--->
        <cfif (NOT patternValidationObj.validText(arguments.notificationTitle)) OR arguments.notificationTitle EQ ''>
            <cfset local.errorMsgs["notificationTitle"] = "Mandatory field and Should contain only alphanumeric characters and [_@./&:+-] symbols."/>
            <cfset local.errorMsgs["validatedSuccessfully"]=false/>
        <cfelseif len(arguments.notificationTitle) GT 20>
            <cfset local.errorMsgs["notificationTitle"] = "Field should not contain more than 20 characters"/>
            <cfset local.errorMsgs["validatedSuccessfully"]=false/>
        </cfif>
        <cfif (NOT patternValidationObj.validText(arguments.notificationDetails)) OR arguments.notificationDetails EQ ''>
            <cfset local.errorMsgs["notificationDetails"] = "Mandatory field and Should contain only alphanumeric characters and [_@./&:+-] symbols."/>
            <cfset local.errorMsgs["validatedSuccessfully"]=false/>
        <cfelseif len(arguments.notificationDetails) GT 200>
            <cfset local.errorMsgs["notificationDetails"] = "Field should not contain more than 200 characters"/>
            <cfset local.errorMsgs["validatedSuccessfully"]=false/>
        </cfif>

        <cfif local.errorMsgs["validatedSuccessfully"]>
            <cftransaction>
                <cftry>
                    <!---insertion process starts from here--->
                    <cfset local.batchNotification = databaseServiceObj.insertBatchNotification(
                        arguments.batchId, arguments.notificationTitle, arguments.notificationDetails
                    )/>
                    <!---getting the key of the inserted notification--->
                    <cfset local.batchNotificationId = local.batchNotification.GENERATEDKEY/>
                    <!---getting all enrolled students of this batch--->
                    <cfset local.enrolledStudents = databaseServiceObj.getEnrolledStudent(arguments.batchId)/>
                    <!---looping through the students--->
                    <cfloop query="enrolledStudents">
                        
                        <cfset local.insertedNotificationStatus = databaseServiceObj.insertNotificationStatus
                                                    (local.batchNotificationId, local.batchEnrolledStudentId, 0)/>
                    </cfloop>
                    
                    <!---if every query get successfully executed then commit actoin get called--->
                    <cftransaction action="commit" />
                    <cfset local.errorMsgs["key"]= local.batchNotification.generatedKey/>
                <cfcatch type="any">
                    <cftransaction action="rollback" />
                    <cflog  text="batchService: addNotification()-> #cfcatch# #cfcatch.detail#">
                    <cfset local.errorMsgs['error'] = "some error occurred.Please try after sometimes"/>
                </cfcatch>
                </cftry>
            </cftransaction>
        </cfif>

        <cfreturn local.errorMsgs/>
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
        <cfset local.errorMsgs["validatedSuccessfully"] = true/>

        <!---creating a trimmed variable of every arguments--->
        <cfset local.name=trim(arguments.editBatchName)/>
        <cfset local.type=trim(arguments.editBatchType)/>
        <cfset local.details=trim(arguments.editBatchDetails)/>
        <cfset local.startDate=trim(arguments.editBatchStartDate)/>
        <cfset local.endDate=trim(arguments.editBatchEndDate)/>
        <cfset local.capacity=trim(arguments.editBatchCapacity)/>
        <cfset local.fee=trim(arguments.editBatchFee)/>

        <!---validating the argumnents--->
        <cfset local.errorMsgs['editBatchName'] = validateBatchName(local.name)/>
        <cfset local.errorMsgs['editBatchType'] = validateBatchType(local.type)/>
        <cfset local.errorMsgs['editBatchDetails'] = validateBatchDetails(local.details)/>
        <cfset local.errorMsgs['editBatchStartDate'] = validateBatchDate(local.startDate)/>
        <cfset local.errorMsgs['editBatchEndDate'] = validateBatchDate(local.endDate)/>
        <cfset local.errorMsgs['editBatchCapacity'] = validateBatchCapacity(local.capacity)/>
        <cfset local.errorMsgs['editBatchFee'] = validateBatchFee(local.fee)/>

        <cfif NOT structKeyExists(local.errorMsgs['editBatchStartDate'], 'msg') AND NOT structKeyExists(local.errorMsgs['editBatchEndDate'], 'msg')>
            <cfif dateTimeFormat(local.startDate, "MM/dd/yyyy") GT dateTimeFormat(local.endDate, "MM/dd/yyyy")>
                <cfset local.errorMsgs['editBatchEndDate']={'msg':'End date should more than start date'}/>
            </cfif>
        </cfif>

        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#local.errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and structKeyExists(local.errorMsgs[key],"msg")>
                <cfset local.errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>


        <cfif local.errorMsgs["validatedSuccessfully"]>

            <!---if successfully validated update work starts from here--->
            <cfset local.errorMsgs["updatedSuccessfully"] = databaseServiceObj.updateBatch(
                #arguments.batchId#, local.name, local.type, local.details, local.startDate, local.endDate,
                LSParseNumber(local.capacity), LSParseNumber(local.fee))/>
        </cfif>

        <cfreturn local.errorMsgs/>
        

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
        <cfset local.weekDays = {"Monday":"1","Tuesday":"2", "Wednesday":"3", "Thrusday":"4", "Friday":"5", "Saturday":"6", "Sunday":"7"}/>
        <!---creating a variable for storing the batch number of the update request--->
        <cfset local.batchNumber = arguments.batchId/>
        <cfset local.batchDeleted = structDelete(arguments, "batchId")/>     
        <!---declaring a structure for returning the result--->
        <cfset local.errorMsgs["validatedSuccessfully"] = true/>
        <cfset local.day = 0/>
        <!---looping the arguments for checking the errors for validation--->
        <cfloop collection="#arguments#" item="item">
            <cfif arguments[item].startTime NEQ '' and arguments[item].endTime NEQ ''>
                <cfif NOT patternValidationObj.validTime(arguments[item].startTime)>
                    <cfset local.errorMsgs["#local.day#"]["startTime"] = "Invalid time"/>
                    <cfset local.errorMsgs["validatedSuccessfully"] = false/>
                </cfif>
                <cfif NOT patternValidationObj.validTime(arguments[item].endTime)>
                    <cfset local.errorMsgs["#local.day#"]["endTime"] = "Invalid time"/>
                    <cfset local.errorMsgs["validatedSuccessfully"] = false/>
                </cfif>
                <cfif NOT structKeyExists(errorMsgs, "#item#")>
                    <cfset local.startTime = TimeFormat(arguments[item].startTime,"HH:mm")/>
                    <cfset local.endTime = TimeFormat(arguments[item].endTime,"HH:mm")/>
                    <cfif startTime GT endTime>
                        <cfset local.errorMsgs["#local.day#"]["endTime"]="end time should be more than start time"/>
                        <cfset local.errorMsgs["validatedSuccessfully"] = false/>
                    </cfif>
                </cfif>
            <cfelseif arguments[item].startTime NEQ '' and arguments[item].endTime EQ ''>
                <cfset local.errorMsgs["#local.day#"]["endTime"] = "Must also have the end time or you can keep both blank."/>
                <cfset local.errorMsgs["validatedSuccessfully"] = false/>
            <cfelseif arguments[item].startTime EQ '' and arguments[item].endTime NEQ ''>
                <cfset local.errorMsgs["#local.day#"]["startTime"] = "Must also have the start time or you can keep both blank."/>
                <cfset local.errorMsgs["validatedSuccessfully"] = false/>
            </cfif>
            <cfset local.day = local.day+1 />
        </cfloop>
        <!---calling update function for updating the timing--->
        <cfif local.errorMsgs["validatedSuccessfully"]>
            <!---using transaction for updating with respect to their id's--->
            <cftransaction>
                <cftry>
                    <cfloop collection="#arguments#" item="time">
                        <cfif arguments[time].startTime NEQ '' and arguments[time].endTime NEQ ''>
                            <cfif arguments[time].batchTimingId NEQ ''>
                                <!---update the timing--->
                                <cfset local.updateBatchTiming = databaseServiceObj.updateBatchTime
                                    (arguments[time].batchTimingId, arguments[time].startTime, arguments[time].endTime)/>
                            <cfelse>
                                <!---insert the timing--->
                                <cfset local.insertBatchTiming = databaseServiceObj.insertBatchTime
                                    (local.batchNumber, arguments[time].startTime, arguments[time].endTime, local.weekDays[time])/>
                            </cfif>
                        </cfif>
                    </cfloop>   
    
                    <!---if every query get successfully executed then commit actoin get called--->
                    <cftransaction action="commit" />
                    <cfset local.errorMsgs["updatedSuccessfully"]=true />
                <cfcatch type="any">
                    <!---if some error occured while transaction then the whole transaction will be rollback--->
                    <cfset local.errorMsgs["updatedSuccessfully"]=false/>
                    <cftransaction action="rollback" />
                </cfcatch>
                </cftry>
            </cftransaction>
        </cfif>

        <cfreturn local.errorMsgs/>
    </cffunction>

    <!---function to update the batch address id--->
    <cffunction  name="updateBatchAddressId" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressId" type="numeric" required="true">
        <!---calling funtion and initializing it into the returning variable--->
        <cfset  local.updateInfo['updatedSuccessfully'] = databaseServiceObj.updateBatchAddressId(arguments.batchId, arguments.addressId)/>
        <cfreturn local.updateInfo/>
    </cffunction>

    <!---function to update the batch address link--->
    <cffunction  name="updateBatchAddressLink" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressLink" type="string" required="true">
        <!---calling funtion and initializing it into the returning variable--->
        <cfset local.updateInfo['updatedSuccessfully'] = databaseServiceObj.updateBatchAddressLink(arguments.batchId, arguments.addressLink)/>
        <cfreturn local.updateInfo/>
    </cffunction>

    <!---function to validate the batch name--->
    <cffunction  name="validateBatchName" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchName" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchName)>
            <cfset local.errorMsg.msg="Mandatory Field.Please provide your batch name!!"/>
        <cfelseif NOT patternValidationObj.validHeading(arguments.batchName)>
            <cfset local.errorMsg.msg="Only alphabets and spaces allowed"/>
        <cfelseif len(arguments.batchName) GT 20>
            <cfset local.errorMsg.msg="batch name should be within 20 characters."/>
        </cfif>
        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate the batch details--->
    <cffunction  name="validateBatchDetails" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchDetails" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchDetails)>
            <cfset local.errorMsg.msg="Mandatory Field.Please provide your batch details!!"/>
        <cfelseif NOT patternValidationObj.validLargeText(arguments.batchDetails)>
            <cfset local.errorMsg.msg="Only alphabets and spaces allowed"/>
        <cfelseif len(arguments.batchDetails) GT 300>
            <cfset local.errorMsg.msg="batch details should be within 300 characters."/>
        </cfif>
        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate the batch type--->
    <cffunction  name="validateBatchType" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchType" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchType)>
            <cfset local.errorMsg.msg="Mandatory Field.Please provide your batch type!!"/>
        <cfelseif (arguments.batchType NEQ 'online') AND (arguments.batchType NEQ 'home') AND (arguments.batchType NEQ 'coaching')>
            <cfset local.errorMsg.msg="Invalid batch type please select from the required fields."/>
        </cfif>
        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate the batch dates--->
    <cffunction  name="validateBatchDate" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchDate" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchDate)>
            <cfset local.errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT isDate(arguments.batchDate)>
            <cfset local.errorMsg.msg="Not a Valid date!!"/>
        <cfelse>
            <cfset local.providedDate = dateTimeFormat(arguments.batchDate, "MM/dd/yyyy")>
            <cfif local.providedDate LT #now()#>
                <cfset local.errorMsg.msg="Date should be more than today date"/>
            </cfif>
        </cfif>

        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate batch capacity--->
    <cffunction  name="validateBatchCapacity" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchCapacity" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchCapacity)>
            <cfset local.errorMsg.msg="Mandatory Field.Please provide your batch capacity!!"/>
        <cfelseif NOT patternValidationObj.validNumber(arguments.batchCapacity)>
            <cfset local.errorMsg.msg="Only numbers allowed!!"/>
        <cfelseif LSParseNumber(arguments.batchCapacity) GT 30000>
            <cfset local.errorMsg.msg="Batch Capacity must be within 30000"/>
        </cfif>

        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to validate batch fee--->
    <cffunction  name="validateBatchFee" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchFee" type="string" required="true">
        <!---creating a structure for returning the error msgs--->
        <cfset local.errorMsg={}/>
        <!---validation starts from here--->
        <cfif patternValidationObj.isEmpty(arguments.batchFee)>
            <cfset local.errorMsg.msg="Mandatory Field.Please provide your batch Fee!!"/>
        <cfelseif NOT patternValidationObj.validNumber(arguments.batchFee)>
            <cfset local.errorMsg.msg="Only numbers allowed!!"/>
        <cfelseif LSParseNumber(arguments.batchFee) GT 1000000>
            <cfset local.errorMsg.msg="Batch Fee should not exceed 10Lacs"/>
        </cfif>

        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to retrieve the all batches of specific teacher--->
    <cffunction  name="getMyBatch" output="false" access="public" returntype="struct" returnformat="json">
        <!---creating a structure for returning data--->
        <cfset local.batches={}/>
        <cftry>
            <!---calling required function as user type--->
            <cfif session.stLoggedInUser.role EQ 'Teacher'>
                <cfset local.batches.batch=databaseServiceObj.getUserBatch(teacherId=session.stLoggedInUser.userID)/>
            <cfelseif session.stLoggedInUser.role EQ 'Student'> 
                <cfset local.batches.batch=databaseServiceObj.getUserBatch(studentId=session.stLoggedInUser.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.batches['error'] = 'Some error occured. please try after sometimes'/>
        </cfcatch>
        </cftry>
        <cfreturn local.batches/>
    </cffunction>

    <!---function to get the batch information like overview timing and feedbacks by it's Id--->
    <cffunction  name="getBatchDetailsByID" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for storing the returned value from database function call--->
        <cfset local.batchDetails = {}/>

        <cftry> 
            <!---checking the batch is of the requested user--->
            <cfset local.batchDetails.overview = databaseServiceObj.getBatchById(arguments.batchId)/>
            <cfif local.batchDetails.overview.recordCount EQ 0>
                <cfthrow>
            </cfif>
            
            <cfset local.batchDetails.timing = getBatchTimingById(arguments.batchId)/>
            <!---getting the tags of batch--->
            <cfset local.batchDetails.tag = databaseServiceObj.getBatchTag(arguments.batchId)/>

            <!---getting the batch address--->
            <cfif local.batchDetails.overview.batchType EQ 'online'>
                <cfset local.batchDetails.address = local.batchDetails.overview.addressLink/>
            <cfelseif structKeyExists(session, 'stLoggedInUser') AND local.batchDetails.overview.batchOwnerId EQ session.stLoggedInUser.userId>
                <cfset local.batchDetails.address = databaseServiceObj.getMyAddress(userId = session.stLoggedInUser.UserId)/>
            <cfelse>
                <cfset local.batchDetails.address = databaseServiceObj.getMyAddress(addressId = local.batchDetails.overview.addressId)/>
            </cfif>
            <!---getting batch request--->
            <cfset local.batchDetails.request = databaseServiceObj.getBatchRequests(arguments.batchId)/>
            <!---getting the notifications of batch--->
            <cfset local.batchDetails.notification = databaseServiceObj.getBatchNotifications(arguments.batchId)/>
            <!---getting batch request--->
            <cfset local.batchDetails.enrolledStudent =databaseServiceObj.getEnrolledStudent(batchId=arguments.batchId)/>
            <!---getting batch feedback--->
            <cfset local.batchDetails.feedback = databaseServiceObj.retrieveBatchFeedback(arguments.batchId)/> 
        
        <cfcatch type="any">
            <cflog  text="getBatchDetailsByID()-> #cfcatch# #cfcatch.detail#">
            <!---if no such batch is found it will diplay a error msg of no batch--->
            <cfset structClear(local.batchDetails)/>
            <cfset local.batchDetails['error'] = "some error occurred. Please try after sometimes"/>
        </cfcatch>
        </cftry>
        
        <cfreturn local.batchDetails/>
        
    </cffunction>

    <!---function to get batch overview by id--->
    <cffunction  name="getBatchOverviewById" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfset local.funcInfo = {}/>
        <cftry>
            <cfset local.funcInfo.batch = databaseServiceObj.getBatchById(arguments.batchId)/>
        <cfcatch type="any">
            <cfset local.funcInfo['error'] = 'Some error occurred.Please try after sometimes'/>
        </cfcatch>
        </cftry>
        <cfreturn local.funcInfo>
    </cffunction>

    <!---function to get the batch timing --->
    <cffunction  name="getBatchTimingById" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cftry>
            <!---declaring a structure for returning the value of batch overview--->
            <cfset local.batchTiming = databaseServiceObj.getBatchTime(arguments.batchId)/>
            <!---creating the timing array of batch --->
            <cfset local.days = ["Monday","Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday", "Sunday"]/>
            <cfset local.timeArray = [{},{},{},{},{},{},{}]/>
            <!---returning structure of batch timing --->
            <cfset local.timing = {}/>
            <!---looping over batch timing to create a structure of timing--->
            <cfset local.rowNum = 1/>
            <cfloop query="batchTiming">
                <cfset local.timeArray[#local.batchTiming.day#]['#local.days[local.batchTiming.day]#']=QueryGetRow(local.batchTiming, local.rowNum)/>
                <cfset local.rowNum = local.rowNum+1/>
            </cfloop>
            <cfloop from="1" to="#arrayLen( local.timeArray )#" index="i">
                <cfif structIsEmpty(local.timeArray[i])>
                    <cfset local.timeArray[i]['#local.days[i]#'] = {}/>
                </cfif>
            </cfloop>
            <cfset local.timing.time = local.timeArray/>
        <cfcatch type="any">
            <cfset local.timing['error']="some error occurred.Please try after sometime"/>
        </cfcatch>
        </cftry>
    
        <cfreturn local.timing/>
    </cffunction>

    <!---function to all the notification of the user--->
    <cffunction  name="getMyNotification" output="false" access="remote" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="notificationStatusId" type="numeric" required="false">
        <cfargument  name="notificationId" type="numeric" required="false">
        <cfset local.notificationInfo = {}/>
        <cftry>
            <cfif structKeyExists(arguments, "notificationStatusId") AND structKeyExists(arguments, "notificationId")>
                <cfset local.notificationInfo.notification = databaseServiceObj.markNotificationAsRead(arguments.notificationStatusId, arguments.notificationId)/>
            <cfelseif structKeyExists(arguments, "notificationId")>
                <cfset local.notificationInfo.notification = databaseServiceObj.getNotificationByID(arguments.notificationId)/>
            <cfelseif NOT structKeyExists(session, "stLoggedInUser")>
                <cfset local.notificationInfo.warning = "Sorry you are not logged in"/>
            <cfelseif session.stLoggedInUser.role EQ 'Student'>
                <cfset local.notificationInfo.notifications = databaseServiceObj.getMyNotification(session.stLoggedInUser.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.notificationInfo['error'] = "Some error occurred.Please try after sometimes"/>
        </cfcatch>
        </cftry>
        
        <cfreturn local.notificationInfo/>
    </cffunction>

    <!---function to delete notification from notification table using it's iD--->
    <cffunction  name="deleteNotification" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---calling the database function for deleting the notification--->
        <cfset local.notificationInfo.deletedSuccessfully = databaseServiceObj.deleteNotification(arguments.batchNotificationId)/>
        <cfreturn local.notificationInfo/>
    </cffunction> 

    <!---function to delete batch Tag--->
    <cffunction  name="deleteBatchTag" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchTagId" type="numeric" required="true">
        <!---structure to store function information--->
        <cfset local.deleteBatchTagInfo.deletedSuccessfully = databaseServiceObj.deleteBatchTag(arguments.batchTagId)/>
        <cfreturn local.deleteBatchTagInfo>
    </cffunction>

    <!---function to get the nearby batches of user--->
    <cffunction  name="getNearByBatch" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="country" type="string" required="false">
        <cfargument  name="state" type="string" required="false">
        <cfset local.batches = {}/>
        <cftry>
            <cfif arguments.country NEQ '' AND arguments.state EQ ''>
                <!---calling function for retrieving the batches by country--->
                <cfset local.batches.batch = databaseServiceObj.getNearByBatch(country=arguments.country)/>
            <cfelseif arguments.state NEQ ''>
                <!---calling function for retrieving the batches by state--->
                <cfset local.batches.batch = databaseServiceObj.getNearByBatch(country=arguments.country, state=arguments.state)/>
            <cfelseif NOT structKeyExists(session, "stLoggedInUser")>
                <cfset local.batches.batch = databaseServiceObj.getNearByBatch(pincode='')/>
            <cfelse>
                <!---calling function for retrieving the near by batches--->
                <cfset local.userAddress = databaseServiceObj.getMyAddress(userId = session.stLoggedInUser.UserId)/>
                <cfset local.batches.batch = databaseServiceObj.getNearByBatch(pincode=left(local.userAddress.PINCODE[1],3))/>
            </cfif>
        <cfcatch type="any">
            <cfset local.batches['error'] = 'Some error occurred.Please try after sometimes'/>
        </cfcatch>
        </cftry>

        <cfreturn local.batches/>
    </cffunction>

    <!---function to make a request to batch for enrollment--->
    <cffunction  name="makeRequest" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for returning purpose for status of the request--->
        <cfset local.requestStatus = {}/>
        <cftransaction>
            <cftry>
                <!---checking if the user is already requested for the batch--->
                <cfset local.isRequested = databaseServiceObj.getMyRequests(studentId=session.stLoggedInUser.userId, batchId=arguments.batchId)/>
                <cfif local.isRequested.recordCount GT 0>
                    <cfset requestStatus['warning'] = "Already you have requested for this batch. check your request status in your request option"/>
                <cfelseif local.isRequested.recordCount EQ 0>
                    <cfset newRequest = databaseServiceObj.insertRequest(arguments.batchId, session.stLoggedInUser.userId, "Pending")/>
                    <cfset local.requestStatus['key'] = newRequest.generatedKey/>
                </cfif>
                <cftransaction action="commit">
            <cfcatch type="any">
                <cflog  text="#cfcatch# #cfcatch.detail#">
                <cfset local.requestStatus['error'] = "Some error occurred.Please try after sometimes"/>
                <cftransaction action="rollback">
            </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn local.requestStatus/>
    </cffunction>

    <!---function to get the requests of the user made previously--->
    <cffunction  name="getBatchRequests" access="remote" output="false" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---creating a variable for returning the structure of requested data--->
        <cfset local.requestInfo = {}/>
        <cftry>
            <cfset local.requestInfo.requests = databaseServiceObj.getBatchRequests(arguments.batchId)/>
        <cfcatch type="any">
            <cfset local.requestInfo['error']= "Some error occurred.Please try after sometimes"/>
        </cfcatch>
        </cftry>

        <cfreturn local.requestInfo/>
    </cffunction>

    <!---function to get the user requests--->
    <cffunction  name="getMyRequests" access="remote" output="false" returntype="struct" returnformat="json">
        <!---variable to store the returned data from database service--->
        <cfset local.requestInfo={}/>
        <cftry>
            <!---calling the function as per the user--->
            <cfif session.stLoggedInUser.role EQ 'Teacher'>
                <cfset local.requestInfo.requests=databaseServiceObj.getMyRequests(teacherId=session.stLoggedInUser.userId)/>
            <cfelseif session.stLoggedInUser.role EQ 'Student'>
                <cfset local.requestInfo.requests=databaseServiceObj.getMyRequests(studentId=session.stLoggedInUser.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.requestInfo['error'] = 'Some error occurred.Please try after sometimes'/>
        </cfcatch>
        </cftry>
    
        <cfreturn local.requestInfo/>
    </cffunction>

    <!---fucntion to update the batch request status--->
    <cffunction  name="updateBatchRequest" access="remote" output="false" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <cfargument  name="requestStatus" type="string" required="true">
        <!---structure containing the request action info--->
        <cfset local.updateInfo = {}/>
        <!---get the details of request--->
        <cfset local.requestDetailInfo = databaseServiceObj.getRequestDetails(arguments.batchRequestId)/>
        <cfif local.requestDetailInfo.batchOwnerId EQ session.stLoggedInUser.userID>
            <cfif arguments.requestStatus EQ 'Rejected'>
                <cfset local.updateInfo['deletedSuccessfully'] = databaseServiceObj.deleteBatchRequest(arguments.batchRequestId)/>
            <cfelse>
                <cfset local.updateInfo['updatedSuccessfully'] = databaseServiceObj.updateBatchRequest(arguments.batchRequestId, arguments.requestStatus)/>
            </cfif>
        </cfif>
        <cfreturn local.updateInfo/>
    </cffunction>

    <!---function to get the batch enrolled student--->
    <cffunction  name="getMyStudent" access="remote" output="false" returntype="struct" returnformat="json">
        <!---variable to get the students info--->
        <cfset local.enrolledStudentInfo ={}/>
        <cftry>
            <!---checking if the user is teacher or not--->
            <cfif structKeyExists(session, "stLoggedInUser")>
                <cfset local.enrolledStudentInfo.students = databaseServiceObj.getEnrolledStudent(teacherId=session.stLoggedInUser.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.enrolledStudentInfo['error'] = 'Some error occurred.Please try after sometimes'/>
        </cfcatch>
        </cftry>
        
        <cfreturn local.enrolledStudentInfo/>
    </cffunction>

    <!---function to submit the feedback--->
    <cffunction  name="submitFeedback" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="feedback" type="string" required="false">
        <cfargument  name="rating" type="numeric" required="true">
        <!---returning the structure--->
        <cfset local.feedbackSubmitInfo['validatedSuccessfully'] = true/>
        <!---validation of feedback text--->
        <cfif NOT patternValidationObj.validText(arguments.feedback)>
            <cfset local.feedbackSubmitInfo['feedback'] = 'Only alphabets, numbers and spaces allowed'/>
            <cfset local.feedbackSubmitInfo['validatedSuccessfully'] = false/>
        </cfif>
        <!---if validated successfully--->
        <cfif local.feedbackSubmitInfo['validatedSuccessfully']>
            <!---variable for student is enrolled--->
            <cfset local.isEnrolled = false/>
            <cfset local.enrolledStudentId = ''/>
            <cftry>
                <!---if the user is enrolled to batch--->
                <cfset local.checkEnrollment = databaseServiceObj.getUserBatch(studentId=session.stLoggedInUser.userId)/>
                <!---loop over the batch data--->
                <cfloop query="local.checkEnrollment">
                    <cfif arguments.batchId EQ batchId>
                        <cfset local.isEnrolled = true/>
                        <cfset local.enrolledStudentId = batchEnrolledStudentId>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif local.isEnrolled>
                    <cfset local.newFeedback = databaseServiceObj.insertFeedback(arguments.batchId, local.enrolledStudentId, arguments.feedback, arguments.rating)/>
                    <cfset local.feedbackSubmitInfo['key'] = newFeedback.generatedKey/>
                </cfif>
            <cfcatch type="any">
                <cfset local.feedbackSubmitInfo['error'] = "Some error occurred.Please try after sometimes"/>
            </cfcatch>
            </cftry>
        </cfif>
        
        <cfreturn local.feedbackSubmitInfo>
    </cffunction>

    <!---function to get the feedbacks of particular batch--->
    <cffunction  name="retrieveBatchFeedback" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cftry>
            <cfset local.retrieveBatchFeedbackInfo.feedbacks = databaseServiceObj.retrieveBatchFeedback(arguments.batchId)/>
        <cfcatch type="any">
            <cfset local.retrieveBatchFeedbackInfo['error'] = "Some error occurred. Please try after sometimes"/>
        </cfcatch>
        </cftry>
        
        <cfreturn local.retrieveBatchFeedbackInfo>
    </cffunction>

    <!---function to get the searched result of batch--->
    <cffunction  name="getSearchBatches" output="false" access="remote" returntype="struct" returnformat="json">
        <!---arguments--->
        <cfargument  name="searchedQuery" type="string" required="true">
        <!---get the list of words out of the searchQuery--->
        <cfset local.searchList = myFunctionObj.removeStopWords(arguments.searchedQuery)/>
        <cfset local.batches = {}/>
        <cftry>
            <!---getting the batches from database--->
            <cfloop array="#local.searchList#" index="word">
                <cfset local.batchesWithWord['#word#'] = databaseServiceObj.getSearchResult(word)/>
            </cfloop>

            <!---creating a structure for storing the batches as per rank--->
            <cfset local.batches = {}>

            <!---looping over the structure --->
            <cfloop collection="#local.batchesWithWord#" item="word">
                <!---initializing a variable for current row--->
                <cfset local.row = 1/>
                <!---looping the query result as per keys--->
                <cfloop query="#local.batchesWithWord[word]#">
                    <!---if batch in already present then it will increase the rank of that batch--->
                    <cfif structKeyExists(local.batches, '#batchId#')>
                        <cfset local.batches['#batchId#'].rank = (local.batches['#batchId#'].rank)+1>
                    <!---else it will insert the batch with batchId as a key--->
                    <cfelseif NOT structKeyExists(local.batches, '#batchId#')>
                        <cfset structInsert(local.batches, '#batchId#',  { batch: queryGetRow(local.batchesWithWord[word], row)  , rank:1} )>
                    </cfif>
                    <cfset local.row = local.row+1/>
                </cfloop>
            </cfloop>
            <cfif NOT structIsEmpty(local.batches)>
                <cfset local.rankedBatchId = structSort(local.batches, 'numeric', 'DESC', 'rank')/>
                <cfset local.batchArray = arrayNew(1)/>
                <cfloop array="#local.rankedBatchId#" index="batchId">
                    <cfset arrayAppend(local.batchArray, local.batches[#batchId#].batch)/>
                </cfloop>
                <cfset structClear(local.batches)>
                <cfset local.batches.batch = queryNew("address, batchDetails, batchId, batchName, batchOwnerId, batchType, capacity, 
                                                city, country, endDate, enrolled, fee, pincode, startDate, state, tagName",
                                                "VarChar, VarChar,  bigint, VarChar, bigint, VarChar, Integer, VarChar, VarChar, Date, Integer, 
                                                Double, VarChar, date, VarChar, Varchar",
                                                local.batchArray)/>
                
            </cfif>

            <!---storing the searched tags in the table--->
            <cfif structKeyExists(local.batches, "batch") AND local.batches.batch.recordCount GT 0>
                <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Student'>
                    <cfset local.myAddress= databaseServiceObj.getMyAddress(session.stLoggedInUser.userId)>
                    <cfset local.pincode = local.myAddress.pincode[1]>
                <cfelse>
                    <cfset local.pincode=''>
                </cfif>
                <!---looping over the retrived batch structure query and if records are greater than 0 then that word will stored--->
                <cfloop collection="#local.batchesWithWord#" item="word">
                    <cfif local.batchesWithWord[word].recordCount GT 0>
                        <cfset local.insertSearchedTag = databaseServiceObj.insertSearchedTag(tag=word, pincode=pincode)/>
                    </cfif>
                </cfloop>
            </cfif>
        <cfcatch type="any">
            <cflog  text="#cfcatch# #cfcatch.detail#">
            <cfset local.batches['error'] = "Some error occurred. Please try after sometimes"/>
        </cfcatch>
        </cftry>
        
        <cfreturn local.batches>
        
    </cffunction>

    <!---fucntion to get the batchTag--->
    <cffunction  name="getBatchTag" output="false" access="remote" returntype="struct" returnformat="json">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cftry>
            <cfset local.batchTag.tags = databaseServiceObj.getBatchTag(arguments.batchId)/>
        <cfcatch type="any">
            <cfset local.batchTag['error'] = "Some error occurred.Please try after sometimes"/> 
        </cfcatch>
        </cftry>
        
        <cfreturn local.batchTag/>
    </cffunction>

    <!---function to get the most searched words--->
    <cffunction  name="getTrendingWord" output="false" access="remote" returntype="struct" returnformat="json">
        <!---structure for function info--->
        <cfset local.funcInfo = {}/>
        <!---variable to store the pincode--->
        <cfset local.pincode = ''/>
        <cftry>
            <!---checking for the user type--->
            <cfif structKeyExists(session, "stLoggedInUser")>
                <!---get the current address of user from the address database--->
                <cfset local.myAddress = databaseServiceObj.getMyAddress(session.stLoggedInUser.userId)/>
                <cfset local.pincode = left(myAddress.pincode[0], 3)/>
            </cfif>
            <cfset local.funcInfo.words = databaseServiceObj.getTrendingWord(local.pincode)/>
        <cfcatch type="any">
            <cfset local.funcInfo['error'] = "Some error occurred.Please try after sometimes"/>
        </cfcatch>
        </cftry>
        
        <cfreturn local.funcInfo>
    </cffunction>

    <!---function to get the information about the our website--->
    <cffunction  name="getOurDetails" output="false" access="remote" returntype="struct" returnformat="json">
        <!---structure for function info--->
        <cfset local.funcInfo = {}/>
        <cftry>
            <cfset local.funcInfo.teacher = databaseServiceObj.getUserCount(1)/>
            <cfset local.funcInfo.student = databaseServiceObj.getUserCount(0)/>
            <cfset local.funcInfo.batch = databaseServiceObj.getBatchCount()/>
        <cfcatch type="any">
            <cflog  text="batchService: getOurDetails()-> #cfcatch# #cfcatch.detail#">
            <cfset structClear(local.funcInfo)/>
            <cfset local.funcInfo['error'] = "some error occurred.Please try after sometime"/>
        </cfcatch>
        </cftry>
            
        <cfreturn local.funcInfo>
    </cffunction>

</cfcomponent>