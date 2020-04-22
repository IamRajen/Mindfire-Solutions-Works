<!---
Project Name: FindOnlineTutor.
File Name: databaseService.cfc.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file has services/functions related to the data in the database.
--->

<cfcomponent output="false">

    <!---get user details--->
    <cffunction  name="getMyProfile" access="public" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var userDetails=''/>
        <cfset var userPhoneNumber={}/>
        <cfset var profileInfo = {}/>
        <cftry>
            <cfquery name="userDetails">
                SELECT firstName, lastName, emailId, username, password, dob, yearOfExperience, homeLocation, otherLocation, online, bio
                FROM [dbo].[User]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>

            <cfset userPhoneNumber = getMyPhoneNumber(#arguments.userId#)/>
            <cfif structKeyExists(userPhoneNumber, "error")>
                <cfthrow detail='#userPhoneNumber.error#'/>
            </cfif>

        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch#">
            <cfset profileInfo.error="Some Error occurred while fetching the profile data. Please, try after sometimes!!"/>
        </cfcatch>

        </cftry>
        <cfif NOT structKeyExists(profileInfo, "error")>
            <cfset profileInfo.userDetails=#userDetails#/>
            <cfset profileInfo.userPhoneNumber=#userPhoneNumber#/>
        </cfif>
        <cfreturn profileInfo/>

    </cffunction>

    <!---get user addresses--->
    <cffunction  name="getMyAddress" access="remote" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var userAddress={}/>
        <cfset var address = ''>
        <cftry>
            <cfquery name="address">
                SELECT userAddressId,address,country,state,city,pincode
                FROM [dbo].[UserAddress]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch#">
            <cfset userAddress.error="Some Error occurred while fetching the data. Please, try after sometimes!!"/>
        </cfcatch>
        </cftry>
        <cfset userAddress.address = address>
        <cfreturn userAddress/>
    </cffunction>

    <!---get user phone number--->
    <cffunction  name="getMyPhoneNumber" access="remote" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var userPhoneNumber={}/>
        <cfset var phoneNumber = ''>
        <cftry>
            <cfquery name="phoneNumber">
                SELECT userPhoneNumberId, phoneNumber 
                FROM [dbo].[UserPhoneNumber]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch#">
            <cfset userPhoneNumber.error="Some Error occurred while fetching the phone numbers. Please, try after sometimes!!"/>
        </cfcatch>
        </cftry>
        <cfset userPhoneNumber.phoneNumber = phoneNumber/>
        <cfreturn userPhoneNumber/>
    </cffunction>

    <!---function to get the userId with respect to the username--->
    <cffunction name="getUserId" access="remote" output="false" returntype="struct" returnformat='json'>
        <cfargument  name="username" type="string" required="true">
        <cfset var userId = {} />
        <cftry>
            <cfquery name="id">
                SELECT userId
                FROM [dbo].[User]
                WHERE username=<cfqueryparam value="#arguments.username#" cfsqltype='cf_sql_varchar'>
            </cfquery>
        <cfcatch type="any">
            <cflog text="#arguments.username# : #cfcatch#">
            <cfset userId.error="failed to retrieve user id. Please, try after sometime!!"/>
        </cfcatch>
        </cftry>
        <cfset userId.id=id.userId/>
        <cfreturn userId />
    </cffunction>

    <!---update user information--->
    <cffunction  name="updateUser" access="public" output="false" returntype="struct" >
        <!---defining arguments--->
        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="bio" type="string" required="false"/>
        <!---creating a structure for returning purpose. which contains the update error msg if occurred--->
        <cfset var updatedSuccessfully={}/>
        <!---update query starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[User]
                SET firstName = <cfqueryparam value='#arguments.firstName#' cfsqltype='cf_sql_varchar'>,
                    lastName = <cfqueryparam value='#arguments.lastName#' cfsqltype='cf_sql_varchar'>,
                    emailId = <cfqueryparam value='#arguments.emailAddress#' cfsqltype='cf_sql_varchar'>,
                    dob = <cfqueryparam value='#arguments.dob#' cfsqltype='cf_sql_date'>, 
                    bio = <cfqueryparam value='#arguments.bio#' cfsqltype='cf_sql_varchar'>
                WHERE userId=#session.stloggedinuser.userID#
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch#"/>
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>


    <!---update user address information--->
    <cffunction  name="updateAddress" access="public" output="false" returntype="struct">
        <!---defining arguments--->
        <cfargument  name="userAddressId" type="any" required="true">
        <cfargument  name="address" type="string" required="true">
        <cfargument  name="country" type="string" required="true">
        <cfargument  name="state" type="string" required="true">
        <cfargument  name="city" type="string" required="true">
        <cfargument  name="pincode" type="string" required="true">
        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var updatedSuccessfully={}/>
        <!---updation starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[UserAddress]
                SET address = <cfqueryparam value='#arguments.address#' cfsqltype='cf_sql_varchar'>,
                    country = <cfqueryparam value='#arguments.country#' cfsqltype='cf_sql_varchar'>,
                    state = <cfqueryparam value='#arguments.state#' cfsqltype='cf_sql_varchar'>,
                    city = <cfqueryparam value='#arguments.city#' cfsqltype='cf_sql_varchar'>,
                    pincode = <cfqueryparam value='#arguments.pincode#' cfsqltype='cf_sql_varchar'>
                WHERE userAddressId = <cfqueryparam value=#arguments.userAddressId# cfsqltype='cf_sql_bigint'>;
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch#"/>
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>


    <!---update user phone information--->
    <cffunction  name="updatephoneNumber" access="remote" output="false" returntype="struct">
        <!---defining arguments--->
        <cfargument  name="userPhoneNumberId" type="any" required="true">
        <cfargument  name="phoneNumber" type="string"  required="true">
        <!---creating a structure for returning purpose. which contains the update error msg if occurred--->
        <cfset var updatedSuccessfully={}/>
        <!---updating process starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[UserPhoneNumber]
                SET phoneNumber = <cfqueryparam value='#arguments.phoneNumber#' cfsqltype='cf_sql_varchar'>
                WHERE userPhoneNumberId = <cfqueryparam value=#arguments.userPhoneNumberId# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch#"/>
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---update user phone information--->
    <cffunction  name="updateInterest" access="remote" output="false" returntype="struct">
        <!---defining arguments--->
        <cfargument  name="otherLocation" type="string" required="true"/>
        <cfargument  name="homeLocation" type="string" required="true"/>
        <cfargument  name="online" type="string" required="true"/>
        <!---creating a structure for returning purpose. which contains the update error msg if occurred--->
        <cfset var updatedSuccessfully={}/>
        <!---updating process starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[User]
                SET otherLocation = <cfqueryparam value='#arguments.otherLocation#' cfsqltype='cf_sql_bit'>,
                    homeLocation = <cfqueryparam value='#arguments.homeLocation#' cfsqltype='cf_sql_bit'>,
                    online = <cfqueryparam value='#arguments.online#' cfsqltype='cf_sql_bit'>
                WHERE userId = <cfqueryparam value=#session.stLoggedinUser.UserID# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch#"/>
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>


    <!---insert user information--->
    <cffunction  name="insertUser" access="public" output="false" returntype="boolean">

        <!---defining arguments--->
        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="primaryPhoneNumber" type="string" required="true"/>
        <cfargument  name="alternativePhoneNumber" type="string" required="false"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="username" type="string" required="true"/>
        <cfargument  name="password" type="string" required="true"/>
        <cfargument  name="isTeacher" type="string" required="true"/>
        <cfargument  name="experience" type="string" required="false"/>
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
        <cfargument  name="bio" type="string" required="false"/>

        <cfset var role = "Student"/>
        <cfif arguments.isTeacher>
            <cfset role = "Teacher"/>
        </cfif>

        <cfset var isCommit=false/>
        <cftransaction>
            <cftry>
                <cfset var queryUserCredential=''/>
                <!---inserting the user credentials in user table--->
                <cfquery result="queryUserCredential">
                    <!---Inserting data in the user table--->
                    INSERT INTO [dbo].[User] 
                    (registrationDate,firstName,lastName,emailid,username,password,dob,isTeacher,
                        yearOfExperience,homeLocation,otherLocation,online,bio,role)
                    VALUES (
                        <cfqueryparam value='#now()#' cfsqltype='cf_sql_date'>,
                        <cfqueryparam value='#arguments.firstName#' cfsqltype='cf_sql_varchar'>, 
                        <cfqueryparam value='#arguments.lastName#' cfsqltype='cf_sql_varchar'>, 
                        <cfqueryparam value='#arguments.emailAddress#' cfsqltype='cf_sql_varchar'>, 
                        <cfqueryparam value='#arguments.username#' cfsqltype='cf_sql_varchar'>, 
                        <cfqueryparam value='#hash(arguments.password, "SHA-1", "UTF-8")#' cfsqltype='cf_sql_varchar'>, 
                        <cfqueryparam value='#arguments.dob#' cfsqltype='cf_sql_date'>,
                        <cfqueryparam value=#arguments.isTeacher# cfsqltype='cf_sql_bit'>,
                        <cfqueryparam value=#arguments.experience# cfsqltype='cf_sql_smallint'>,
                        <cfqueryparam value=0 cfsqltype='cf_sql_bit'>,
                        <cfqueryparam value=0 cfsqltype='cf_sql_bit'>,
                        <cfqueryparam value=0 cfsqltype='cf_sql_bit'>,
                        <cfqueryparam value='#arguments.bio#' cfsqltype='cf_sql_varchar'>,
                        <cfqueryparam value='#role#' cfsqltype='cf_sql_varchar'>
                        );
                </cfquery>
                <!---initializing the primary key generated while inserting the user--->
                <cfset var userId = #queryUserCredential.GENERATEDKEY#/> 
                <!---primary phone number is inserted by calling insertPhoneNumber--->
                <cfset var insertPhone = insertPhoneNumber(userId,arguments.primaryPhoneNumber)/>
                <cfif structKeyExists(insertPhone, "error")>
                    <cfthrow detail = '#insertPhone.error#'/> 
                </cfif>
                <!---if alternative phone number exists then this bolck of code will get executed--->
                <cfif arguments.alternativePhoneNumber NEQ ''>
                    <cfset var insertAlternativePhone = insertPhoneNumber(userId,arguments.alternativePhoneNumber)/>
                    <cfif structKeyExists(insertAlternativePhone, "error")>
                        <cfthrow detail = '#insertAlternativePhone.error#'/> 
                    </cfif>
                </cfif>
                <!---current address is inserted by calling insertaddress()--->
                <cfset var insertCurrentAddress = insertAddress(
                    userId,arguments.currentAddress, arguments.currentCountry, arguments.currentState,
                    arguments.currentCity, arguments.currentPincode)/>
                <cfif structKeyExists(insertCurrentAddress, "error")>
                    <cfthrow detail = '#insertCurrentAddress.error#'/>
                </cfif>
                <!---if alternative address exists then this bolck of code will get executed--->
                <cfif arguments.havingAlternativeAddress>
                    <cfset var insertAlternativeAddress = insertAddress(
                        userId,arguments.alternativeAddress, arguments.alternativeCountry, arguments.alternativeState,
                        arguments.alternativeCity, arguments.alternativePincode)/>
                    <cfif structKeyExists(insertAlternativeAddress, "error")>
                        <cfthrow detail = '#insertAlternativeAddress.error#'/>
                    </cfif>
                </cfif>
                <!---if every query get successfully executed then commit actoin get called--->
                <cftransaction action="commit" />
                <cfset isCommit=true />
            <cfcatch type="any">
                <!---if some error occured while transaction then the whole transaction will be rollback--->
                <cftransaction action="rollback" />
                <cflog text="#cfcatch#">
            </cfcatch>
            </cftry>
        </cftransaction>
        <!---returning the commit message--->
        <cfreturn isCommit/>  
    </cffunction>


    <!---insert user phone number--->
    <cffunction  name="insertPhoneNumber" access="public" returntype="struct" output="false">
        <!---defining arguments--->
        <cfargument  name="userId" type="any" required="true"/>
        <cfargument  name="phoneNumber" type="string" required="true"/>
        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var insertedSuccessfully={}/>
        <!---declaring a variable for result of query execution--->
        <cfset var phoneId=''/>

        <cftry>
            <cfquery result="phoneId">
                INSERT INTO [dbo].[UserPhoneNumber]
                (userId,phoneNumber)
                VALUES (
                    <cfqueryparam value=#arguments.userId# cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.phoneNumber#' cfsqltype='cf_sql_varchar'>
                )
            </cfquery>
        <cfcatch type="any">
            <!---if an error occurred while inserting then it will be store in the error key of returning structure for
            further execution--->
            <cfset insertedSuccessfully.error='#cfcatch#'/>
        </cfcatch>
        </cftry>

        <cfset insertedSuccessfully.phoneId=phoneId/>
        <cfreturn insertedSuccessfully/>
    </cffunction>


    <!---insert user address--->
    <cffunction  name="insertAddress" access="public" returntype="struct" output="false">
        <!---defining arguments--->
        <cfargument  name="userId" type="any" required="true">
        <cfargument  name="address" type="string" required="true">
        <cfargument  name="country" type="string" required="true">
        <cfargument  name="state" type="string" required="true">
        <cfargument  name="city" type="string" required="true">
        <cfargument  name="pincode" type="string" required="true">
        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var insertedSuccessfully={}/>
        <!---declaring a variable for result of query execution--->
        <cfset var addressId=''/>

        <cftry>
            <cfquery result="addressId">
                INSERT INTO [dbo].[UserAddress]
                (userId,address,country,state,city,pincode)
                VALUES (
                    <cfqueryparam value=#arguments.userId# cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.address#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.country#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.state#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.city#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.pincode#' cfsqltype='cf_sql_varchar'>
                )
            </cfquery>
        <cfcatch type="any">
            <!---if an error occurred while inserting then it will be store in the error key of returning structure for
            further execution--->
            <cfset insertedSuccessfully.error='#cfcatch#'/>
        </cfcatch>
        </cftry>

        <cfset insertedSuccessfully.addressId=addressId/>
        <cfreturn insertedSuccessfully/>
    </cffunction>

    <!---function to check if an email address is present or not--->
    <cffunction  name="isEmailPresent" access="public" output="false" returntype="struct">
        <!---defining argument--->
        <cfargument  name="emailId" type="string" required="true"/>
        <cfset var queryEmail=''/>
        <cfset isEmailAddressPresent={}/>
        <cftry>
            <cfquery name=queryEmail>
                SELECT userId,emailId
                FROM [dbo].[User]
                WHERE emailId=<cfqueryparam value="#arguments.emailId#" cfsqltype="cf_sql_varchar">;
            </cfquery>
        <cfcatch type="any">
            <cfset isEmailAddressPresent.error=#cfcatch#/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(isEmailAddressPresent, "error")>
            <cfif queryEmail.recordCount GTE 1>
                <cfset isEmailAddressPresent.isPresent=true/>
                <cfset isEmailAddressPresent.info=queryEmail/>
            <cfelse>
                <cfset isEmailAddressPresent.isPresent=false/>
            </cfif>
        </cfif>
        
        <cfreturn isEmailAddressPresent/>
    </cffunction>

    <!---function to check if an email address is present or not--->
    <cffunction  name="isPhonePresent" access="public" output="false" returntype="struct">
        <!---defining argument--->
        <cfargument name="phoneNumber" type="string" required="true"/>
        <cfset var queryPhone=''/>
        <cfset isPhoneNumberPresent={}/>
        <cftry>
            <cfquery name=queryPhone>
                SELECT userId,phoneNumber
                FROM [dbo].[UserPhoneNumber]
                WHERE phoneNumber=<cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">;
            </cfquery>
        <cfcatch type="any">
            <cfset isPhoneNumberPresent.error=#cfcatch#/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(isPhoneNumberPresent, "error")>
            <cfif queryPhone.recordCount GTE 1>
                <cfset isPhoneNumberPresent.isPresent=true/>
                <cfset isPhoneNumberpresent.info=queryPhone/>
            <cfelse>
                <cfset isPhoneNumberPresent.isPresent=false/>
            </cfif>
        </cfif>
        
        <cfreturn isPhoneNumberPresent/>
    </cffunction>

    <!---function to check if an email address is present or not--->
    <cffunction  name="isUserPresent" access="public" output="false" returntype="struct">
        <!---defining argument--->
        <cfargument name="username" type="string" required="true"/>
        <cfset var queryUser=''/>
        <cfset isUsernamePresent={}/>
        <cftry>
            <cfquery name=queryUser>
                SELECT username
                FROM [dbo].[User]
                WHERE username=<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">;
            </cfquery>
        <cfcatch type="any">
            <cfset isUsernamePresent.error=#cfcatch#/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(isUsernamePresent, "error")>
            <cfif queryUser.recordCount GTE 1>
                <cfset isUsernamePresent.isPresent=true/>
            <cfelse>
                <cfset isUsernamePresent.isPresent=false/>
            </cfif>
        </cfif>
        
        <cfreturn isUsernamePresent/>
    </cffunction>

<!---batch functions starts from here--->
    <!---function to insert new batch--->
    <cffunction  name="insertBatch" access="public" output="false" returnformat="json" returntype="struct">
        <cfargument  name="batchOwnerId" type="numeric" required="true"/>
        <cfargument  name="batchName" type="string" required="true"/>
        <cfargument  name="batchType" type="string" required="true"/>
        <cfargument  name="batchDetails" type="string" required="true"/>
        <cfargument  name="startDate" type="string" required="true"/>
        <cfargument  name="endDate" type="string" required="true"/>
        <cfargument  name="capacity" type="numeric" required="true"/>
        <cfargument  name="fee" type="numeric" required="true"/>
        <cfargument  name="enrolled" type="numeric" required="false" default=0/>

        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var insertedSuccessfully={}/>
        <!---declaring a variable for result of query execution--->
        <cfset var newBatch=''/>

        <cftry>
            <cfquery result="newBatch">
                INSERT INTO [dbo].[Batch]
                (batchOwnerId,batchType,batchName,batchDetails,startDate,endDate,capacity,enrolled,fee)
                VALUES (
                    <cfqueryparam value=#arguments.batchOwnerId# cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.batchType#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.batchName#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.batchDetails#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.startDate#' cfsqltype='cf_sql_date'>,
                    <cfqueryparam value='#arguments.endDate#' cfsqltype='cf_sql_date'>,
                    <cfqueryparam value=#arguments.capacity# cfsqltype='cf_sql_smallint'>,
                    <cfqueryparam value=#arguments.enrolled# cfsqltype='cf_sql_smallint'>,
                    <cfqueryparam value=#arguments.fee# cfsqltype='cf_sql_money'>
                )
            </cfquery>
        <cfcatch type="any">
            <!---if an error occurred while inserting then it will be store in the error key of returning structure for
            further execution--->
            <cfset insertedSuccessfully.error='#cfcatch#'/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(insertedSuccessfully, "error")>
            <cfset insertedSuccessfully.newBatchId=newBatch.GENERATEDKEY/>
        </cfif>
        <cfreturn insertedSuccessfully/>
    </cffunction>

    <!---function to collect batches of teacher--->
    <cffunction  name="collectTeacherBatch" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="teacherId" type="numeric" required="true">
        <!---declaring a structure for storing the query data and error if occured--->
        <cfset var batches={}/>
        <!---Declaring a variable for storing result data--->
        <cfset var teacherBatches = ''/>
        <cftry>
            <cfquery name="teacherBatches">
                SELECT * 
                FROM [dbo].[batch]
                WHERE batchOwnerId = <cfqueryparam value=#arguments.teacherId# cfsqltype='cf_sql_bigint'>
                ORDER BY batchId DESC
            </cfquery>
        <cfcatch type="any">
            <cflog text="collecting batch error: #cfcatch#">
            <cfset batches.error = true/>
        </cfcatch>
        </cftry>

        <cfif NOT structKeyExists(batches, "error")>
            <cfset batches.data = teacherBatches/>
        </cfif>
        <cfreturn batches/>
    </cffunction>

    <!---function to insert batch timing--->
    <cffunction  name="insertBatchTime" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="startTime" type="string" required="true">
        <cfargument  name="endTime" type="string" required="true">
        <cfargument  name="day" type="numeric" required="true">
        <!---variable for query result--->
        <cfset var batchTime=''/>
        <!---declaring structure for returning the query generated key and error msg if occured--->
        <cfset var newBatchTime={}/>
        <!---insertion starts here--->
        <cftry>
            <cfquery result="batchTime">
                INSERT INTO [dbo].[BatchTiming]
                (batchId, startTime, endTime, day)
                VALUES( <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>,
                        <cfqueryparam value='#arguments.startTime#' cfsqltype='cf_sql_time'>,
                        <cfqueryparam value='#arguments.endTime#' cfsqltype='cf_sql_time'>,
                        <cfqueryparam value='#arguments.day#' cfsqltype='cf_sql_smallint'> 
                )     
            </cfquery>
        <cfcatch type="any">
            <cflog text="insert batch time: #cfcatch.detail#"/>
            <cfset newBatchTime.error=cfcatch.detail/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(newBatchTime, "error")>
            <cfset newBatchTime.batchTime=batchTime/>
        </cfif>
        
        <cfreturn newBatchTime/>
    </cffunction>

    <cffunction  name="insertBatchNotification" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="notificationTitle" type="string" required="true">
        <cfargument  name="notificationDetails" type="string" required="true">
        <!---variable for query result--->
        <cfset var batchNotification=''/>
        <!---declaring structure for returning the query generated key and error msg if occured--->
        <cfset var newBatchNotification={}/>
        <!---insertion starts here--->
        <cftry>
            <cfquery result="batchNotification">
                INSERT INTO [dbo].[BatchNotification]
                (batchId, dateTime, notificationTitle, notificationDetails)
                VALUES( <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>,
                        <cfqueryparam value=#now()# cfsqltype="cf_sql_timestamp">,
                        <cfqueryparam value='#arguments.notificationTitle#' cfsqltype='cf_sql_varchar'>,
                        <cfqueryparam value='#arguments.notificationDetails#' cfsqltype='cf_sql_varchar'>
                )     
            </cfquery>
        <cfcatch type="any">
            <cflog text="insert notification: #cfcatch#"/>
            <cfset newBatchNotification.error=cfcatch.detail/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(newBatchNotification, "error")>
            <cfset newBatchNotification.notification=batchNotification/>
        </cfif>
        
        <cfreturn newBatchNotification/>
    </cffunction>

    <!---function to insert new batch--->
    <cffunction  name="updateBatch" access="public" output="false" returnformat="json" returntype="struct">
        <cfargument  name="batchId" type="numeric" required="true"/>
        <cfargument  name="batchName" type="string" required="true"/>
        <cfargument  name="batchType" type="string" required="true"/>
        <cfargument  name="batchDetails" type="string" required="true"/>
        <cfargument  name="startDate" type="string" required="true"/>
        <cfargument  name="endDate" type="string" required="true"/>
        <cfargument  name="capacity" type="numeric" required="true"/>
        <cfargument  name="fee" type="numeric" required="true"/>

        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var updatedSuccessfully={}/>
        <!---updation starts here--->
        <cfset var updateBatch=''/>

        <cftry>
            <cfquery result="updateBatch">
                UPDATE [dbo].[Batch]
                SET batchName = <cfqueryparam value='#arguments.batchName#' cfsqltype='cf_sql_varchar'>,
                    batchType = <cfqueryparam value='#arguments.batchType#' cfsqltype='cf_sql_varchar'>,
                    batchDetails = <cfqueryparam value='#arguments.batchDetails#' cfsqltype='cf_sql_varchar'>,
                    startDate = <cfqueryparam value='#arguments.startDate#' cfsqltype='cf_sql_date'>,
                    endDate = <cfqueryparam value='#arguments.endDate#' cfsqltype='cf_sql_date'>,
                    capacity = <cfqueryparam value='#arguments.capacity#' cfsqltype='cf_sql_smallint'>,
                    fee = <cfqueryparam value='#arguments.fee#' cfsqltype='cf_sql_smallint'>
                WHERE batchId = <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>;
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch#"/>
            <cflog  text="#cfcatch#">
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---function to insert batch timing--->
    <cffunction  name="updateBatchTime" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchTimingId" type="numeric" required="true">
        <cfargument  name="startTime" type="string" required="true">
        <cfargument  name="endTime" type="string" required="true">
        <!---variable for query result--->
        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var updatedSuccessfully={}/>
        <!---updation starts here--->
        <cfset var updateBatchTime=''/>
        <cftry>
            <cfquery result="updateBatchTime">
                UPDATE [dbo].[BatchTiming]
                SET startTime = <cfqueryparam value='#arguments.startTime#' cfsqltype='cf_sql_varchar'>,
                    endTime = <cfqueryparam value='#arguments.endTime#' cfsqltype='cf_sql_varchar'>
                WHERE batchTimingId = <cfqueryparam value=#arguments.batchTimingId# cfsqltype='cf_sql_bigint'>;
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch#"/>
            <cflog  text="updated :#cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---function to delete notification--->
    <cffunction  name="deleteNotification" output="false" access="public" returntype="struct">
        <!---argument--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---return struture--->
        <cfset var deleteNotificationInfo = {}/>
        <cftry>
            <cfquery>
                DELETE [dbo].[BatchNotification]
                WHERE batchNotificationId = <cfqueryparam value=#arguments.batchNotificationId# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: deleteNotificationInfo-> #cfcatch.detail#">
            <cfset deleteNotificationInfo.error = "Some error occurred while deleting the notification"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(deleteNotificationInfo, "error")>
            <cfset deleteNotificationInfo.success=true/>
        </cfif>
        <cfreturn deleteNotificationInfo/>
    </cffunction>

    <!---function to get the batch info by it's ID--->
    <cffunction  name="getBatchByID" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var batch=''/>
        <!---declaring a structure for storing the value to be returned--->
        <cfset var batchInfo={}/>
        <!---retrieving starts here--->
        <cftry>
            <cfquery name="batch">
                SELECT * 
                FROM [dbo].[Batch]
                WHERE batchId = <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService : getBatchByID()-> #cfcatch.detail#"/>
            <cfset batchInfo.error="Problem Occured while retrieving the batch information. Please, try after sometime."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(batchInfo, "error")>
            <cfset batchInfo.batch = batch/>
        </cfif>

        <cfreturn batchInfo/>
    </cffunction>

    <!---function to get the batch timing info by it's batch ID--->
    <cffunction  name="getBatchTime" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var batchTime=''/>
        <!---declaring a structure for storing the value to be returned--->
        <cfset var batchTimeInfo={}/>
        <!---retrieving starts here--->
        <cftry>
            <cfquery name="batchTime">
                SELECT * 
                FROM [dbo].[BatchTiming]
                WHERE batchId = <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>
                ORDER BY day ASC
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService : getBatchTime()-> #cfcatch.detail#"/>
            <cfset batchTimeInfo.error="Problem Occured while retrieving the batch time information. Try to refresh the page or try after sometime."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(batchTimeInfo, "error")>
            <cfset batchTimeInfo.time = batchTime/>
        </cfif>

        <cfreturn batchTimeInfo/>
    </cffunction>

    <!---function to get the batch notification info by it's batch ID--->
    <cffunction  name="getBatchNotifications" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var batchNotifications=''/>
        <!---declaring a structure for storing the value to be returned--->
        <cfset var batchNotificationInfo={}/>
        <!---retrieving starts here--->
        <cftry>
            <cfquery name="batchNotifications">
                SELECT * 
                FROM [dbo].[BatchNotification]
                WHERE batchId = <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>
                ORDER BY dateTime DESC
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService : getBatchNotifications()-> #cfcatch.detail#"/>
            <cfset batchNotificationInfo.error="Problem Occured while retrieving the batch notifications. Try to refresh the page or try after sometime."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(batchNotificationInfo, "error")>
            <cfset batchNotificationInfo.notifications = batchNotifications/>
        </cfif>

        <cfreturn batchNotificationInfo/>
    </cffunction>

    <!---function to get the batch notification by it's ID--->
    <cffunction  name="getNotificationByID" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var notification=''/>
        <!---declaring a structure for storing the value to be returned--->
        <cfset var notificationInfo={}/>
        <!---retrieving starts here--->
        <cftry>
            <cfquery name="notification">
                SELECT * 
                FROM [dbo].[BatchNotification]
                WHERE batchNotificationId = <cfqueryparam value=#arguments.batchNotificationId# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService : getNotificationByID()-> #cfcatch.detail#"/>
            <cfset notificationInfo.error="Problem Occured while retrieving the notification. Please, try after sometime."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(notificationInfo, "error")>
            <cfset notificationInfo.notification = notification/>
        </cfif>

        <cfreturn notificationInfo/>
    </cffunction>



</cfcomponent>