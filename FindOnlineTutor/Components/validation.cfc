<cfcomponent output="false">

    <cffunction  name="validateName" access="remote" returnformat="json" returntype="struct" output="false">
        <cfargument  name="usrName" type="string" required="true">
        <cfset arguments.usrName=trim(arguments.usrName)/>
        <cfset errorMsg={"error"=""}/>
        <cfif arguments.usrName EQ ''>
            <cfset errorMsg.error="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", arguments.usrName, "/^[A-Za-z']+$/")>
            <cfset errorMsg.error="Invalid Name"/>
        <cfelseif len(arguments.usrName) GT 20>
            <cfset errorMsg.error="Should be less than 20 characters!!"/>
        </cfif>
        <cfreturn errorMsg/>
    </cffunction>

    <cffunction  name="validateEmail" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrEmail" type="string" required="true">

        <cfset arguments.usrEmail=trim(arguments.usrEmail)/>
        <cfset var errorMsg={"error"=""} />

        <cfif arguments.usrEmail EQ ''>
            <cfset errorMsg.error = "Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", arguments.usrEmail, "/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/")>
            <cfset errorMsg.error="Invalid Email Address"/>
        <!---database work to validate email id--->   
        </cfif>  

        <cfreturn errorMsg />
    </cffunction>

    <cffunction  name="validatePhoneNumber" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument name="usrPhoneNumber" type="string" required="true">

        <cfset arguments.usrPhoneNumber=trim(arguments.usrPhoneNumber)/>
        <cfset var errorMsg={"error"=""} />

        <cfif NOT isValid("regex", arguments.usrPhoneNumber, "/^[^0-1][0-9]{9}$/")>
            <cfset errorMsg="Invalid Phone Number."/>
        <!---database work to validate Phone number --->   
        </cfif>  

        <cfreturn errorMsg />
    </cffunction>

    <cffunction  name="validateUsername" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument name="usrName" type="string" required="true">

        <cfset arguments.usrName=trim(arguments.usrName)/>
        <cfset var errorMsg={"msg"=""}/>

        <cfif arguments.usrName EQ ''>
            <cfset errorMsg.msg="Mandatory Field!!"/>
        <cfelseif NOT isValid("regex", arguments.usrName, "/^[a-zA-Z0-9]+[_@]$/") >
            <cfset errorMsg.msg="Invalid Username!! Should include only alphabets,numbers,(_@)">
        <!---database work to validate unique username--->
        </cfif>

        <cfreturn errorMsg/>
    </cffunction>

    <cffunction  name="validatePassword" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrPassword" type="string" required="true">
        <cfset arguments.usrPassword=trim(arguments.usrPassword)/>
        <cfset var errorMsg={"error"=""}/>
        <cfif arguments.usrPassword EQ ''>
            <cfset errorMsg="Please provide a password!!"/>
        <cfelseif len(arguments.usrPassword)>15 and len(arguments.usrPassword)<8 >
            <cfset errorMsg="Password length must be within 8-15!!">
        <cfelseif NOT isValid("regex", arguments.usrPassword,"/^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$/")>
            <cfset errorMsg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.">
        </cfif>

    </cffunction>

    <cffunction  name="validateDOB" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrEmail" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateAddress" access="remote" returnformat="json" returntype="any" output="false">
        <cfargument  name="usrPhoneNumber" type="string" required="true">
        
    </cffunction>

    <cffunction  name="validateCountryState" access="remote" returnformat="json" returntype="any" output="false">
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

    <cffunction name="updateDescriptions" access="remote" returnformat="json" returntype="any" output="false">
<!---     <cfargument name="value" type="string" required="yes"> --->
    <cfset msg={"Apple" = arguments.value}/>
    <cfset theJSON = serializeJSON(msg)/>
    <cftry>
      <cfreturn msg/>
    <cfcatch>
      <cfoutput>
<!---         #cfcatch.Detail#<br /> --->
        #cfcatch.Message#<br />
<!---         #cfcatch.tagcontext[1].line#:#cfcatch.tagcontext[1].template# --->
      </cfoutput>
    </cfcatch>
    </cftry>
  </cffunction>
</cfcomponent>