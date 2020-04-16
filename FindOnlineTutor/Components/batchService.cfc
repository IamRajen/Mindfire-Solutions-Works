<!---
Project Name: FindOnlineTutor.
File Name: batchService.cfc.
Created In: 16th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file contains the functions which help to give required services to batches..!!
--->

<cfcomponent output="false">

    <cfset patternvalidationObj = createObject("component","patternValidation")/>
    <cfset databaseValidationObj = createObject("component","databaseService")/>
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

            <cfset var newBatch = databaseValidationObj.insertBatch(
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
    <cffunction  name="getTeacherBatch" output="false" access="access" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchOwnerId" type="any" required="true"/>
        
    </cffunction>

</cfcomponent>