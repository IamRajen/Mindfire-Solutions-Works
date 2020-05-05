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
        <cfargument  name="addressId" type="numeric" required="false"/>
        <cfargument  name="addressLink" type="string" required="false" default=''/>

        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var insertedSuccessfully={}/>
        <!---declaring a variable for result of query execution--->
        <cfset var newBatch=''/>

        <cftry>
            <cfquery result="newBatch">
                INSERT INTO [dbo].[Batch]
                (batchOwnerId,batchType,batchName,batchDetails,startDate,endDate,capacity,enrolled,fee,addressId,addressLink)
                VALUES (
                    <cfqueryparam value=#arguments.batchOwnerId# cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.batchType#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.batchName#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.batchDetails#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.startDate#' cfsqltype='cf_sql_date'>,
                    <cfqueryparam value='#arguments.endDate#' cfsqltype='cf_sql_date'>,
                    <cfqueryparam value=#arguments.capacity# cfsqltype='cf_sql_smallint'>,
                    <cfqueryparam value=#arguments.enrolled# cfsqltype='cf_sql_smallint'>,
                    <cfqueryparam value=#arguments.fee# cfsqltype='cf_sql_money'>,
                    <cfqueryparam value=#arguments.addressId# cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value=#arguments.addressLink# cfsqltype='cf_sql_varchar'>
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
        <cfset var batchInfo={}/>
        <!---Declaring a variable for storing result data--->
        <cfset var batches = ''/>
        <cftry>
            <cfquery name="batches">
                SELECT * 
                FROM [dbo].[batch]
                WHERE batchOwnerId = <cfqueryparam value=#arguments.teacherId# cfsqltype='cf_sql_bigint'>
                ORDER BY batchId DESC
            </cfquery>
        <cfcatch type="any">
            <cflog text="collecting batch error: #cfcatch#">
            <cfset batchInfo.error = "Some error occurred. Please try after sometimes"/>
        </cfcatch>
        </cftry>

        <cfif NOT structKeyExists(batchInfo, "error")>
            <cfset batchInfo.batches = batches/>
        </cfif>
        <cfreturn batchInfo/>
    </cffunction>

    <!---function to collect batches of teacher--->
    <cffunction  name="collectStudentBatch" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="studentId" type="numeric" required="true">
        <!---declaring a structure for storing the query data and error if occured--->
        <cfset var batchInfo={}/>
        <!---Declaring a variable for storing result data--->
        <cfset var batches = ''/>
        <cftry>
            <cfquery name="batches">
                SELECT  * 
                FROM    [dbo].[BatchEnrolledStudent]
                JOIN    [dbo].[Batch] ON [dbo].[Batch].[batchId] = [dbo].[BatchEnrolledStudent].[batchId]
                WHERE   studentId = <cfqueryparam value=#arguments.studentId# cfsqltype='cf_sql_bigint'>
                ORDER BY [dbo].[BatchEnrolledStudent].[enrolledDateTime] DESC
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService collectStudentBatch(): #cfcatch#">
            <cfset batchInfo.error = "Some error occurred. Please try after sometimes"/>
        </cfcatch>
        </cftry>

        <cfif NOT structKeyExists(batchInfo, "error")>
            <cfset batchInfo.batches = batches/>
        </cfif>
        <cfreturn batchInfo/>
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

    <!---function to populate the notification status table--->
    <cffunction  name="insertNotificationStatus" access="public" output="false" returntype="struct">
        <!---argument--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <cfargument  name="batchEnrolledStudentId" type="numeric" required="true">
        <cfargument  name="notificationStatus" type="numeric" required="true">
        <!---structure that contains the information of the query--->
        <cfset var notificationStatusInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery>
                INSERT INTO [dbo].[BatchNotificationStatus]
                            (batchNotificationId, batchEnrolledStudentId, notificationStatus)
                VALUES      (
                            <cfqueryparam value="#arguments.batchNotificationId#" cfsqltype="cf_sql_bigint">,
                            <cfqueryparam value="#arguments.batchEnrolledStudentId#" cfsqltype="cf_sql_bigint">,
                            <cfqueryparam value="#arguments.notificationStatus#" cfsqltype="cf_sql_bit">
                            )
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: insertNotificationStatus()-> #cfcatch# #cfcatch.detail#"/>
            <cfset notificationStatusInfo.error = "Some error occurred.Please try after sometimes"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(notificationStatusInfo, "error")>
            <cfset notificationStatusInfo.insertedStatus = true/>
        </cfif>
        <cfreturn notificationStatusInfo>
    </cffunction>

    <!---function to insert the feedback--->
    <cffunction  name="insertFeedback" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="enrolledStudentId" type="numeric" required="true">
        <cfargument  name="feedback" type="string" required="false">
        <cfargument  name="rating" type="numeric" required="true">
        <!---structure to store the insert info--->
        <cfset var insertFeedbackInfo = {}/>
        <!---variable to store the returned value of query--->
        <cfset var insertedFeedback = ''/>
        <!---query--->
        <cftry>
            <cfquery>
                INSERT INTO     [dbo].[BatchFeedback]
                                (batchId, batchEnrolledStudentId, feedbackDateTime, feedback, rating)
                VALUES          (
                                <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>,
                                <cfqueryparam value="#arguments.enrolledStudentId#" cfsqltype='cf_sql_bigint'>,
                                <cfqueryparam value="#now()#" cfsqltype='cf_sql_timestamp'>,
                                <cfqueryparam value="#arguments.feedback#" cfsqltype='cf_sql_varchar'>,
                                <cfqueryparam value="#arguments.rating#" cfsqltype='cf_sql_tinyint'>
                )
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: insertFeedback()-> #cfcatch# #cfcatch.detail#">
            <cfset insertFeedbackInfo.error = "Some error occured.Please, try after sometime">
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(insertFeedbackInfo, "error")>
            <cfset insertFeedbackInfo.insertFeedback = true/>
        </cfif>
        <cfreturn insertFeedbackInfo/>
    </cffunction>

    <!---function to retrieve the batch feedback--->
    <cffunction  name="retrieveBatchFeedback" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---structure for retrieve batch feedback function information--->
        <cfset var retrieveBatchFeedbackInfo = {}/>
        <!---variable to store the query result--->
        <cfset var feedbacks = ''/>
        <cftry>
            <cfquery name="feedback">
                SELECT  [dbo].[BatchFeedback].[batchFeedbackId], [dbo].[BatchFeedback].[batchId], [dbo].[BatchFeedback].[feedbackDateTime], [dbo].[BatchFeedback].[feedback], [dbo].[BatchFeedback].[rating],
                        [dbo].[User].[userId], [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS 'Student'
                FROM    ([dbo].[BatchFeedback]
                JOIN    [dbo].[Batch] ON ([dbo].[Batch].[batchId] = [dbo].[BatchFeedback].[batchId])
                JOIN    [dbo].[BatchEnrolledStudent]  ON ([dbo].[BatchFeedback].[batchEnrolledStudentId] = [dbo].[BatchEnrolledStudent].[batchEnrolledStudentId])
                JOIN    [dbo].[User] ON ([dbo].[BatchEnrolledStudent].[studentId] = [dbo].[User].[userId]))

                WHERE   [dbo].[BatchFeedback].[batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>
                ORDER BY    [dbo].[BatchFeedback].[feedbackDateTime] DESC
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: retrieveBatchFeedback()-> #cfcatch# #cfcatch.detail#">
            <cfset retrieveBatchFeedbackInfo.error = "Some error occurred.Please, try after sometime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(retrieveBatchFeedbackInfo, "error")>
            <cfset retrieveBatchFeedbackInfo.feedback = feedback/>
        </cfif>
        <cfreturn retrieveBatchFeedbackInfo/>
    </cffunction>

    <!---function to retrieve all batches feedback of a particular teacher--->
    <cffunction  name="retrieveTeacherFeedback" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="teacherId" type="numeric" required="true">
        <!---struct to store retrieveTeacherFeedback information--->
        <cfset var retrieveTeacherFeedbackInfo = {}/>
        <!---variable to store the query data--->
        <cfset var feedbacks = ''/>
        <!---query--->
        <cftry>
            <cfquery name="feedbacks">
                SELECT  [dbo].[Batch].[batchId], [dbo].[Batch].[BatchName], 
                        [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS 'Student',
                        [dbo].[BatchFeedback].[feedback], [dbo].[BatchFeedback].[feedbackDateTime]
                FROM    [dbo].[BatchFeedback]
                JOIN    [dbo].[Batch] ON ([dbo].[BatchFeedback].[batchId] = [dbo].[Batch].[batchId])
                JOIN    [dbo].[BatchEnrolledStudent] ON ([dbo].[BatchFeedback].[batchEnrolledStudentId] = [dbo].[BatchEnrolledStudent].[batchEnrolledStudentId])
                JOIN    [dbo].[User] ON ([dbo].[User].[userId] = [dbo].[BatchEnrolledStudent].[studentId])
                WHERE   [dbo].[Batch].[batchOwnerId] = <cfqueryparam value="#arguments.teacherId#" cfsqltype='cf_sql_bigint'>
                ORDER BY    [dbo].[BatchFeedback].[feedbackDateTime] DESC
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: retrieveTeacherFeedback()-> #cfcatch# #cfcatch.detail#">
            <cfset retrieveTeacherFeedbackInfo.error = "some error occurred please try after sometime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(retrieveTeacherFeedbackInfo, "error")>
            <cfset retrieveTeacherFeedbackInfo.feedbacks = feedbacks/>
        </cfif>
        <cfreturn retrieveTeacherFeedbackInfo>
    </cffunction>
    <!---function to get all notification--->
    <cffunction  name="getMyNotification" access="public" output="false" returntype="struct">
        <!---argument--->
        <cfargument  name="studentId" type="numeric" required="false">
        <!---variable that will contain all the notification--->
        <cfset var notifications = ''/>
        <!---structure that will contain the information about the request--->
        <cfset var notificationInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery name="notifications">
                SELECT  [dbo].[BatchNotification].[batchNotificationId], [dbo].[BatchNotification].[dateTime], 
                        [dbo].[BatchNotification].[notificationTitle], [dbo].[Batch].[batchName], 
                        [dbo].[BatchNotificationStatus].[batchNotificationStatusId], [dbo].[BatchNotificationStatus].[notificationStatus]
                FROM    [dbo].[BatchEnrolledStudent]
                JOIN    [dbo].[Batch] ON ([dbo].[BatchEnrolledStudent].[batchId] = [dbo].[Batch].[batchId])
                JOIN    [dbo].[BatchNotification] ON ([dbo].[BatchNotification].[batchId]=[dbo].[Batch].[batchId])
                JOIN    [dbo].[BatchNotificationStatus] ON ([dbo].[BatchNotificationStatus].[batchNotificationId]=[dbo].[BatchNotification].[batchNotificationId])

                WHERE   [dbo].[BatchEnrolledStudent].[studentId] = <cfqueryparam value="#arguments.studentId#" cfsqltype='cf_sql_bigint'>
                ORDER BY [dbo].[BatchNotification].[dateTime] DESC
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getMyNotification()-> #cfcatch# #cfcatch.detail#">
            <cfset notificationInfo.error = "Some error occured.Please, try after sometime">
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(notificationInfo, "error")>
            <cfset notificationInfo.notifications = notifications/>
        </cfif> 
        <cfreturn notificationInfo>
    </cffunction>

    <!---function to mark notification status as read and give the notification detail--->
    <cffunction  name="markNotificationAsRead" output="false" access="public" returntype="struct">
        <!---argument--->
        <cfargument  name="notificationStatusId" type="numeric" required="true">
        <cfargument  name="notificationId" type="numeric" required="true">
        
        <!---variable to store the information--->
        <cfset var notificationInfo = {}/>
        <cfset var notification=''/>
        <!---transaction to mark notification as read---> 
        <cftransaction>
            <cftry>
                <!---setting the notification status as read--->
                <cfquery>
                    UPDATE  [dbo].[BatchNotificationStatus]
                    SET     notificationStatus = 1
                    WHERE   batchNotificationStatusId = <cfqueryparam value="#arguments.notificationStatusId#" cfsqltype="cf_sql_bigint">
                </cfquery>
                <cfset notification = getNotificationByID(arguments.notificationId)/>
                <cfif structKeyExists(notification, "error")>
                    <cfthrow detail = "#notification.error#">
                </cfif>
                <cftransaction action="commit" />
            <cfcatch type="any">
                <cflog  text="databaseService: markNotificationAsRead()-> #cfcatch# #cfcatch.detail#">
                <cftransaction action="rollback">
                <cfset notificationInfo.error = "Some error occurred.Please, try after sometime">
            </cfcatch>
            </cftry>
        </cftransaction>
        <cfif NOT structKeyExists(notificationInfo, "error")>
            <cfset notificationInfo = notification/>
        </cfif>
        <cfreturn notificationInfo/>
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

    <!---function to update the batch address id--->
    <cffunction  name="updateBatchAddressId" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressId" type="numeric" required="true">
        <!---calling funtion and initializing it into the returning variable--->
        <cfset var updateInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[Batch]
                SET [addressId] = <cfqueryparam value="#arguments.addressId#" cfsqltype="cf_sql_bigint">
                WHERE [batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype="cf_sql_bigint">
            </cfquery>
        <cfcatch type="any">
            <cflog  text="helo #cfactch.detail#">
            <cfset updateInfo.error = "some error occurred. Please, try after sometime."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(updateInfo, "error")>
            <cfset updateInfo.info = true/>
        </cfif>
        <cfreturn updateInfo/>
    </cffunction>

    <!---function to update the batch address Link--->
    <cffunction  name="updateBatchAddressLink" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressLink" type="string" required="true">
        <!---calling funtion and initializing it into the returning variable--->
        <cfset var updateInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[Batch]
                SET [addressLink] = <cfqueryparam value="#arguments.addressLink#" cfsqltype="cf_sql_varchar">
                WHERE [batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype="cf_sql_bigint">
            </cfquery>
        <cfcatch type="any">
            <cflog  text="helo #cfactch.detail#">
            <cfset updateInfo.error = "some error occurred. Please, try after sometime."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(updateInfo, "error")>
            <cfset updateInfo.info = true/>
        </cfif>
        <cfreturn updateInfo/>
    </cffunction>

    <!---function to get near by batches--->
    <cffunction  name="getNearByBatch" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="pincode" type="string" required="false">
        <cfargument  name="country" type="string" required="false">
        <cfargument  name="state" type="string" required="false">
        
        <!---creating a structure for storing the result and error msg if occurred--->
        <cfset var batches = {}/>
        <!---variable that will store the batch information--->
        <cfset var batch=''/>
        <!---query starts from here--->
        <cftry>
            <cfquery name="batch">
                SELECT DISTINCT [dbo].[Batch].[batchId], [batchName],[batchDetails], [address], [country], [state],
                                [city], [pincode], [startDate],[endDate], [batchType], [fee], [capacity], [enrolled]
                FROM ([dbo].[Batch] 
                JOIN [dbo].[UserAddress] ON ([dbo].[Batch].[addressId] = [dbo].[UserAddress].[userAddressId]))
                
                <cfif structKeyExists(arguments, "pincode")>
                    WHERE (batchType='online' OR [dbo].[UserAddress].[pincode] LIKE '#arguments.pincode#%')
                    <cflog  text="#arguments.pincode#">
                <cfelseif structKeyExists(arguments, "country") AND (NOT structKeyExists(arguments, "state"))>
                    WHERE ([dbo].[UserAddress].[country] = '#arguments.country#')
                <cfelseif structKeyExists(arguments, "state")>
                    WHERE [dbo].[UserAddress].[country] = '#arguments.country#' AND [dbo].[UserAddress].[state] = '#arguments.state#'
                </cfif>
                ORDER BY [dbo].[Batch].[startdate] DESC;
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService-> getNearByBatch(): #cfcatch.detail#">
            <cfset batches.error = "some error occurred. Please try after sometimes."/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(batches, "error")>
            <cfset batches.batch = batch/>
        </cfif>
        <cfreturn batches/>
    </cffunction>

    <!---function to insert a request into the batchRequest table--->
    <cffunction  name="insertRequest" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="studentId" type="numeric" required="true">
        <cfargument  name="status" type="string" required="true">
        <!---creating a variable for insert query--->
        <cfset var newRequest = ''/>
        <cfset var requestStatus = {}/>
        <!---query for inserting the request--->
        <cftry>
            <cfquery name="newRequest">
                INSERT INTO [dbo].[BatchRequest]
                (batchId, studentId, requestStatus, requestDateTime)
                VALUES( 
                        <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>,
                        <cfqueryparam value=#arguments.studentId# cfsqltype='cf_sql_bigint'>,
                        <cfqueryparam value='#arguments.status#' cfsqltype='cf_sql_varchar'>,
                        <cfqueryparam value=#now()# cfsqltype="cf_sql_timestamp">
                )   
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: insertRequest()-> #cfcatch.detail#">
            <cfset requestStatus.error = "failed to make a request. Please try after sometime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(requestStatus, "error")>
            <cfset requestStatus.status = "Request has been send."/>
        </cfif>
        <cfreturn requestStatus/>
    </cffunction>

    <!---function to get the requests of batch--->
    <cffunction  name="getBatchRequests" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---variable to store the request data--->
        <cfset var requests = ''/>
        <cfset var requestInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery name="requests">
                SELECT  [dbo].[BatchRequest].[batchRequestId] , [dbo].[BatchRequest].[requestDateTime] , 
                        [dbo].[BatchRequest].[requestStatus] , [dbo].[User].[userId], 
                        [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS "Student"
                
                FROM    [dbo].[BatchRequest]
                JOIN    [dbo].[User] ON [dbo].[BatchRequest].[studentId] = [dbo].[User].[userId]
                WHERE   [dbo].[BatchRequest].[batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype="cf_sql_bigint">
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseservice: getRequestStatus()-> #cfcatch# #cfcatch.detail#">
            <cfset requestInfo.error = "Some error occurred.Please try after sometime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(requestInfo, "error")>
            <cfset requestInfo.requests = requests/>
        </cfif>
        <cfreturn requestInfo/>
    </cffunction>

    <!---function to get the all requestes of user--->
    <cffunction  name="getMyRequests" access="public" output="false" returntype="struct">
        <!---argumnets--->
        <cfargument  name="studentId" type="numeric" required="false">
        <cfargument  name="teacherId" type="numeric" required="false">
        <cfargument  name="batchId" type="numeric" required="false">
        <!---variable that will contain the request query--->
        <cfset var requests=''/>
        <!---structure that will contain the request Information--->
        <cfset var requestInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery name="requests">
                SELECT      [dbo].[BatchRequest].[batchRequestId] , [dbo].[BatchRequest].[requestDateTime] , 
                            [dbo].[BatchRequest].[requestStatus] , [dbo].[Batch].[batchName] , [dbo].[Batch].[batchId] 
                    <cfif structKeyExists(arguments, "teacherId")>
                            ,[dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS "Student", [dbo].[User].[userId]
                    </cfif>
                FROM        ([dbo].[BatchRequest]
                JOIN        [dbo].[Batch] ON ([dbo].[Batch].[batchId]=[dbo].[BatchRequest].[batchId])
                JOIN        [dbo].[User] ON ([dbo].[User].[userId]=[dbo].[BatchRequest].[studentId]))
                    <cfif structKeyExists(arguments, "teacherId")>
                WHERE       [dbo].[Batch].[batchOwnerId]=<cfqueryparam value="#arguments.teacherId#" cfsqltype="cf_sql_bigint">
                    <cfelseif structKeyExists(arguments, "batchId")>
                WHERE       studentId=<cfqueryparam value="#arguments.studentId#" cfsqltype="cf_sql_bigint"> AND 
                            [dbo].[BatchRequest].[batchId]=<cfqueryparam value="#arguments.batchId#" cfsqltype="cf_sql_bigint">
                    <cfelseif structKeyExists(arguments, "studentId")>
                WHERE       studentId=<cfqueryparam value="#arguments.studentId#" cfsqltype="cf_sql_bigint">
                </cfif>
                ORDER BY requestDateTime DESC 
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService getMyRequest(): #cfcatch# #cfcatch.detail#">
            <cfset requestInfo.error = "some error occurred. Please try after somtime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(requestInfo, "error")>
            <cfset requestInfo.requests = requests/>
        </cfif>
        <cfreturn requestInfo/>
    </cffunction> 

    <!---function to update the requests--->
    <cffunction  name="updateBatchRequest" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <cfargument  name="requestStatus" type="string" required="true">
        <!---struct that contains the update info--->
        <cfset var updateInfo = {}/>
        <cfset var isCommit = false/>
        <!---query--->
        <cftransaction>
            <cftry>
                <cfquery>
                    UPDATE  [dbo].[BatchRequest]
                    SET     [dbo].[BatchRequest].[requestStatus] = <cfqueryparam value="#arguments.requestStatus#" cfsqltype="cf_sql_varchar">
                    WHERE   [dbo].[BatchRequest].[batchRequestId] = <cfqueryparam value="#arguments.batchRequestId#" cfsqltype='cf_sql_bigint'>
                </cfquery>
                <cfif arguments.requestStatus EQ 'Approved'>
                    <cfset var requestDetails = getRequestDetails(arguments.batchRequestId)/>
                    <cflog  text="#requestDetails.requestDetails.batchId#">
                    <cfquery>
                        INSERT INTO     [dbo].[BatchEnrolledStudent]
                                        (enrolledDateTime, batchId, studentId)
                        VALUES         ( <cfqueryparam value='#now()#' cfsqltype='cf_sql_timestamp'>,
                                        <cfqueryparam value=#requestDetails.requestDetails.batchId# cfsqltype='cf_sql_bigint'>,
                                        <cfqueryparam value=#requestDetails.requestDetails.studentId# cfsqltype='cf_sql_bigint'>
                                    )
                    </cfquery>
                </cfif>
                
                <cftransaction action="commit" />
                <cfset isCommit=true />
            <cfcatch type="any">
                <cftransaction action="rollback" />
                <cflog  text="databaseService updateRequest(): #cfcatch# #cfcatch.detail#">
                <cfset updateInfo.error = "some error occured while updating the request. Please try after sometimes"/>
            </cfcatch>
            </cftry>
        </cftransaction>
        <cfif NOT structKeyExists(updateInfo, "error")>
            <cfset updateInfo.update = true/>
        </cfif>
        <cfreturn updateInfo>
    </cffunction>

    <!---get the request details by it's request id--->
    <cffunction  name="getRequestDetails" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <!---variable to store the query output--->
        <cfset var requestDetails = ''/>
        <!---structure that contains the requestDetails information--->
        <cfset var requestDetailInfo = {}/>
        <!---query--->
        <cftry>
            <cfquery name="requestDetails">
                SELECT  [dbo].[Batch].[batchOwnerId], [dbo].[BatchRequest].[batchId], [dbo].[BatchRequest].[studentId]
                FROM    [dbo].[BatchRequest]
                JOIN    [dbo].[Batch] ON [dbo].[BatchRequest].[batchId]=[dbo].[Batch].[batchId]
                WHERE   [dbo].[BatchRequest].[batchRequestId]=<cfqueryparam value="#arguments.batchRequestId#" cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService getRequestDetails(): #cfcatch# #cfcatch.detail#">
            <cfset requestDetailInfo = "Some error occurred.Please try after sometime">
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(requestDetailInfo, "error")>
            <cfset requestDetailInfo.requestDetails = requestDetails/>
        </cfif>
        <cfreturn requestDetailInfo>
    </cffunction>

    <!---function to get the enrolled student list--->
    <cffunction  name="getEnrolledStudent" access="public" output="false" returntype="struct">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="false">
        <cfargument  name="teacherId" type="numeric" required="false">
        <!---variable to get the student list--->
        <cfset var enrolledStudents=''/>
        <!---structure to get the information of the of the query--->
        <cfset var enrolledStudentInfo ={}/>
        <!---query--->
        <cftry>
            <cfquery name="enrolledStudents">
                SELECT  [dbo].[BatchEnrolledStudent].[batchEnrolledStudentId], [dbo].[BatchEnrolledStudent].[enrolledDateTime] , 
                        [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS "Student", [dbo].[BatchEnrolledStudent].[studentId]
                    <cfif structKeyExists(arguments, "teacherId")>
                        ,[dbo].[Batch].[batchId], [dbo].[Batch].[batchName]
                    </cfif>
                FROM    ([dbo].[BatchEnrolledStudent] 
                JOIN    [dbo].[Batch] ON ([dbo].[BatchEnrolledStudent].[batchId] = [dbo].[Batch].[batchId])
                JOIN    [dbo].[User] ON ([dbo].[BatchEnrolledStudent].[studentId] = [dbo].[User].[userId]))

                WHERE    
                    <cfif structKeyExists(arguments, "batchId")>
                        [dbo].[BatchEnrolledStudent].[batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>
                    <cfelseif structKeyExists(arguments, "teacherId")>
                        [dbo].[Batch].[batchOwnerId] = <cfqueryparam value="#arguments.teacherId#" cfsqltype='cf_sql_bigint'>
                    </cfif>   
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService getEnrolledStudent(): #cfcatch# #cfcatch.detail#">
            <cfset enrolledStudentInfo.error = "Some error occurred.Please try after sometime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(enrolledStudentInfo, "error")>
            <cfset enrolledStudentInfo.enrolledStudents = enrolledStudents/>
        </cfif>
        <cfreturn enrolledStudentInfo>
    </cffunction>

    <!---function to get the teachers--->
    <cffunction  name="getTeacher" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="isTeacher" type="boolean" required="false">
        <cfargument  name="userId" type="numeric" required="false">
        <!---structure will contain the getTeachers info--->
        <cfset var getUserInfo = {}/>
        <!---variable to store the query data--->
        <cfset var teachers = ''/>
        <!---query--->
        <cftry>
            <cfquery name="teachers">
                SELECT  [dbo].[User].[userId], [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS 'User',
                        [dbo].[User].[emailId], [dbo].[User].[dob], [dbo].[User].[yearOfExperience], [dbo].[User].[homeLocation],
                        [dbo].[User].[Online], [dbo].[User].[otherLocation], [dbo].[User].[bio], [dbo].[User].[isTeacher]

                FROM    [dbo].[User]
                WHERE   
                    <cfif structKeyExists(arguments, "isTeacher")>
                        [dbo].[User].[isTeacher]=<cfqueryparam value="#arguments.isTeacher#" cfsqltype='cf_sql_bit'>
                    <cfelseif structKeyExists(arguments, "userId")>
                          AND [dbo].[User].[userId] = <cfqueryparam value="#arguments.userId#" cfsqltype='cf_sql_bigint'>
                    </cfif>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getTeacher()-> #cfcatch# #cfcatch.detail#">
            <cfset getUserInfo.error = "some error ocuured. Please, try after sometime"/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(getTeacherInfo, "error")>
            <cfset getUserInfo.teachers = teachers/>
        </cfif>
        <cfreturn getUserInfo/>
    </cffunction>
</cfcomponent>
