<!---
Project Name: FindOnlineTutor.
File Name: patternValidation.cfc.
Created In: 13th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file contains some functions which validate a specific pattern.
--->

<cfcomponent>

    <!---function for checking empty string--->
    <cffunction  name="isEmpty" access="public" returntype="boolean">
        <cfargument  name="text" type="string" required="true">
        <cfset var valid=false/>
        <cfif trim(arguments.text) EQ ''>
            <cfset valid=true/>
        </cfif>  
        <cfreturn valid/>
    </cffunction>

    <!---function for checking empty string--->
    <cffunction  name="isBit" access="public" returntype="boolean">
        <cfargument  name="number" type="numeric" required="true">
        <cfset var valid=false/>
        <cfif arguments.number EQ 1 OR arguments.number EQ 0>
            <cfset valid=true/>
        </cfif>  
        <cfreturn valid/>
    </cffunction>
    <!---function to validate email pattern--->
    <cffunction  name="validEmail"  access="public" output="false" returntype="boolean">
        <cfargument  name="email" type="string" required="true"/>
        <cfset var valid=true/>
        <cfif NOT isValid("regex", email,"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")>
            <cfset valid=false/>
        </cfif>
        <cfreturn valid/>
    </cffunction>

    <!---function to validate name pattern--->
    <cffunction  name="validName"  access="public" output="false" returntype="boolean">
        <cfargument  name="name" type="string" required="true"/>
        <cfset var valid=true/>
        <cfif NOT isValid("regex", name, "^[A-Za-z']+$")>
            <cfset valid=false/>
        </cfif>
        <cfreturn valid/>
    </cffunction>

    <!---function to validate username pattern--->
    <cffunction  name="validUsername"  access="public" output="false" returntype="boolean">
        <cfargument  name="username" type="string" required="true"/>
        <cfset var valid=true/>
        <cfif NOT isValid("regex", username, "^[a-zA-Z0-9_@]+$")>
            <cfset valid=false/>
        </cfif>
        <cfreturn valid/>
    </cffunction>

    <!---function to validate password pattern--->
    <cffunction  name="validPassword"  access="public" output="false" returntype="boolean">
        <cfargument  name="password" type="string" required="true"/>
        <cfset var valid=true/>
        <cfif NOT isValid("regex", password,"^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$")>
            <cfset valid=false/>
        </cfif>
        <cfreturn valid/>
    </cffunction>

    <!---function to validate text pattern--->
    <cffunction  name="validText"  access="public" output="false" returntype="boolean">
        <cfargument  name="text" type="string" required="true"/>
        <cfset var valid=true/>
        <cfif NOT isValid("regex", text, "^[a-zA-Z0-9\s,'-]*$")>
            <cfset valid=false/>
        </cfif>
        <cfreturn valid/>
    </cffunction>

    <!---function to validate number pattern--->
    <cffunction  name="validNumber"  access="public" output="false" returntype="boolean">
        <cfargument  name="number" type="string" required="true"/>
        <cfset var valid=true/>
        <cfif NOT isValid("regex", number, "^[0-9]+$")>
            <cfset valid=false/>
        </cfif>
        <cfreturn valid/>
    </cffunction>

</cfcomponent>
