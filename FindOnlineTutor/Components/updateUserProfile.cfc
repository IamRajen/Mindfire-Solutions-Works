<!---
Project Name: FindOnlineTutor.
File Name: updateUserProfile.cfc.
Created In: 14th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file helps to validate and update the user profile.
--->
<cfcomponent output="false">
    <cfset databaseServiceObj=createObject("component","databaseService")/>
    <cfset patternValidationObj=createObject("component","patternValidation")/>
    
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
                    <!---updating user info--->

                    <cfset var userInfoUpdate=databaseServiceObj.updateUser(
                        arguments.firstName, arguments.lastName, arguments.emailAddress, arguments.dob, 
                        arguments.password,arguments.bio
                    )/>
                    <cfif structKeyExists(userInfoUpdate, "error")>
                        <cfthrow detail='#userInfoUpdate.error#'/>
                    </cfif>
                    
                    <!---updating phone numbers--->

                    <!---getting the phone numbers of user--->
                    <cfset userPhoneNumbers = databaseServiceObj.getMyPhoneNumber(session.stLoggedinuser.userID)/> 
                    <!---updating the primary phone number--->
                    <cfset var phoneInfoUpdate=databaseServiceObj.updatePhoneNumber(
                        userPhoneNumbers.phoneNumber.userPhoneNumberId[1], arguments.primaryPhoneNumber
                    )/>
                    <cfif structKeyExists(phoneInfoUpdate, "error")>
                        <cfthrow detail='#phoneInfoUpdate.error#'/>
                    </cfif>
                    
                    <!---checking if user have the alternative phone number if yes, will update or insert--->
                    <cfif userPhoneNumbers.phoneNumber.RecordCount EQ 2> 
                        <cfset phoneInfoUpdate=databaseServiceObj.updatePhoneNumber(
                            userPhoneNumbers.phoneNumber.userPhoneNumberId[2], arguments.alternativePhoneNumber
                        )/>
                        <cfif structKeyExists(phoneInfoUpdate, "error")>
                            <cfthrow detail='#phoneInfoUpdate.error#'/>
                        </cfif>
                    <!---if alternative phone number not present it will insert a phone number--->
                    <cfelseif arguments.alternativePhoneNumber NEQ ''>
                        <cfset var insertPhone = databaseServiceObj.insertPhoneNumber(
                            session.stLoggedinuser.userID,arguments.alternativePhoneNumber
                        )/>
                        <cfif structKeyExists(insertPhone, "error")>
                            <cfthrow detail = '#insertPhone.error#'/> 
                        </cfif>
                    </cfif>  

                    <!---updating addresses--->

                    <!---getting the addresses of user--->
                    <cfset userAddresses = databaseServiceObj.getMyAddress(session.stLoggedinuser.userID)/>
                    <!---updating the current address--->
                    <cfset var addressInfoUpdate=databaseServiceObj.updateAddress(
                        userAddresses.address.userAddressId[1], arguments.currentAddress, arguments.currentCountry,
                        arguments.currentState, arguments.currentCity, arguments.currentPincode
                    )/>
                    <cfif structKeyExists(addressInfoUpdate, "error")>
                        <cfthrow detail='#addressInfoUpdate.error#'/>
                    </cfif>
                    <!---updating the alternative address if present else inserting the address--->
                    <cfif userAddresses.address.RecordCount EQ 2>
                        <cfset addressInfoUpdate=databaseServiceObj.updateAddress(
                            userAddresses.address.userAddressId[2], arguments.alternativeAddress, arguments.alternativeCountry,
                            arguments.alternativeState, arguments.alternativeCity, arguments.alternativePincode
                        )/>
                        <cfif structKeyExists(addressInfoUpdate, "error")>
                            <cfthrow detail='#addressInfoUpdate.error#'/>
                        </cfif>
                    <!---inserting the alternative address --->
                    <cfelseif arguments.alternativeAddress NEQ ''>
                        <cfset var insertAlternativeAddress = insertAddress(
                            userId,arguments.alternativeAddress, arguments.alternativeCountry, arguments.alternativeState,
                            arguments.alternativeCity, arguments.alternativePincode)/>
                        <cfif structKeyExists(insertAlternativeAddress, "error")>
                            <cfthrow detail = '#insertAlternativeAddress.error#'/>
                        </cfif>
                    </cfif> 
                

                    <cftransaction action="commit" />
                    <cfset isCommit=true />
                <cfcatch type="any">
                    <cflog  text="#cfcatch#">
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

    <!---validating the email address for update--->
    <cffunction  name="validateEmail" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining arguments--->
        <cfargument  name="emailId" type="string" required="true"/>
        <!---declaring a structure for returing error msgs--->
        <cfset var errorMsg={}/>
        <!---declaring a variable for further use--->
        <cfset var email=trim(arguments.emailId)/>
        <!---validation works starts here--->
        <cfif patternValidationObj.isEmpty(email)>
            <cfset errorMsg.msg = "Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validEmail(email)>
            <cfset errorMsg.msg="Invalid Email Address"/>
        <cfelse>
            <cftry>
                <cfset var emailPresent = databaseServiceObj.isEmailPresent(email)/>
                <cfif structKeyExists(emailPresent, "error")>
                    <cfthrow detail = '#emailPresent.error#'>
                <cfelseif (emailPresent.isPresent) and (emailPresent.info.userId[1] NEQ #session.stLoggedinuser.userID#)>
                    <cfset errorMsg.msg="Email address already present"/>
                </cfif>
            <cfcatch type="any">
                <cfset errorMsg.error="#cfcatch#"/>
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn errorMsg/> 
    </cffunction>

    <!---validating the phone Number for update--->
    <cffunction  name="validatePhone" access="remote" output="false" returntype="struct" returnformat="json">
        <!---defining the argument--->
        <cfargument  name="phoneNumber" type="string" required="true"/>
        <!---declaring a structure for returning error msgs--->
        <cfset var errorMsg={}/>
        <!---declaring a variable for further usage--->
        <cfset var phone=trim(arguments.phoneNumber)/>
        <!---validation starts here--->
        <cfif patternValidationObj.isEmpty(phone)>
            <cfset errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT patternValidationObj.validNumber(phone)>
            <cfset errormsg.msg="Invalid Phone Number.Only numbers allowed.">
        <cfelse>
            <cftry>
                <cfset var phonePresent = databaseServiceObj.isPhonePresent(phone)/>
                <cfif structKeyExists(phonePresent, "error")>
                    <cfthrow detail = #phonePresent.error#/>
                <cfelseif (phonePresent.isPresent) and (phonePresent.info.userId[1] NEQ #session.stLoggedinuser.userID#)>
                    <cfset errorMsg.msg = "Phone number already exists"/>
                </cfif>
            <cfcatch type="any">
                <cfset errorMsg.error="#cfcatch#"/>
            </cfcatch>
            </cftry>
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>
</cfcomponent>
    