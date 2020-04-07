

<cfcomponent output="false">
    <!---onsubmit validation--->
    <cffunction  name="validateForm" access="remote" output="false" returnformat="json" returntype="struct">

        <!---defining arguments--->
        <cfargument  name="profilePhoto" type="string" required="true"/>
        <cfargument  name="firstName" type="string" required="true"/>
        <cfargument  name="lastName" type="string" required="true"/>
        <cfargument  name="emailAddress" type="string" required="true"/>
        <cfargument  name="primaryPhoneNumber" type="string" required="true"/>
        <cfargument  name="alternativePhoneNumber" type="string" required="false"/>
        <cfargument  name="dob" type="string" required="true"/>
        <cfargument  name="username" type="string" required="true"/>
        <cfargument  name="password" type="string" required="true"/>
        <cfargument  name="confirmPassword" type="string" required="true"/>
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

        <!--- creating a struct for error messages and calling the required functions--->
        <cfset errorMsgs={}>
        <cfset errorMsgs["validatedSuccessfully"]=true/>
        <!--- <cfset errorMsg.profilePhoto=validateProfilePhoto(arguments.profilePhoto)> --->
        <cfset errorMsgs["firstName"]=validateName(arguments.firstName)/>
        <cfset errorMsgs["lastName"]=validateName(arguments.lastName)/>
        <cfset errorMsgs["emailAddress"]=validateEmail(arguments.emailAddress)/>
        <cfset errorMsgs["primaryPhoneNumber"]=validatePhoneNumber(arguments.primaryPhoneNumber)/>

        <cfif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber NEQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]=validatePhoneNumber(arguments.alternativePhoneNumber)/>
        <cfelseif arguments.alternativePhoneNumber NEQ '' and arguments.alternativePhoneNumber EQ arguments.primaryPhoneNumber>
            <cfset errorMsgs["alternativePhoneNumber"]="Alternative number should not be same.You can keep this blank."/>
        </cfif>

        <cfset errorMsgs["dob"]=validateDOB(arguments.dob)/>
        <cfset errorMsgs["username"]=validateUsername(arguments.username)/>
        <cfset errorMsgs["password"]=validatePassword(arguments.password)/>

        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset errorMsgs["confirmPassword"]="password not matched!!"/>
        </cfif>

        <cfif arguments.isTeacher EQ 1>
            <cfset errorMsgs["experience"]=validateExperience(arguments.experience)/>
        <cfelse>
            <cfset arguments.experience=0/>
        </cfif>
        
        <cfset errorMsgs["currentAddress"]=validateText(arguments.currentAddress)/>
        <cfset errorMsgs["currentCountry"]=validateText(arguments.currentCountry)/>
        <cfset errorMsgs["currentState"]=validateText(arguments.currentState)/>
        <cfset errorMsgs["currentCity"]=validateText(arguments.currentCity)/>
        <cfset errorMsgs["currentPincode"]=validatePincode(arguments.currentPincode)/>

        <cfif arguments.havingAlternativeAddress>
            <cfset errorMsgs["alternativeAddress"]=validateText(arguments.alternativeAddress)/>
            <cfset errorMsgs["alternativeCountry"]=validateText(arguments.alternativeCountry)/>
            <cfset errorMsgs["alternativeState"]=validateText(arguments.alternativeState)/>
            <cfset errorMsgs["alternativeCity"]=validateText(arguments.alternativeCity)/>
            <cfset errorMsgs["alternativePincode"]=validatePincode(arguments.alternativePincode)/>
        </cfif>
        
        <cfif arguments.bio NEQ ''>
            <cfset errorMsgs["bio"]=validateText(arguments.bio)/>
        </cfif>
        
        <!---looping the errorMsgs struct for validation--->
        <cfloop collection="#errorMsgs#" item="key">
            <cfif key NEQ 'validatedSuccessfully'>
                <cfset errorMsgs["validatedSuccessfully"]=false/>
                <cfif errorMsgs[key] NEQ ''>
                    <cfreturn errorMsgs/>
                </cfif> 
            </cfif>
        </cfloop>
        
        <!---if successfully validated do Registration Work--->
        <cfset errorMsgs["validatedSuccessfully"]=true/>

        <cfquery>
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

        <!---getting the userId through username--->
        <cfset var userId =#getUserId(arguments.username).USERID#/>

        <!---calling function for inserting the user primary phone number--->
        <cfset var errorMsgs.phoneInsertionError=insertPhoneNumber(userId,arguments.primaryPhoneNumber)/>

        <!---calling function for inserting the user alternatve phone number if exists--->
        <cfif arguments.alternativePhoneNumber NEQ ''>
            <cfset var errorMsgs.alternativePhoneInsertionError=insertPhoneNumber(userId,arguments.alternativePhoneNumber)/>
        </cfif>

        <!---calling function for inserting user current address in userAdrress table--->
        <cfset errorMsgs.addressInsertionError=insertAddress(
            userId,arguments.currentAddress,arguments.currentCountry,arguments.currentState,
            arguments.currentCity,arguments.currentPincode
        ) />

        <!---calling function for inserting user alternative address (if exists) in userAdrress table--->
        <cfif arguments.havingAlternativeAddress == true>
            <cfset errorMsgs.alternativeAddressInsertionError=insertAddress(
                userId,arguments.alternativeAddress,arguments.alternativeCountry,arguments.alternativeState,
                arguments.alternativeCity,arguments.alternativePincode
            ) />
        </cfif>

        <cfreturn errorMsgs/>
    </cffunction>

    <!---function for checking empty string--->
    <cffunction  name="isEmpty" access="public" returntype="boolean">
        <cfargument  name="text" type="string" required="true">
        <cfif trim(arguments.text) EQ ''>
            <cfreturn true/>
        </cfif>  
        <cfreturn false/>
    </cffunction>

    <!---function to validate valid photo--->
    <cffunction  name="validateProfilePhoto" access="remote" returnformat="json" returntype="string" output="false"> 
        <cfargument  name="profilePhoto" type="string" required="true"/>
        
    </cffunction>

    <!---function to validate name--->
    <cffunction name="validateName" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument  name="usrName" type="string" required="true">
        <cfset errorMsg=""/>
        <cfif isEmpty(arguments.usrName)>
            <cfset errorMsg="Mandatory field!!"/>
            <cfreturn errorMsg/>
        </cfif>
        <cfset name=trim(arguments.usrName)/>
        <cfif NOT isValid("regex", name, "^[A-Za-z']+$")>
            <cfset errorMsg="Invalid Name.Only Alphabets allowed without spaces."/>
        <cfelseif len(name) GT 20>
            <cfset errorMsg="Should be less than 20 characters!!"/>
        </cfif>
        <cfreturn errorMsg/> 
    </cffunction>

    <!---function to validate email pattern--->
    <cffunction  name="validateEmail" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument  name="usrEmail" type="string" required="true">
        <cfset email=trim(arguments.usrEmail) />
        <cfset errorMsg=""/>
        <cfif email EQ ''>
            <cfset errorMsg="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", email,"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")>
            <cfset errorMsg="Invalid Email Address."/>
        <cfelse>    
            <cfquery name="emailId">
                SELECT emailId
                FROM [dbo].[User]
                WHERE emailId=<cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">;
            </cfquery>
            <cfif emailId.recordCount GTE 1>
                <cfset errorMsg="Email Address Already Exists!!">
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate phone number pattern--->
    <cffunction  name="validatePhoneNumber" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument name="usrPhoneNumber" type="string" required="true">
        <cfset var phoneNumber = arguments.usrPhoneNumber/>
        <cfset var errorMsg=""/>
        <cfif phoneNumber EQ ''>
            <cfset errorMsg="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", phoneNumber, "^[^0-1][0-9]{9}$")>
            <cfset errorMsg="Invalid Phone Number!!Only number Allowed"/>
        <cfelse>
            <cfquery name="phoneNumberExists">
                SELECT phoneNumber
                FROM [dbo].[UserPhoneNumber] 
                WHERE phoneNumber=<cfqueryparam value='#phoneNumber#' cfsqltype="cf_sql_bigint">
            </cfquery>
            <cfif phoneNumberExists.recordCount EQ 1>
                <cfset errorMsg="Phone number already exists!!">
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate username pattern and unique--->
    <cffunction  name="validateUsername" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument name="usrName" type="string" required="true">
        <cfset var username = arguments.usrName/>
        <cfset var errorMsg=""/>
        <cfif username EQ ''>
            <cfset errorMsg="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", username, "^[a-zA-Z0-9_@]+$")>
            <cfset errorMsg="Username should contain only alphabets, numbers, (_ @ .) and 8 characters long"/>
        <cfelse>
            <cfquery name="users">
                SELECT username
                FROM [dbo].[User]
                WHERE username=<cfqueryparam value='#username#' cfsqltype='cf_sql_varchar'>;
            </cfquery>
            <cfif users.recordCount EQ 1>
                <cfset errorMsg='Username already taken!!'>
            </cfif>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate password pattern--->
    <cffunction  name="validatePassword" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument  name="usrPassword" type="string" required="true">
        <cfset password=trim(arguments.usrPassword)/>
        <cfset var errorMsg=""/>
        <cfif password EQ ''>
            <cfset errorMsg="Please provide a password!!"/>
        <cfelseif len(password) GT 15 and len(password) LT 8 >
            <cfset errorMsg="Password length must be within 8-15!!">
        <cfelseif NOT isValid("regex", password,"^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$")>
            <cfset errorMsg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate valid DOB--->
    <cffunction  name="validateDOB" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument  name="usrDOB" type="string" required="true">
        <cfset dob=arguments.usrDOB/>
        <cfset errorMsg=""/>
        <cfif NOT IsDate(dob)>
            <cfset errorMsg="Not a Valid date format!!">
        <cfelse>
            <cfset dob=dateTimeFormat(dob, "MM/dd/yyyy") />
            <cfif Year(dob) GT Year(now())-2 OR Year(dob) LT Year(now())-80 >
                <cfset errorMsg="Should be greater than 2 years and less than 80 years old"/>
            </cfif>
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate any valid text--->
    <cffunction  name="validateText" access="remote" returnformat="json" returntype="string" output="false">
        <cfargument  name="usrText" type="string" required="true">
        <cfset var text=trim(arguments.usrText)/>
        <cfset errorMsg=""/>
        <cfif text EQ ''>
            <cfset errorMsg = "Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", text, "^[a-zA-Z0-9\s,'-]*$")>
            <cfset errorMsg="Should contain only alphabets, number and ',''/''&' "/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to validate valid pincode--->
    <cffunction  name="validatePincode" access="remote" output="false" returnType="string">
        <cfargument  name="usrPincode" type="string" required="true">
        <cfset pincode = arguments.usrPincode />
        <cfset errorMsg=""/>
        <cfif pincode EQ ''>
            <cfset errorMsg="Mandatory Field"/>
        <cfelseif NOT isValid("regex", pincode, "^[0-9]{6}$")>
            <cfset errorMsg="Invalid Pincode.Must be Number of 6 digit">
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <!---function to validate experience--->
    <cffunction  name="validateExperience" access="remote" output="false" returnType="string">
        <cfargument name="usrExperience" type="string" required="true">
        <cfset experience = trim(arguments.usrExperience)/>
        <cfset errorMsg =""/>
        <cfif experience GT 99 and experience LT 0>
            <cfset errorMsg="Experience must be within 0 to 99"/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <!---function to insert user address in table--->
    <cffunction  name="insertAddress" access="public" output="false" returntype="string">

        <cfargument  name="userId" type="any" required="true">
        <cfargument  name="address" type="string" required="true">
        <cfargument  name="country" type="string" required="true">
        <cfargument  name="state" type="string" required="true">
        <cfargument  name="city" type="string" required="true">
        <cfargument  name="pincode" type="string" required="true">
        <cfset var error = ""/>
        <cftry>
            <cfquery>
                INSERT INTO [dbo].[UserAddress]
                (userId,address,country,state,city,pincode)
                VALUES (
                    <cfqueryparam value='#arguments.userId#' cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.address#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.country#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.state#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.city#' cfsqltype='cf_sql_varchar'>,
                    <cfqueryparam value='#arguments.pincode#' cfsqltype='cf_sql_varchar'>
                )
            </cfquery>
        <cfcatch type="database">
            <cfset error = #cfcatch.detail#/>
        </cfcatch>
        <cfcatch type="any">
            <cfset error = #cfcatch.detail#>
        </cfcatch>
        </cftry>
        
        <cfreturn error/>
    </cffunction>

    <!---function to get the userId with respect to the username--->
    <cffunction name="getUserId" access="public" output="false" returntype="query">
        <cfargument  name="username" type="string" required="true">
        <cfset var userId = '' />
        <cfquery name="userId">
            SELECT userId
            FROM [dbo].[User]
            WHERE username=<cfqueryparam value="#arguments.username#" cfsqltype='cf_sql_varchar'>
        </cfquery>
        <cfreturn userId />
    </cffunction>

    <!---function to insert user phone in table--->
    <cffunction  name="insertPhoneNumber" access="public" output="false" returntype="string">
        <cfargument  name="userId" type="any" required="true">
        <cfargument  name="phoneNumber" type="string" required="true">
        <cfset var error = ""/>
        <cftry>
            <cfquery>
                INSERT INTO [dbo].[UserPhoneNumber]
                (userId,phoneNumber)
                VALUES (
                    <cfqueryparam value='#arguments.userId#' cfsqltype='cf_sql_bigint'>,
                    <cfqueryparam value='#arguments.phoneNumber#' cfsqltype='cf_sql_varchar'>
                )
            </cfquery>
        <cfcatch type="database">
            <cfset error="#cfcatch.message#"/>
        </cfcatch>
        </cftry>
        
        <cfreturn error/>
    </cffunction>

</cfcomponent>

