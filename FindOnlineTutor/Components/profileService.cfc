<!---
Project Name: FindOnlineTutor.
File Name: profileService.cfc.
Created In: 6th May 2020
Created By: Rajendra Mishra.
Functionality: This file contains some functions helps in user profile.
--->

<cfcomponent output="false">
    <cfset databaseServiceObj = createObject("component","databaseService")/>
    <cfset patternValidationObj=createObject("component","patternValidation")/>
    
    <!---update user profile--->
    <cffunction  name="updateUserProfile" access="remote" output="false" returnformat="json" returntype="struct">
        <!---arguments declaration--->

        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="bio" type="string" required="false"/>
        
        <!--- creating a struct for error messages and calling the required functions--->
        <cfset local.updateUserProfileInfo["validatedSuccessfully"] = true/>

        <!---validation work starts here--->
        <cfset local.updateUserProfileInfo["firstName"]=patternValidationObj.validName(arguments.firstName)/>
        <cfset local.updateUserProfileInfo["lastName"]=patternValidationObj.validName(arguments.lastName)/>
        <cfset local.updateUserProfileInfo["emailAddress"]=patternValidationObj.validEmail(arguments.emailAddress)/>
        
        <cfif arguments.bio NEQ ''>
            <cfset local.updateUserProfileInfo["bio"]=patternValidationObj.validText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#local.updateUserProfileInfo#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and local.updateUserProfileInfo[key] NEQ true>
                <cfset local.updateUserProfileInfo["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>
        <!---validation work end here--->

        <!---updating work starts here--->
        <cfif local.updateUserProfileInfo["validatedSuccessfully"]>
            <cfset local.updateUserProfileInfo['updatedSuccessfully'] = databaseServiceObj.updateUser(
                arguments.firstName, arguments.lastName, arguments.emailAddress, arguments.dob, arguments.bio
            )/>
        </cfif>

        <cfreturn local.updateUserProfileInfo/>
    </cffunction>


    <!---update user profile--->
    <cffunction  name="updateUserPhoneNumber" access="remote" output="false" returnformat="json" returntype="struct">
        <!---arguments declaration--->

        <cfargument  name="primaryPhoneNumber" type="string" required="true"/>
        <cfargument  name="alternativePhoneNumber" type="string" required="false"/>

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset local.updateUserPhoneNumberInfo={}>
        <cfset local.updateUserPhoneNumberInfo["validatedSuccessfully"]=true/>

        <cfset local.updateUserPhoneNumberInfo["primaryPhoneNumber"]=patternValidationObj.validNumber(arguments.primaryPhoneNumber)/>

        <cfif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber NEQ arguments.primaryPhoneNumber>
            <cfset local.updateUserPhoneNumberInfo["alternativePhoneNumber"]=patternValidationObj.validNumber(arguments.alternativePhoneNumber)/>
        <cfelseif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber EQ arguments.primaryPhoneNumber>
            <cfset local.updateUserPhoneNumberInfo["alternativePhoneNumber"]="Alternative number should not be same.You can keep this blank."/>
        </cfif>

        
        <!---looping the local.updateUserPhoneNumberInfo struct for validation--->
        <cfloop collection="#local.updateUserPhoneNumberInfo#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and local.updateUserPhoneNumberInfo[key] NEQ true>
                <cfset local.updateUserPhoneNumberInfo["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif local.updateUserPhoneNumberInfo["validatedSuccessfully"]>
            <cftransaction>
                <cftry>
                    <!---updating phone numbers--->
                    
                    <!---getting the phone numbers of user--->
                    <cfset local.userPhoneNumbers = databaseServiceObj.getMyPhoneNumber(session.stLoggedinuser.userID)/> 
                    <!---updating the primary phone number--->
                    <cfset local.phoneInfoUpdate=databaseServiceObj.updatePhoneNumber(
                        local.userPhoneNumbers.userPhoneNumberId[1], arguments.primaryPhoneNumber
                    )/>
                    
                    <!---checking if user have the alternative phone number if yes, will update or insert--->
                    <cfif local.userPhoneNumbers.RecordCount EQ 2> 
                        <cfset local.phoneInfoUpdate=databaseServiceObj.updatePhoneNumber(
                            local.userPhoneNumbers.userPhoneNumberId[2], arguments.alternativePhoneNumber
                        )/>
                    <!---if alternative phone number not present it will insert a phone number--->
                    <cfelseif arguments.alternativePhoneNumber NEQ ''>
                        <cfset local.insertPhone = databaseServiceObj.insertPhoneNumber(
                            session.stLoggedinuser.userID,arguments.alternativePhoneNumber
                        )/>
                    </cfif>  

                    <cftransaction action="commit" />
                    <cfset local.updateUserPhoneNumberInfo['updatedSuccessfully'] = true>  
                <cfcatch type="any">
                    <cflog  text="#cfcatch#">
                    <cftransaction action="rollback">
                    <cfset local.updateUserPhoneNumberInfo["updatedSuccessfully"]=false/>
                </cfcatch>
                </cftry>
            </cftransaction>
        </cfif>

        <cfreturn errorMsgs/>
    </cffunction>


    <!---update user Address--->
    <cffunction  name="updateUserAddress" access="remote" output="false" returnformat="json" returntype="struct">
        <!---arguments declaration--->

        <cfargument  name="currentAddress" type="string" required="true"/>
        <cfargument  name="currentCountry" type="string" required="true"/>
        <cfargument  name="currentState" type="string" required="true"/>
        <cfargument  name="currentCity" type="string" required="true"/>
        <cfargument  name="currentPincode" type="string" required="true"/>

        <cfargument  name="havingAlternativeAddress" type="boolean" required="true"/>

        <cfargument  name="alternativeAddress" type="string" required="false"/>
        <cfargument  name="alternativeCountry" type="string" required="false"/>
        <cfargument  name="alternativeState" type="string" required="false"/>
        <cfargument  name="alternativeCity" type="string" required="false"/>
        <cfargument  name="alternativePincode" type="string" required="false"/>

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset local.funcInfo={}>
        <cfset local.funcInfo["validatedSuccessfully"]=true/>
        
        <cfset local.funcInfo["currentAddress"]=patternValidationObj.validText(arguments.currentAddress)/>
        <cfset local.funcInfo["currentCountry"]=patternValidationObj.validText(arguments.currentCountry)/>
        <cfset local.funcInfo["currentState"]=patternValidationObj.validText(arguments.currentState)/>
        <cfset local.funcInfo["currentCity"]=patternValidationObj.validText(arguments.currentCity)/>
        <cfset local.funcInfo["currentPincode"]=patternValidationObj.validNumber(arguments.currentPincode)/>

        <cfif arguments.havingAlternativeAddress>
            <cfset local.funcInfo["alternativeAddress"]=patternValidationObj.validText(arguments.alternativeAddress)/>
            <cfset local.funcInfo["alternativeCountry"]=patternValidationObj.validText(arguments.alternativeCountry)/>
            <cfset local.funcInfo["alternativeState"]=patternValidationObj.validText(arguments.alternativeState)/>
            <cfset local.funcInfo["alternativeCity"]=patternValidationObj.validText(arguments.alternativeCity)/>
            <cfset local.funcInfo["alternativePincode"]=patternValidationObj.validNumber(arguments.alternativePincode)/>
        </cfif>
        
        
        <!---looping the funcInfo struct for validation--->
        <cfloop collection="#local.funcInfo#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and local.funcInfo[key] NEQ true>
                <cfset local.funcInfo["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif local.funcInfo["validatedSuccessfully"]>
            <cftransaction>
                <cftry>
                    <!---updating addresses--->

                    <!---getting the addresses of user--->
                    <cfset local.userAddresses = databaseServiceObj.getMyAddress(session.stLoggedinuser.userID)/>
                    <!---updating the current address--->
                    <cfset local.addressInfoUpdate=databaseServiceObj.updateAddress(
                        local.userAddresses.userAddressId[1], arguments.currentAddress, arguments.currentCountry,
                        arguments.currentState, arguments.currentCity, arguments.currentPincode
                    )/>
                    <!---updating the alternative address if present else inserting the address--->
                    <cfif local.userAddresses.RecordCount EQ 2>
                        <cfset local.addressInfoUpdate=databaseServiceObj.updateAddress(
                            local.userAddresses.userAddressId[2], arguments.alternativeAddress, arguments.alternativeCountry,
                            arguments.alternativeState, arguments.alternativeCity, arguments.alternativePincode
                        )/>
                    <!---inserting the alternative address --->
                    <cfelseif arguments.alternativeAddress NEQ ''>
                        <cfset local.insertAlternativeAddress = databaseServiceObj.insertAddress(
                            session.stLoggedInUser.userId,arguments.alternativeAddress, arguments.alternativeCountry, arguments.alternativeState,
                            arguments.alternativeCity, arguments.alternativePincode).generatedKey/>
                        
                    </cfif> 

                    <cftransaction action="commit" />
                    <cfset local.funcInfo['updatedSuccessfully'] = true>  
                <cfcatch type="any">
                    <cflog  text="#cfcatch#">
                    <cfset local.funcInfo['updatedSuccessfully'] = false> 
                    <cftransaction action="rollback">
                </cfcatch>
                </cftry>
            </cftransaction>
        </cfif>

        <cfreturn local.funcInfo/>
    </cffunction>

    <!---update user profile--->
    <cffunction  name="updateUserInterest" access="remote" output="false" returnformat="json" returntype="struct">
        <!---arguments declaration--->

        <cfargument  name="otherLocation" type="numeric" required="true"/>
        <cfargument  name="homeLocation" type="numeric" required="true"/>
        <cfargument  name="online" type="numeric" required="true"/>

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset local.updateUserInterest={}>
        <cfset local.updateUserInterest["validatedSuccessfully"]=true/>

        <!---validation starts here--->
        <cfset local.updateUserInterest["otherLocation"] = patternValidationObj.isBit(arguments.otherLocation)/>
        <cfset local.updateUserInterest["homeLocation"] = patternValidationObj.isBit(arguments.homeLocation)/>
        <cfset local.updateUserInterest["online"] = patternValidationObj.isBit(arguments.online)/>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#local.updateUserInterest#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and local.updateUserInterest[key] NEQ true>
                <cfset local.updateUserInterest["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif local.updateUserInterest["validatedSuccessfully"]>
            <!---updating Interests and Facilities--->
            <cfset local.updateUserInterest['updatedSuccessfully'] = databaseServiceObj.updateInterest(
                arguments.otherLocation,arguments.homeLocation,arguments.online
            )/>
        </cfif>

        <cfreturn local.updateUserInterest/>
    </cffunction>



    <!---validating the email address for update--->
    <cffunction  name="validateEmail" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining arguments--->
        <cfargument  name="emailId" type="string" required="true"/>
        <!---declaring a structure for returing error msgs--->
        <cfset local.errorMsg={}/>
        <!---declaring a variable for further use--->
        <cfset local.email=trim(arguments.emailId)/>
        <!---validation works starts here--->
        <cfif patternValidationObj.isEmpty(local.email)>
            <cfset local.errorMsg.msg = "Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validEmail(local.email)>
            <cfset local.errorMsg.msg="Invalid Email Address"/>
        <cfelse>
            <cftry>
                <cfset local.user = databaseServiceObj.getUser(emailAddress = local.email)/>
                <cfif (local.user.userId[1] NEQ #session.stLoggedinuser.userID#)>
                    <cfset local.errorMsg.msg="Email address already present"/>
                </cfif>
            <cfcatch type="any">
                <cfset local.errorMsgs.error="Some error occurred"/>
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.errorMsg/> 
    </cffunction>

    <!---validating the phone Number for update--->
    <cffunction  name="validatePhone" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining the argument--->
        <cfargument  name="phoneNumber" type="string" required="true"/>
        <!---declaring a structure for returning error msgs--->
        <cfset local.errorMsg={}/>
        <!---declaring a variable for further usage--->
        <cfset local.phone=trim(arguments.phoneNumber)/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(phone)>
            <cfset local.errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validNumber(local.phone)>
            <cfset local.errormsg.msg="Invalid Phone Number.Only numbers allowed.">
        <cfelse>
            <cftry>
                <cfset local.user = databaseServiceObj.getUser(phoneNumber= local.phone)/>
                <cfif local.user.userId[1] EQ session.stLoggedinuser.userId>
                    <cfset local.errorMsg.msg = "Phone number already exists"/>
                </cfif>
            <cfcatch type="any">
                <cfset local.errorMsg.error="#cfcatch# #cfcatch.detail#"/>
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn local.errorMsg/>
    </cffunction>

    <!---function to get the user profile information--->
    <cffunction  name="getUserDetails" output="false" access="remote" returntype="struct" retrunformat="json">
        <!---arguments--->
        <cfargument  name="userId" type="numeric" required="true">
        <!---structure to store the function information--->
        <cfset local.getUserDetailsInfo = {}/>
        <!---process starts from here--->
        <cftry>
            <!---user overview--->
            <cfset local.getUserDetailsInfo.overview = databaseServiceObj.getUser(userId = arguments.userId)/>

            <!---user address--->
            <cfset local.getUserDetailsInfo.address = databaseServiceObj.getMyAddress(arguments.userId)>

            <!---user batch--->
            <cfif local.getUserDetailsInfo.overview.isTeacher EQ 1>
                <cfset local.getUserDetailsInfo.batch = databaseServiceObj.getUserBatch(teacherId=arguments.userId)/>
            <cfelse>
                <cfset local.getUserDetailsInfo.batch = databaseServiceObj.getUserBatch(studentId=arguments.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.getUserDetailsInfo['error'] = "Some error occurred.Please try after sometimes"/>
        </cfcatch>
        </cftry>
        <cfreturn local.getUserDetailsInfo/>
    </cffunction>

    <!---function to get the userName--->
    <cffunction  name="getName" output="false" access="remote" returnType="struct" returnFormat="json">
        <!---arguments--->
        <cfargument  name="userId" type="numeric" required="true">
        <!---structure that contains function information--->
        <cfset local.getNameInfo = {}/>
        <!---variable that contains the query information--->
        <cfset var name = ''/>
        <!---query--->
        <cftry>
            <cfquery name="name">
                SELECT  [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS 'name'
                FROM    [dbo].[User]
                WHERE   [dbo].[User].[userId] = <cfqueryparam value='#arguments.userId#' cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset local.getNameInfo.name = name/>
        <cfcatch type="any">
            <cflog  text="profileService: databaseService()-> #cfcatch# #cfcatch.detail#">
            <cfset local.getNameInfo['error'] = "Some error occurred.Please try After sometime"/>
        </cfcatch>
        </cftry>
        <cfreturn local.getNameInfo/>
    </cffunction>

    <!---function to get the user info --->
    <cffunction  name="getTeacherInfo" output="false" access="remote" returntype="struct">
        <!---struct for function information--->
        <cfset local.funcInfo = {}/>
        <cftry>
            <cfif session.stLoggedInUser.role EQ 'Teacher'>
                <!---getting the number of batches--->
                <cfset local.funcInfo.batchCount = databaseServiceObj.getBatchCount(teacherId=session.stLoggedInUser.userId)/>
                <cfset local.funcInfo.studentCount = databaseServiceObj.getEnrolledStudent(teacherId = session.stLoggedInUser.userId)/>
                <cfset local.funcInfo.requestCount = databaseServiceObj.getMyRequests(teacherId=session.stLoggedInUser.userId)/>
            <cfelseif session.stLoggedInUser.role EQ 'Student'>
                <cfset local.funcInfo.batchCount = databaseServiceObj.getBatchCount(studentId = session.stLoggedInUser.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.funcInfo['error'] = 'Some error occurred.Please try after sometimes'>
        </cfcatch>
        </cftry>
        
        <cfreturn local.funcInfo>
    </cffunction>
    
    <!---function to get the address of user--->
    <cffunction  name="getMyAddress" output="false" access="remote" returntype="struct" returnformat="json">
        <cfset local.myAddress = {}/>
        <cftry>
            <cfif structKeyExists(session, "stLoggedInUser")>
                <cfset local.myAddress.address = databaseServiceObj.getMyAddress(session.stLoggedInUser.userId)/>
            </cfif>
        <cfcatch type="any">
            <cfset local.myAddress['error'] = "Some error occurred.Please try after sometime"/>
        </cfcatch>
        </cftry>

        <cfreturn local.myAddress>
    </cffunction>
</cfcomponent>