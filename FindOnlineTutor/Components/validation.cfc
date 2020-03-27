<cfcomponent output="false">

    <cffunction  name="validateName" access="public" output="false" returnType="string">
        <cfargument  name="usrName" type="string" required="true">
        <cfset arguments.usrName=trim(arguments.usrName)/>
        <cfset var errorMsg="" />
        <cfif NOT isValid("regular_expression", arguments.usrName, "/^[A-Za-z']+$/")>
            <cfset errorMsg="Invalid Name"/>
        </cfif>
        <cfreturn errorMsg />
    </cffunction>

    <cffunction  name="validateEmail" access="public" output="false" returnType="string">
        <cfargument  name="usrEmail" type="string" required="true">
        <cfset arguments.usrName=trim(arguments.usrName)/>
        <cfset var errorMsg="" />
        <cfif NOT isValid("regular_expression", arguments.usrEmail, "/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/")>
            <cfset errorMsg="Invalid Email Address"/>
        <!---database work to validate email id--->   
        </cfif>  
        <cfreturn errorMsg />
    </cffunction>

    <cffunction  name="validatePhoneNumber" access="public" output="false" returnType="string">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        <cfset arguments.usrName=trim(arguments.usrName)/>
        <cfset var errorMsg="" />
        <cfif NOT isValid("regular_expression", arguments.usrPhoneNumber, "/^[^0-1][0-9]{9}$/")>
            <cfset errorMsg="Invalid Phone Number."/>
        <!---database work to validate email id--->   
        </cfif>  
        <cfreturn errorMsg />
    </cffunction>

    <cffunction  name="validateUsername" access="public" output="false" returnType="string">
        <cfargument  name="usrUsername" type="string" required="true">
        <cfset arguments.usrName=trim(arguments.usrName)/>
        <cfset var errorMsg=""/>
        <cfif NOT isValid("regular_expression", arguments.usrUsername, "/^[a-zA-Z0-9_@]+$/") >
            <cfset errorMsg="Invalid Username!! Should include only alphabets,numbers,(_@)">
        <!---database work to validate unique username--->
        </cfif>
        
    </cffunction>

    <cffunction  name="validatePassword" access="public" output="false" returnType="string">
        <cfargument  name="usrPassword" type="string" required="true">
        <cfset arguments.usrPassword=trim(arguments.usrPassword)/>
        <cfset var errorMsg=""/>
        <cfif arguments.usrPassword EQ ''>
            <cfset errorMsg="Please provide a password!!"/>
        <cfelseif len(arguments.usrPassword)>15 and len(arguments.usrPassword)<8 >
            <cfset errorMsg="Password length must be within 8-15!!">
        <cfelseif NOT isValid("regular_expression", arguments.usrPassword,"/^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$/")>
            <cfset errorMsg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>

    </cffunction>

    <cffunction  name="validateDOB" access="public" output="false" returnType="string">
        <cfargument  name="usrEmail" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateAddress" access="public" output="false" returnType="string">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateCountryState" access="public" output="false" returnType="string">
        <cfargument  name="usrUsername" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validatePincode" access="public" output="false" returnType="string">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateBio" access="public" output="false" returnType="string">
        <cfargument  name="usrUsername" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateExperience" access="public" output="false" returnType="string">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateCaptcha" access="public" output="false" returnType="string">
        <cfargument  name="usrUsername" type="string" required="true">
        
    </cffunction>
</cfcomponent>