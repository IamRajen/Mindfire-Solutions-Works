<!---
Project Name: FindOnlineTutor.
File Name: databaseService.cfc.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file has services/functions related to the data in the database.
--->

<cfcomponent output="false">

    <!---get user details--->
    <cffunction  name="getMyProfile" access="public" output="false" returntype="query">
        <!---argument--->
        <cfargument  name="userId" type="any" required="true"/>
        <cfset  var profileDetails=''/>
        <cftry>
            <cfquery name="profileDetails">
                SELECT  firstName, lastName, emailId, username, password, dob, yearOfExperience, homeLocation, otherLocation, online, bio, phoneNumber
                FROM    [dbo].[User]
                JOIN    [dbo].[UserPhoneNumber] ON ([dbo].[User].[userId] = [dbo].[UserPhoneNumber].[userId])
                WHERE   [dbo].[User].[userId] = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>

        <cfreturn profileDetails/>
    </cffunction>


    <!---get user addresses--->
    <cffunction  name="getMyAddress" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="userId" type="numeric" required="false">
        <cfargument  name="addressId" type="numeric" required="false">
    
        <cfset var address = ''>
        <cftry>
            <cfquery name="address">
                SELECT  userAddressId,address,country,state,city,pincode
                FROM    [dbo].[UserAddress]
                WHERE
                        <cfif structKeyExists(arguments, "userId")>
                            userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
                        <cfelseif structKeyExists(arguments, "addressId")>
                            userAddressId = <cfqueryparam value="#arguments.addressId#" cfsqltype="cf_sql_bigint" />
                        </cfif>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>

        <cfreturn address/>
    </cffunction>

    <!---get user phone number--->
    <cffunction  name="getMyPhoneNumber" access="public" output="false" returntype="query">
        <!---argument--->
        <cfargument  name="userId" type="any" required="true"/>
        <cfset var phoneNumber = ''>
        <cftry>
            <cfquery name="phoneNumber">
                SELECT userPhoneNumberId, phoneNumber 
                FROM [dbo].[UserPhoneNumber]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn phoneNumber/>
    </cffunction>

    <!---update user information--->
    <cffunction  name="updateUser" access="public" output="false" returntype="boolean" >
        <!---arguments--->
        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="bio" type="string" required="false"/>

        <cfset var updatedSuccessfully = false/>
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
            <cfset var updatedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updateUser()->#cfcatch# #cfcatch.detail#">/>
        </cfcatch>
        </cftry>

        <cfreturn updatedSuccessfully/>
    </cffunction>


    <!---update user address information--->
    <cffunction  name="updateAddress" access="public" output="false" returntype="boolean">
        <!---defining arguments--->
        <cfargument  name="userAddressId" type="any" required="true">
        <cfargument  name="address" type="string" required="true">
        <cfargument  name="country" type="string" required="true">
        <cfargument  name="state" type="string" required="true">
        <cfargument  name="city" type="string" required="true">
        <cfargument  name="pincode" type="string" required="true">
        <!---creating a boolean variable for returning purpose--->
        <cfset var updatedSuccessfully=false/>
        <!---updation starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[UserAddress]
                SET address = <cfqueryparam value='#arguments.address#' cfsqltype='cf_sql_varchar'>,
                    country = <cfqueryparam value='#arguments.country#' cfsqltype='cf_sql_varchar'>,
                    state = <cfqueryparam value='#arguments.state#' cfsqltype='cf_sql_varchar'>,
                    city = <cfqueryparam value='#arguments.city#' cfsqltype='cf_sql_varchar'>,
                    pincode = <cfqueryparam value='#arguments.pincode#' cfsqltype='cf_sql_varchar'>
                WHERE userAddressId = <cfqueryparam value=#arguments.userAddressId# cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset updatedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updateAddress()-> #cfcatch# #cfcatch.detail#"/>
        </cfcatch>
        </cftry>

        <cfreturn updatedSuccessfully/>
    </cffunction>


    <!---update user phone information--->
    <cffunction  name="updatephoneNumber" access="public" output="false" returntype="boolean">
        <!---arguments--->
        <cfargument  name="userPhoneNumberId" type="any" required="true">
        <cfargument  name="phoneNumber" type="string"  required="true">
        <!---creating a structure for returning purpose. which contains the update error msg if occurred--->
        <cfset var updatedSuccessfully=false/>
        <!---updating process starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[UserPhoneNumber]
                SET phoneNumber = <cfqueryparam value='#arguments.phoneNumber#' cfsqltype='cf_sql_varchar'>
                WHERE userPhoneNumberId = <cfqueryparam value=#arguments.userPhoneNumberId# cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset updatedSuccessfully=true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updatePhoneNumber(): #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>

        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---update user phone information--->
    <cffunction  name="updateInterest" access="public" output="false" returntype="boolean">
        <!---defining arguments--->
        <cfargument  name="otherLocation" type="string" required="true"/>
        <cfargument  name="homeLocation" type="string" required="true"/>
        <cfargument  name="online" type="string" required="true"/>
        <!---creating a structure for returning purpose. which contains the update error msg if occurred--->
        <cfset var updatedSuccessfully=false/>
        <!---updating process starts here--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[User]
                SET otherLocation = <cfqueryparam value='#arguments.otherLocation#' cfsqltype='cf_sql_bit'>,
                    homeLocation = <cfqueryparam value='#arguments.homeLocation#' cfsqltype='cf_sql_bit'>,
                    online = <cfqueryparam value='#arguments.online#' cfsqltype='cf_sql_bit'>
                WHERE userId = <cfqueryparam value=#session.stLoggedinUser.UserID# cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset updatedSuccessfully=true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updateInterest()-> #cfcatch# #cfcatch.detail#"/>
        </cfcatch>
        </cftry>

        <cfreturn updatedSuccessfully/>
    </cffunction>


    <!---insert user information--->
    <cffunction  name="insertUser" access="public" output="false" returntype="struct">

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
        <cfset var queryUserCredential=''/>
        <cftransaction>
            <cftry>
                
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
                <cfset var idOfInsertedUser = queryUserCredential.GENERATEDKEY/> 

                <!---primary phone number is inserted by calling insertPhoneNumber--->
                <cfset var insertPhone = insertPhoneNumber(idOfInsertedUser,arguments.primaryPhoneNumber)/>
                <!---if alternative phone number exists then this bolck of code will get executed--->
                <cfif arguments.alternativePhoneNumber NEQ ''>
                    <cfset var insertAlternativePhone = insertPhoneNumber(idOfInsertedUser,arguments.alternativePhoneNumber)/>
                </cfif>

                <!---current address is inserted by calling insertaddress()--->
                <cfset var insertCurrentAddress = insertAddress(
                    idOfInsertedUser,arguments.currentAddress, arguments.currentCountry, arguments.currentState,
                    arguments.currentCity, arguments.currentPincode)/>
                <!---if alternative address exists then this bolck of code will get executed--->
                <cfif arguments.havingAlternativeAddress>
                    <cfset var insertAlternativeAddress = insertAddress(
                        idOfInsertedUser,arguments.alternativeAddress, arguments.alternativeCountry, arguments.alternativeState,
                        arguments.alternativeCity, arguments.alternativePincode)/>
                </cfif>
                <!---if every query get successfully executed then commit actoin get called--->
                <cftransaction action="commit" />
            <cfcatch type="any">
                <!---if some error occured while transaction then the whole transaction will be rollback--->
                <cftransaction action="rollback" />
                <cflog text="databaseService: insertUser()-> #cfcatch# #cfcatch.detail#">
                <cfset queryUserCredential=''/>
            </cfcatch>
            </cftry>
        </cftransaction>
        <!---returning the commit message--->
        <cfreturn queryUserCredential> 
    </cffunction>

    <!---insert user phone number--->
    <cffunction  name="insertPhoneNumber" access="public" returntype="struct" output="false">
        <!---defining arguments--->
        <cfargument  name="userId" type="any" required="true"/>
        <cfargument  name="phoneNumber" type="string" required="true"/>
        <!---creating a structure for returning purpose. which contains the inserted result and error msg if occurred--->
        <cfset var insertedSuccessfully=''/>

        <cftry>
            <cfquery result="insertedSuccessfully">
                INSERT INTO [dbo].[UserPhoneNumber]
                (userId,phoneNumber)
                VALUES (
                    <cfqueryparam value=#arguments.userId# cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.phoneNumber#' cfsqltype='cf_sql_varchar'>
                )
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: insertPhoneNumber()-> #cfcatch# #cfcatch.detail#">/>
        </cfcatch>
        </cftry>
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
        <cfset var insertedSuccessfully=''/>

        <cftry>
            <cfquery result="insertedSuccessfully">
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
            <cflog text="databaseService: insertAddress()-> #cfcatch# #cfcatch.detail#"/>
        </cfcatch>
        </cftry>
        <cfreturn insertedSuccessfully/>
    </cffunction>

    <!---function to check if an email address is present or not--->
    <cffunction  name="isUserPresent" access="public" output="false" returntype="boolean">
        <!---defining argument--->
        <cfargument name="username" type="string" required="true"/>
        <cfset isUsernamePresent=''/>
        <cftry>
            <cfquery name=queryUser>
                SELECT username
                FROM [dbo].[User]
                WHERE username=<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">;
            </cfquery>
            <cfif queryUser.recordCount GTE 1>
                <cfset isUsernamePresent=true/>
            <cfelse>
                <cfset isUsernamePresent=false/>
            </cfif>
        <cfcatch type="any">
            <cflog  text="databaseService: isUserPresent()-> #cfcathc# #cfcatch.detail#">/>
        </cfcatch>
        </cftry>
        
        <cfreturn isUsernamePresent/>
    </cffunction>

<!---batch functions starts from here--->
    <!---function to insert new batch--->
    <cffunction  name="insertBatch" access="public" output="false" returntype="struct">
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
        
        <cflog  text="#arguments.addressLink#">

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
            <cflog  text="databaseService: insertBatch()-> #cfcatch# #cfcatch.detail#">/>
        </cfcatch>
        </cftry>

        <cfreturn newBatch/>
    </cffunction>

    <!---function to collect batches of teacher--->
    <cffunction  name="getUserBatch" output="false" access="public" returntype="query">
        <!---arguments--->
        <cfargument  name="teacherId" type="numeric" required="false">
        <cfargument  name="studentId" type="numeric" required="false">
        
        <!---Declaring a variable for storing result data--->
        <cfset var batches = ''/>
        <cftry>
            <cfquery name="batches">
                SELECT  * 
                FROM 
                    <cfif structKeyExists(arguments, "teacherId")>
                        [dbo].[batch]
                    <cfelseif structKeyExists(arguments, "studentId")>
                        [dbo].[BatchEnrolledStudent]
                JOIN    [dbo].[Batch] ON [dbo].[Batch].[batchId] = [dbo].[BatchEnrolledStudent].[batchId]
                    </cfif>
                JOIN    [dbo].[UserAddress] ON ([dbo].[UserAddress].[userAddressId] = [dbo].[Batch].[addressId])
                WHERE 
                    <cfif structKeyExists(arguments, "teacherId")>
                        [dbo].[Batch].[batchOwnerId] = <cfqueryparam value=#arguments.teacherId# cfsqltype='cf_sql_bigint'>
                    <cfelseif structKeyExists(arguments, "studentId")>
                        <cfif structKeyExists(session, "stLoggedInUser") AND session.stLoggedInUser.role EQ 'Teacher'>
                            <cflog  text="error">
                            [dbo].[Batch].[batchOwnerId] = <cfqueryparam value="#session.stLoggedInUser.userId#" cfsqltype='cf_sql_bigint'> AND
                        </cfif>
                        studentId = <cfqueryparam value=#arguments.studentId# cfsqltype='cf_sql_bigint'>
                    </cfif>
                ORDER BY 
                    <cfif structKeyExists(arguments, "teacherId")>
                        batchId DESC
                    <cfelseif structKeyExists(arguments, "studentId")>
                        [dbo].[BatchEnrolledStudent].[enrolledDateTime] DESC
                    </cfif> 
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService: getUserBatch()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
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
            <cflog text="databaseService: insertBatchTiming()-> #cfcatch# #cfcatch.detail#"/>
        </cfcatch>
        </cftry>
        <cfreturn batchTime/>
    </cffunction>

    <cffunction  name="insertBatchNotification" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="notificationTitle" type="string" required="true">
        <cfargument  name="notificationDetails" type="string" required="true">
        <!---variable for query result--->
        <cfset var batchNotification=''/>
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
            <cfset newBatchNotification.notification=batchNotification/>
        <cfcatch type="any">
            <cflog text="databaseService: insertBatchNotification()-> #cfcatch# #cfcatch#"/>
        </cfcatch>
        </cftry>
        
        <cfreturn batchNotification/>
    </cffunction>

    <!---function to populate the notification status table--->
    <cffunction  name="insertNotificationStatus" access="public" output="false" returntype="struct">
        <!---argument--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <cfargument  name="batchEnrolledStudentId" type="numeric" required="true">
        <cfargument  name="notificationStatus" type="numeric" required="true">
        <!---variable for new notificationStatus--->
        <cfset var newNotificationStatus = ''/>
        <!---query--->
        <cftry>
            <cfquery result="newNotificationStatus">
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
        </cfcatch>
        </cftry>
        <cfreturn newNotificationStatus>
    </cffunction>

    <!---function to insert the feedback--->
    <cffunction  name="insertFeedback" access="public" output="false" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="enrolledStudentId" type="numeric" required="true">
        <cfargument  name="feedback" type="string" required="false">
        <cfargument  name="rating" type="numeric" required="true">
        
        <!---variable to store the returned value of query--->
        <cfset var insertedFeedback = ''/>
        <!---query--->
        <cftry>
            <cfquery result="insertedFeedback">
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
        </cfcatch>
        </cftry>
        <cfreturn insertedFeedback/>
    </cffunction>

    <!---function to retrieve the batch feedback--->
    <cffunction  name="retrieveBatchFeedback" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---variable to store the query result--->
        <cfset var feedback = ''/>
        <cftry>
            <cfquery name="feedback">
                SELECT  [dbo].[BatchFeedback].[batchFeedbackId], [dbo].[BatchFeedback].[batchId], [dbo].[BatchFeedback].[feedbackDateTime],
                        [dbo].[BatchFeedback].[feedback], [dbo].[BatchFeedback].[rating],
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
        </cfcatch>
        </cftry>
        <cfreturn feedback/>
    </cffunction>

    <!---function to get all notification--->
    <cffunction  name="getMyNotification" access="public" output="false" returntype="query">
        <!---argument--->
        <cfargument  name="studentId" type="numeric" required="false">
        <!---variable that will contain all the notification--->
        <cfset var notifications = ''/>
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
        </cfcatch>
        </cftry>
        <cfreturn notifications>
    </cffunction>

    <!---function to mark notification status as read and give the notification detail--->
    <cffunction  name="markNotificationAsRead" output="false" access="public" returntype="query">
        <!---argument--->
        <cfargument  name="notificationStatusId" type="numeric" required="true">
        <cfargument  name="notificationId" type="numeric" required="true">
        
        <!---variable to store the notification detail--->
        <cfset var notification = ''>
        <!---transaction to mark notification as read and provide the notification details at single time---> 
        <cftransaction>
            <cftry>
                <!---setting the notification status as read--->
                <cfquery>
                    UPDATE  [dbo].[BatchNotificationStatus]
                    SET     notificationStatus = 1
                    WHERE   batchNotificationStatusId = <cfqueryparam value="#arguments.notificationStatusId#" cfsqltype="cf_sql_bigint">
                </cfquery>
                <cfset notification = getNotificationByID(arguments.notificationId)/>
                <cftransaction action="commit" />
            <cfcatch type="any">
                <cflog  text="databaseService: markNotificationAsRead()-> #cfcatch# #cfcatch.detail#">
                <cftransaction action="rollback">
            </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn notification/>
    </cffunction>

    <!---function to insert new batch--->
    <cffunction  name="updateBatch" access="public" output="false" returntype="boolean">
        <cfargument  name="batchId" type="numeric" required="true"/>
        <cfargument  name="batchName" type="string" required="true"/>
        <cfargument  name="batchType" type="string" required="true"/>
        <cfargument  name="batchDetails" type="string" required="true"/>
        <cfargument  name="startDate" type="string" required="true"/>
        <cfargument  name="endDate" type="string" required="true"/>
        <cfargument  name="capacity" type="numeric" required="true"/>
        <cfargument  name="fee" type="numeric" required="true"/>

        <!---updation starts here--->
        <cfset var updatedSuccessfully=false/>

        <cftry>
            <cfquery>
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
            <cfset updatedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updateBatch()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---function to insert batch timing--->
    <cffunction  name="updateBatchTime" output="false" access="public" returntype="boolean">
        <!---arguments--->
        <cfargument  name="batchTimingId" type="numeric" required="true">
        <cfargument  name="startTime" type="string" required="true">
        <cfargument  name="endTime" type="string" required="true">
        <!---updation starts here--->
        <cfset var updatedSuccessfully=false/>
        <cftry>
            <cfquery>
                UPDATE [dbo].[BatchTiming]
                SET startTime = <cfqueryparam value='#arguments.startTime#' cfsqltype='cf_sql_varchar'>,
                    endTime = <cfqueryparam value='#arguments.endTime#' cfsqltype='cf_sql_varchar'>
                WHERE batchTimingId = <cfqueryparam value=#arguments.batchTimingId# cfsqltype='cf_sql_bigint'>;
            </cfquery>
            <cfset updatedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updateBatchTime()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---function to delete notification--->
    <cffunction  name="deleteNotification" output="false" access="public" returntype="boolean">
        <!---argument--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <cfset var deletedSuccessfully = false/>
        <cftry>
            <cfquery>
                DELETE [dbo].[BatchNotification]
                WHERE batchNotificationId = <cfqueryparam value=#arguments.batchNotificationId# cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset deletedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: deleteNotificationInfo-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn deletedSuccessfully/>
    </cffunction>

    <!---function to delete batch Tag--->
    <cffunction  name="deleteBatchTag" access="public" output="false" returntype="boolean">
        <!---arguments--->
        <cfargument  name="batchTagId" type="numeric" required="true">
        <cfset var deletedSuccessfully = false/>
        <!---query--->
        <cftry>
            <cfquery>
                DELETE FROM     [dbo].[BatchTag]
                WHERE           batchTagId = <cfqueryparam value="#arguments.batchTagId#" cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset deletedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: deleteBatchTag()-> #cfcatch#  #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn deletedSuccessfully>
    </cffunction>

    <!---function to get the batch details--->
    <cffunction  name="getBatchDetails" access="public" output="false" returntype="query">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---variable to store query result--->
        <cfset var batchDetails = ''/>
        <cftry>
            <cfquery name="batchDetails">
                SELECT  *
                FROM    [dbo].[Batch]
                JOIN    [dbo].[BatchTiming] ON ([dbo].[Batch].[batchId] = [dbo].[BatchTiming].[batchId])
               <!--- JOIN    [dbo].[BatchTag] ON ([dbo].[Batch].[batchId] = [dbo].[BatchTag].[batchId])
                JOIN    [dbo].[BatchNotification] ON ([dbo].[Batch].[batchId] = [dbo].[BatchNotification].[batchId])
                JOIN    [dbo].[BatchFeedback] ON ([dbo].[Batch].[batchId] = [dbo].[BatchFeedback].[batchId]) 
                JOIN    [dbo].[BatchRequest] ON ([dbo].[Batch].[batchId] = [dbo].[BatchRequest].[batchId])--->
                WHERE   [dbo].[Batch].[batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>
            </cfquery> 
        <cfcatch type="any">
            <cflog  text="databaseService: getBatchDetails()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn batchDetails>
    </cffunction>

    <!---function to get the batch info by it's ID--->
    <cffunction  name="getBatchByID" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var batch=''/>
        <!---retrieving starts here--->
        <cftry>
            <cfquery name="batch">
                SELECT * 
                FROM [dbo].[Batch]
                WHERE batchId = <cfqueryparam value=#arguments.batchId# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService : getBatchByID()-> #cfcatch# #cfcatch.detail#"/>
        </cfcatch>
        </cftry>

        <cfreturn batch/>
    </cffunction>

    <!---function to get the batch timing info by it's batch ID--->
    <cffunction  name="getBatchTime" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var batchTime=''/>
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
        </cfcatch>
        </cftry>

        <cfreturn batchTime/>
    </cffunction>

    <!---function to get the batch notification info by it's batch ID--->
    <cffunction  name="getBatchNotifications" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var batchNotifications=''/>
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
        </cfcatch>
        </cftry>

        <cfreturn batchNotifications/>
    </cffunction>

    <!---function to get the batch notification by it's ID--->
    <cffunction  name="getNotificationByID" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchNotificationId" type="numeric" required="true">
        <!---declaring a variable for storing the retrived data--->
        <cfset var notification=''/>
        <!---retrieving starts here--->
        <cftry>
            <cfquery name="notification">
                SELECT * 
                FROM [dbo].[BatchNotification]
                WHERE batchNotificationId = <cfqueryparam value=#arguments.batchNotificationId# cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService : getNotificationByID()-> #cfcatch.detail#"/>
        </cfcatch>
        </cftry>

        <cfreturn notification/>
    </cffunction>

    <!---function to update the batch address id--->
    <cffunction  name="updateBatchAddressId" access="public" output="false" returntype="boolean">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressId" type="numeric" required="true">
        <cfset var updatedSuccessfully = false/>
        <!---query--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[Batch]
                SET [addressId] = <cfqueryparam value="#arguments.addressId#" cfsqltype="cf_sql_bigint">
                WHERE [batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype="cf_sql_bigint">
            </cfquery>
            <cfset updatedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updatedBatchAddressId()-> #cfcatch# #cfactch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---function to update the batch address Link--->
    <cffunction  name="updateBatchAddressLink" access="public" output="false" returntype="boolean">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="addressLink" type="string" required="true">
        <cfset var updatedSuccessfully = false/>
        <!---query--->
        <cftry>
            <cfquery>
                UPDATE [dbo].[Batch]
                SET [addressLink] = <cfqueryparam value="#arguments.addressLink#" cfsqltype="cf_sql_varchar">
                WHERE [batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype="cf_sql_bigint">
            </cfquery>
            <cfset updatedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: updateBatchAddressLink()-> #cfactch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <!---function to get near by batches--->
    <cffunction  name="getNearByBatch" output="false" access="public" returntype="query">
        <!---arguments--->
        <cfargument  name="pincode" type="string" required="false">
        <cfargument  name="country" type="string" required="false">
        <cfargument  name="state" type="string" required="false">
        
        <!---variable that will store the batch information--->
        <cfset var batch=''/>
        <!---query starts from here--->
        <cftry>
            <cfquery name="batch">
                SELECT DISTINCT [dbo].[Batch].[batchId], [batchName],[batchDetails],[batchOwnerId] ,[address], [country], [state],
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
        </cfcatch>
        </cftry>
        <cfreturn batch/>
    </cffunction>

    <!---function to insert a request into the batchRequest table--->
    <cffunction  name="insertRequest" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="studentId" type="numeric" required="true">
        <cfargument  name="status" type="string" required="true">
        <!---creating a variable for insert query--->
        <cfset var newRequest = ''/>
        <!---query for inserting the request--->
        <cftry>
            <cfquery result="newRequest">
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
        </cfcatch>
        </cftry>
        <cfreturn newRequest/>
    </cffunction>

    <!---function to get the requests of batch--->
    <cffunction  name="getBatchRequests" output="false" access="public" returntype="query">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <!---variable to store the request data--->
        <cfset var requests = ''/>
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
        </cfcatch>
        </cftry>

        <cfreturn requests/>
    </cffunction>

    <!---function to get the all requestes of user--->
    <cffunction  name="getMyRequests" access="public" output="false" returntype="query">
        <!---argumnets--->
        <cfargument  name="studentId" type="numeric" required="false">
        <cfargument  name="teacherId" type="numeric" required="false">
        <cfargument  name="batchId" type="numeric" required="false">
        <!---variable that will contain the request query--->
        <cfset var requests=''/>
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
        </cfcatch>
        </cftry>

        <cfreturn requests/>
    </cffunction> 

    <!---function to update the requests--->
    <cffunction  name="updateBatchRequest" access="public" output="false" returntype="boolean">
        <!---arguments--->
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <cfargument  name="requestStatus" type="string" required="true">
        <!---struct that contains the update info--->
        <cfset var updatedSuccessfully = false/>
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
                    <cfquery >
                        INSERT INTO     [dbo].[BatchEnrolledStudent]
                                        (enrolledDateTime, batchId, studentId)
                        VALUES         ( <cfqueryparam value='#now()#' cfsqltype='cf_sql_timestamp'>,
                                        <cfqueryparam value=#requestDetails.batchId# cfsqltype='cf_sql_bigint'>,
                                        <cfqueryparam value=#requestDetails.studentId# cfsqltype='cf_sql_bigint'>
                                    )
                    </cfquery>
                </cfif>
                
                <cftransaction action="commit" />
                <cfset updatedSuccessfully = true/>
            <cfcatch type="any">
                <cftransaction action="rollback" />
                <cflog  text="databaseService updateRequest(): #cfcatch# #cfcatch.detail#">
            </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn updatedSuccessfully/>
    </cffunction>

    <cffunction  name="deleteBatchRequest" access="public" output="false" returntype="boolean">
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <cfset var deletedSuccessfully = false>
        <cftry>
            <cfquery>
                DELETE FROM [dbo].[BatchRequest]
                WHERE       batchRequestId = <cfqueryparam value="#arguments.batchRequestId#" cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfset deletedSuccessfully = true/>
        <cfcatch type="any">
            <cflog  text="databaseService: deleteBatchRequest()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn deletedSuccessfully/>
    </cffunction>

    <!---get the request details by it's request id--->
    <cffunction  name="getRequestDetails" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchRequestId" type="numeric" required="true">
        <!---variable to store the query output--->
        <cfset var requestDetails = ''/>
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
        </cfcatch>
        </cftry>
        <cfreturn requestDetails>
    </cffunction>

    <!---function to get the enrolled student list--->
    <cffunction  name="getEnrolledStudent" access="public" output="false" returntype="query">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="false">
        <cfargument  name="teacherId" type="numeric" required="false">
        <!---variable to get the student list--->
        <cfset var enrolledStudents=''/>
        <!---query--->
        <cftry>
            <cfquery name="enrolledStudents">
                SELECT  
                    <cfif structKeyExists(arguments, "batchId")>
                            [dbo].[BatchEnrolledStudent].[batchEnrolledStudentId], [dbo].[User].[userId],
                            [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS 'student', [dbo].[BatchEnrolledStudent].[enrolledDateTime]
                    <cfelseif structKeyExists(arguments, "teacherId")>
                        count([dbo].[BatchEnrolledStudent].[batchEnrolledStudentId]) AS 'numberOfBatches' , [dbo].[BatchEnrolledStudent].[studentId]
                    </cfif>
                FROM        ([dbo].[BatchEnrolledStudent] 
                JOIN        [dbo].[Batch] ON ([dbo].[BatchEnrolledStudent].[batchId] = [dbo].[Batch].[batchId])
                JOIN        [dbo].[User] ON ([dbo].[BatchEnrolledStudent].[studentId] = [dbo].[User].[userId]))

                WHERE    
                    <cfif structKeyExists(arguments, "batchId")>
                            [dbo].[BatchEnrolledStudent].[batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>
                ORDER BY    [dbo].[BatchEnrolledStudent].[enrolledDateTime]
                    <cfelseif structKeyExists(arguments, "teacherId")>
                            [dbo].[Batch].[batchOwnerId] = <cfqueryparam value="#arguments.teacherId#" cfsqltype='cf_sql_bigint'>
                GROUP BY    [dbo].[BatchEnrolledStudent].[studentId]
                ORDER BY    COUNT([dbo].[BatchEnrolledStudent].[studentId]) DESC
                    </cfif>
                
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService getEnrolledStudent(): #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        
        <cfreturn enrolledStudents>
    </cffunction>

    <!---function to see the that is student is enrolled to a particular batch--->
    <cffunction  name="isStudentEnrolled" access="public" output="false" returntype="boolean">
        <!---argument--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="studentId" type="numeric" required="true">
        
        <cfset var studentPresent = ''/>
        <!---query--->
        <cftry>
            <cfquery name="enrolledStudent">
                SELECT  *
                FROM    [dbo].[BatchEnrolledStudent]
                WHERE   [dbo].[BatchEnrolledStudent].[batchId] = <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'> 
                AND     [dbo].[BatchEnrolledStudent].[studentId] = <cfqueryparam value="#arguments.studentId#" cfsqltype='cf_sql_bigint'>
            </cfquery>
            <cfif enrolledStudent.recordCount EQ 1>
                <cfset studentPresent = true/>
            <cfelse>
                <cfset studentPresent = false/>
            </cfif>
        <cfcatch type="any">
            <cflog  text="databaseService: isStudentEnrolled()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        
        <cfreturn studentPresent>
    </cffunction>

    <!---function to get the teachers--->
    <cffunction  name="getUser" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="isTeacher" type="boolean" required="false">
        <cfargument  name="userId" type="numeric" required="false">
        <cfargument  name="emailAddress" type="string" required="false">
        <cfargument  name="phoneNumber" type="string" required="false">
        
        <!---variable to store the query data--->
        <cfset var user = ''/>
        <!---query--->
        <cftry>
            <cfquery name="user">
                SELECT  DISTINCT [dbo].[User].[userId], [dbo].[User].[firstName]+' '+[dbo].[User].[lastName] AS 'User',
                        [dbo].[User].[emailId], [dbo].[User].[dob], [dbo].[User].[yearOfExperience], [dbo].[User].[homeLocation],
                        [dbo].[User].[Online], [dbo].[User].[otherLocation], [dbo].[User].[bio], [dbo].[User].[isTeacher]

                FROM    [dbo].[User]
                JOIN    [dbo].[UserAddress] ON ([dbo].[User].[userId] = [dbo].[UserAddress].[userId])
                JOIN    [dbo].[UserPhoneNumber] ON ([dbo].[User].[userId] = [dbo].[UserPhoneNumber].[userId])
                WHERE   
                    <cfif structKeyExists(arguments, "isTeacher")>
                        [dbo].[User].[isTeacher]=<cfqueryparam value="#arguments.isTeacher#" cfsqltype='cf_sql_bit'>
                    <cfelseif structKeyExists(arguments, "userId")>
                        [dbo].[User].[userId] = <cfqueryparam value="#arguments.userId#" cfsqltype='cf_sql_bigint'>
                    <cfelseif structKeyExists(arguments, "emailAddress")>
                        [dbo].[User].[emailId] = <cfqueryparam value="#arguments.emailAddress#" cfsqltype='cf_sql_varchar'>
                    <cfelseif structKeyExists(arguments, "phoneNumber")>
                        [dbo].[UserPhoneNumber].[phoneNumber] = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype='cf_sql_varchar'>
                    </cfif>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getTeacher()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn user/>
    </cffunction>

    <!---function to get searched result--->
    <cffunction  name="getSearchResult" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="word" type="string" required="true">
        
        <!---variable to store the query result--->
        <cfset batch = ''/>
        <cftry>
            <cfquery name="batch">
                    SELECT DISTINCT [dbo].[Batch].[batchId],[batchName],[batchDetails], [batchOwnerId] ,[address], [country], [state],
                            [city], [pincode], [startDate],[endDate], [batchType], [fee], [capacity], [enrolled], [dbo].[BatchTag].[tagName]
                    FROM    [dbo].[Batch]
                    JOIN    [dbo].[BatchTag] ON ([dbo].[Batch].[batchId] = [dbo].[BatchTag].[batchId])
                    JOIN    [dbo].[UserAddress] ON ([dbo].[UserAddress].[userAddressId] = [dbo].[Batch].[addressId])
                    WHERE   tagName LIKE '%#arguments.word#%' 
                    OR      [dbo].[Batch].[batchName] LIKE '%#arguments.word#%'
                    OR      [dbo].[Batch].[batchDetails] LIKE '%#arguments.word#%'

            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getSearchedResult()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>

        <cfreturn batch>
    </cffunction>

    <!---function to insert tag--->
    <cffunction  name="insertBatchTag" output="false" access="public" returntype="struct">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        <cfargument  name="tag" type="string" required="true">

        <!---variable to store the tag is--->
        <cfset var batchTag =''/>
        <cftry>
            <cfquery result="batchTag">
                INSERT INTO     [dbo].[BatchTag]
                                (batchId, tagName)
                VALUES          (<cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>,
                                <cfqueryparam value="#arguments.tag#" cfsqltype='cf_sql_varchar'>)
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: insertBatchTag()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>

        <cfreturn batchTag/>
    </cffunction>

    <!---function to get all the tags of a particular batch--->
    <cffunction  name="getBatchTag" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="batchId" type="numeric" required="true">
        
        <!---variable to store the tags--->
        <cfset var tags = ''/>
        <!---query--->
        <cftry>
            <cfquery name="tags">
                SELECT  *
                FROM    [dbo].[BatchTag]
                WHERE   batchId = <cfqueryparam value="#arguments.batchId#" cfsqltype='cf_sql_bigint'>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getBatchTag() #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>

        <cfreturn tags>
    </cffunction>

    <!---function to store the searched result--->
    <cffunction  name="insertSearchedTag" access="public" output="false" returntype="struct">
        <!---argument--->
        <cfargument  name="tag" type="string" required="true">
        <cfargument  name="pincode" type="string" required="false" default="">
        <!---struct to store function info--->
        <cfset var searchedTagId = ''/>
        <!---query--->
        <cftry>
            <cfquery result='searchedTagId'>
                INSERT INTO     [dbo].[SearchedTag]
                (timestamp, tag, pincode)
                VALUES          (   <cfqueryparam value="#now()#" cfsqltype='cf_sql_timestamp'>, 
                                    <cfqueryparam value="#arguments.tag#" cfsqltype='cf_sql_varchar'>,
                                    <cfqueryparam value="#arguments.pincode#" cfsqltype='cf_sql_varchar'> 
                                )
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: insertSearchedTag()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        
        <cfreturn searchedTagId>
    </cffunction>

    <!---function to get the most searched words--->
    <cffunction  name="getTrendingWord" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="pincode" type="string" required="false">
        
        <!---variable to store the query result--->
        <cfset var trendingWords = ''/>
        <!---query--->
        <cftry>
            <cfquery name='trendingWords'>
                SELECT  tag , COUNT(timestamp)
                FROM    [dbo].[SearchedTag]
                WHERE   [dbo].[SearchedTag].[timestamp] < <cfqueryparam value='#now()#' cfsqltype='cf_sql_timestamp'> 
                AND     [dbo].[SearchedTag].[timestamp] > <cfqueryparam value='#DateAdd("d",-7,now())#' cfsqltype='cf_sql_timestamp'>
                AND     [dbo].[SearchedTag].[pincode] LIKE <cfqueryparam value='#arguments.pincode#%' cfsqltype='cf_sql_varchar'>  
                GROUP BY tag 
                ORDER BY COUNT(timestamp) DESC
            </cfquery>
        <cfcatch type="any">
            <cflog text="databaseService: getMostSearchedWord()-> #cfcatch# #cfcatch.detail# #now()# AND #DateAdd('d',-7,now())#">
        </cfcatch>
        </cftry>
        <cfreturn trendingWords/>
    </cffunction>

    <!---function to get the batch details--->
    <cffunction  name="getUserCount" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="isTeacher" type='numeric' required="false">
        <cfset var user = ''/>
        <!---query--->
        <cftry>
            <cfquery name='user'>
                SELECT  COUNT(userId) as value
                FROM    [dbo].[User]
                WHERE   isTeacher = <cfqueryparam value='#arguments.isTeacher#' cfsqltype='cf_sql_bit'>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getTeacher()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        <cfreturn user>
    </cffunction>

    <!---function to get the batch details--->
    <cffunction  name="getBatchCount" access="public" output="false" returntype="query">
        <!---arguments--->
        <cfargument  name="teacherId" type="numeric" required="false">
        <cfargument  name="studentId" type="numeric" required="false">
        <cfset var batch = ''/>
        <!---query--->
        <cftry>
            <cfquery name='batch'>
                SELECT  COUNT(batchId) as value
                FROM    
                        <cfif structKeyExists(arguments, "studentId")>
                            [dbo].[BatchEnrolledStudent]
                        <cfelse>
                            [dbo].[Batch]
                        </cfif>
                   
                        <cfif structKeyExists(arguments, "teacherId")>
                WHERE       [dbo].[Batch].[batchOwnerId] = <cfqueryparam value="#arguments.teacherId#" cfsqltype='cf_sql_bigint'>
                        <cfelseif structKeyExists(arguments, "studentId")>
                WHERE       [dbo].[BatchEnrolledStudent].[studentId] = <cfqueryparam value="#arguments.studentId#" cfsqltype='cf_sql_bigint'>
                        </cfif>
            </cfquery>
        <cfcatch type="any">
            <cflog  text="databaseService: getTeacher()-> #cfcatch# #cfcatch.detail#">
        </cfcatch>
        </cftry>
        
        <cfreturn batch>
    </cffunction>

</cfcomponent>

 