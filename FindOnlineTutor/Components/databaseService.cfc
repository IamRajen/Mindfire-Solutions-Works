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


    <!---update user profile--->
    <cffunction  name="updateUserProfile" access="remote" output="false" returnformat="json" returntype="struct">
        <!---arguments declaration--->

        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="primaryPhoneNumber" type="string" required="true"/>
        <cfargument  name="alternativePhoneNumber" type="string" required="false"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="password" type="string" required="true"/>
        <cfargument  name="confirmPassword" type="string" required="true"/>
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

        <!---creating object of validation.cfc for validation--->
        <cfset var patternValidationObj = createObject("component","patternValidation")/>

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset errorMsgs={}>
        <cfset errorMsgs["validatedSuccessfully"]=true/>

        <cfset errorMsgs["firstName"]=patternValidationObj.validName(arguments.firstName)/>
        <cfset errorMsgs["lastName"]=patternValidationObj.validName(arguments.lastName)/>
        <cfset errorMsgs["emailAddress"]=patternValidationObj.validEmail(arguments.emailAddress)/>
        <cfset errorMsgs["primaryPhoneNumber"]=patternValidationObj.validNumber(arguments.primaryPhoneNumber)/>

        <cfif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber NEQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]=patternValidationObj.validNumber(arguments.alternativePhoneNumber)/>
        <cfelseif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber EQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]="Alternative number should not be same.You can keep this blank."/>
        </cfif>

        <!---<cfset errorMsgs["dob"]=validationObj.validateDOB(arguments.dob)/> --->
        <cfset errorMsgs["password"]=patternValidationObj.validPassword(arguments.password)/>

        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset errorMsgs["confirmPassword"]="password not matched!!"/>
        </cfif>

        
        <cfset errorMsgs["currentAddress"]=patternValidationObj.validText(arguments.currentAddress)/>
        <cfset errorMsgs["currentCountry"]=patternValidationObj.validText(arguments.currentCountry)/>
        <cfset errorMsgs["currentState"]=patternValidationObj.validText(arguments.currentState)/>
        <cfset errorMsgs["currentCity"]=patternValidationObj.validText(arguments.currentCity)/>
        <cfset errorMsgs["currentPincode"]=patternValidationObj.validNumber(arguments.currentPincode)/>

        <cfif arguments.havingAlternativeAddress>
            <cfset errorMsgs["alternativeAddress"]=patternValidationObj.validText(arguments.alternativeAddress)/>
            <cfset errorMsgs["alternativeCountry"]=patternValidationObj.validText(arguments.alternativeCountry)/>
            <cfset errorMsgs["alternativeState"]=patternValidationObj.validText(arguments.alternativeState)/>
            <cfset errorMsgs["alternativeCity"]=patternValidationObj.validText(arguments.alternativeCity)/>
            <cfset errorMsgs["alternativePincode"]=patternValidationObj.validNumber(arguments.alternativePincode)/>
        </cfif>
        
        <cfif arguments.bio NEQ ''>
            <cfset errorMsgs["bio"]=patternValidationObj.validText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully' and errorMsgs[key] NEQ true>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif errorMsgs["validatedSuccessfully"]>
            <cfset var isCommit=''/>
            <cftransaction>
                <cftry>
                    <cfset var updateUserInfo=''/>
                    <cfquery name="updateUserInfo">
                        UPDATE [dbo].[User]
                        SET firstName = <cfqueryparam value='#arguments.firstName#' cfsqltype='cf_sql_varchar'>,
                            lastName = <cfqueryparam value='#arguments.lastName#' cfsqltype='cf_sql_varchar'>,
                            emailId = <cfqueryparam value='#arguments.emailAddress#' cfsqltype='cf_sql_varchar'>,
                            dob = <cfqueryparam value='#arguments.dob#' cfsqltype='cf_sql_date'>, 
                            password = <cfqueryparam value = '#hash(arguments.password, "SHA-1", "UTF-8")#' cfsqltype='cf_sql_varchar'>,
                            bio = <cfqueryparam value='#arguments.bio#' cfsqltype='cf_sql_varchar'>
                        WHERE userId=#session.stloggedinuser.userID#
                    </cfquery>

                    <!---updating phone numbers--->
                    <cfset var updateUserPhoneInfo=''/>
                    <!---gettting the phone numbers of user--->
                    <cfset userPhoneNumbers = getMyPhoneNumber(session.stLoggedinuser.userID)/> 
                    <!---updating the primary phone number--->
                    <cfquery name='updateUserPhoneInfo'>
                        UPDATE [dbo].[UserPhoneNumber]
                        SET phoneNumber = <cfqueryparam value='#arguments.primaryPhoneNumber#' cfsqltype='cf_sql_varchar'>
                        WHERE userPhoneNumberId = <cfqueryparam value=#userPhoneNumbers.phoneNumber.userPhoneNumberId[1]# cfsqltype='cf_sql_bigint'>
                    </cfquery>
                    <!---checking if user have the alternative phone number if yes, will update or insert--->
                    <cfif userPhoneNumbers.phoneNumber.RecordCount EQ 2> 
                        <cfquery name='updateUserPhoneInfo'>
                            UPDATE [dbo].[UserPhoneNumber]
                            SET phoneNumber = <cfqueryparam value='#arguments.alternativePhoneNumber#' cfsqltype='cf_sql_varchar'>
                            WHERE userPhoneNumberId =  <cfqueryparam value=#userPhoneNumbers.phoneNumber.userPhoneNumberId[2]# cfsqltype='cf_sql_bigint'>
                        </cfquery>
                    <cfelseif arguments.alternativePhoneNumber NEQ ''>
                        <cfquery name="queryPhoneCredential">
                            INSERT INTO [dbo].[UserPhoneNumber]
                            (userId,phoneNumber)
                            VALUES (
                                <cfqueryparam value=#session.stLoggedinuser.UserID# cfsqltype='cf_sql_bigint'>,
                                <cfqueryparam value='#arguments.alternativePhoneNumber#' cfsqltype='cf_sql_varchar'>
                            )
                        </cfquery>
                    </cfif>  

                    <!---updating addresses--->
                    <cfset var updateUserAddressInfo=''/>
                    <!---getting the addresses of user--->
                    <cfset userAddresses = getMyAddress(session.stLoggedinuser.userID)/>
                    <!---updating the current address--->
                    <cfquery name='updateUserAddressInfo'>
                        UPDATE [dbo].[UserAddress]
                        SET address = <cfqueryparam value='#arguments.currentAddress#' cfsqltype='cf_sql_varchar'>,
                            country = <cfqueryparam value='#arguments.currentCountry#' cfsqltype='cf_sql_varchar'>,
                            state = <cfqueryparam value='#arguments.currentState#' cfsqltype='cf_sql_varchar'>,
                            city = <cfqueryparam value='#arguments.currentCity#' cfsqltype='cf_sql_varchar'>,
                            pincode = <cfqueryparam value='#arguments.currentPincode#' cfsqltype='cf_sql_varchar'>
                        WHERE userAddressId = <cfqueryparam value=#userAddresses.address.userAddressId[1]# cfsqltype='cf_sql_bigint'>;
                    </cfquery>
                    <cfset errorMsgs.userAddress = userAddresses/>
                    <cfif userAddresses.address.RecordCount EQ 2>
                        <cfquery name='updateUserAddressInfo'>
                            UPDATE [dbo].[UserAddress]
                            SET address = <cfqueryparam value='#arguments.alternativeAddress#' cfsqltype='cf_sql_varchar'>,
                                country = <cfqueryparam value='#arguments.alternativeCountry#' cfsqltype='cf_sql_varchar'>,
                                state = <cfqueryparam value='#arguments.alternativeState#' cfsqltype='cf_sql_varchar'>,
                                city = <cfqueryparam value='#arguments.alternativeCity#' cfsqltype='cf_sql_varchar'>,
                                pincode = <cfqueryparam value='#arguments.alternativePincode#' cfsqltype='cf_sql_varchar'>
                            WHERE userAddressId = <cfqueryparam value=#userAddresses.address.userAddressId[2]# cfsqltype='cf_sql_bigint'>;
                        </cfquery>
                    <cfelseif arguments.alternativeAddress NEQ ''>
                        <cfquery name="queryAddressCredential">
                            INSERT INTO [dbo].[UserAddress]
                            (userId,address,country,state,city,pincode)
                            VALUES (
                                <cfqueryparam value=#session.stLoggedinuser.UserID# cfsqltype='cf_sql_bigint'>,
                                <cfqueryparam value='#arguments.alternativeAddress#' cfsqltype='cf_sql_varchar'>,
                                <cfqueryparam value='#arguments.alternativeCountry#' cfsqltype='cf_sql_varchar'>,
                                <cfqueryparam value='#arguments.alternativeState#' cfsqltype='cf_sql_varchar'>,
                                <cfqueryparam value='#arguments.alternativeCity#' cfsqltype='cf_sql_varchar'>,
                                <cfqueryparam value='#arguments.alternativePincode#' cfsqltype='cf_sql_varchar'>
                            )
                        </cfquery>
                    </cfif> 
                --->

                    <cftransaction action="commit" />
                    <cfset isCommit=true />
                <cfcatch type="any">
                    <cflog  text="#cfcatch.detail#">
                </cfcatch>
                </cftry>
            </cftransaction>
		    <cfif isCommit==true>
                <cfset errorMsgs["validatedSuccessfully"]=true/> 
                <cfset errorMsgs.commit = isCommit>  
            <cfelse>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfset errorMsgs.commit = isCommit>  
            </cfif>  
        </cfif>

        <cfreturn errorMsgs/>
    </cffunction>


</cfcomponent>