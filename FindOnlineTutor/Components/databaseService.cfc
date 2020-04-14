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

        <cfcatch type="any">
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
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
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
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
            <cflog  text="#arguments.userId# : #cfcatch.detail#">
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
            <cflog text="#arguments.username# : #cfcatch.detail#">
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
        <cfargument  name="password" type="string" required="true"/>
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
                    password = <cfqueryparam value = '#hash(arguments.password, "SHA-1", "UTF-8")#' cfsqltype='cf_sql_varchar'>,
                    bio = <cfqueryparam value='#arguments.bio#' cfsqltype='cf_sql_varchar'>
                WHERE userId=#session.stloggedinuser.userID#
            </cfquery>
        <cfcatch type="any">
            <cfset updatedSuccessfully.error="#cfcatch.detail#"/>
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
            <cfset updatedSuccessfully.error="#cfcatch.detail#"/>
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
            <cfset updatedSuccessfully.error="#cfcatch.detail#"/>
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

        <cfset var isCommit=false/>
        <cftransaction>
            <cftry>
                <cfset var queryUserCredential=''/>
                <!---inserting the user credentials in user table--->
                <cfquery result="queryUserCredential">
                    <!---Inserting data in the user table--->
                    INSERT INTO [dbo].[User] 
                    (registrationDate,firstName,lastName,emailid,username,password,dob,isTeacher,
                        yearOfExperience,homeLocation,otherLocation,online,bio)
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
                        <cfqueryparam value='#arguments.bio#' cfsqltype='cf_sql_varchar'>
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
                <cflog text="#cfcatch.detail#">
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
            <cfset insertedSuccessfully.error='#cfcatch.detail#'/>
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
            <cfset insertedSuccessfully.error='#cfcatch.detail#'/>
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
            <cfset isEmailAddressPresent.error=#cfcatch.detail#/>
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
                SELECT phoneNumber
                FROM [dbo].[UserPhoneNumber]
                WHERE phoneNumber=<cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">;
            </cfquery>
        <cfcatch type="any">
            <cfset isPhoneNumberPresent.error=#cfcatch.detail#/>
        </cfcatch>
        </cftry>
        <cfif NOT structKeyExists(isPhoneNumberPresent, "error")>
            <cfif queryPhone.recordCount GTE 1>
                <cfset isPhoneNumberPresent.isPresent=true/>
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
            <cfset isUsernamePresent.error=#cfcatch.detail#/>
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


</cfcomponent>