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
        <cfset local.valid=false/>
        <cfif trim(arguments.text) EQ ''>
            <cfset local.valid=true/>
        </cfif>  
        <cfreturn local.valid/>
    </cffunction>

    <!---function for checking empty string--->
    <cffunction  name="isBit" access="public" returntype="boolean">
        <cfargument  name="number" type="numeric" required="true">
        <cfset local.valid=false/>
        <cfif arguments.number EQ 1 OR arguments.number EQ 0>
            <cfset local.valid=true/>
        </cfif>  
        <cfreturn local.valid/>
    </cffunction>
    <!---function to validate email pattern--->
    <cffunction  name="validEmail"  access="public" output="false" returntype="boolean">
        <cfargument  name="email" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", email,"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate name pattern--->
    <cffunction  name="validName"  access="public" output="false" returntype="boolean">
        <cfargument  name="name" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", name, "^[A-Za-z']+$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate username pattern--->
    <cffunction  name="validUsername"  access="public" output="false" returntype="boolean">
        <cfargument  name="username" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", username, "^[a-zA-Z0-9_@]+$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate password pattern--->
    <cffunction  name="validPassword"  access="public" output="false" returntype="boolean">
        <cfargument  name="password" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", password,"^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate text pattern--->
    <cffunction  name="validText"  access="public" output="false" returntype="boolean">
        <cfargument  name="text" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", text, "^[a-zA-Z0-9\s.,'-]*$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate number pattern--->
    <cffunction  name="validNumber"  access="public" output="false" returntype="boolean">
        <cfargument  name="number" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", number, "^[0-9]+$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate only alphabets and spaces--->
    <cffunction  name="validHeading"  access="public" output="false" returntype="boolean">
        <cfargument  name="text" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", text, "^[a-zA-Z ]+$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate only alphabets and spaces--->
    <cffunction  name="validLargeText"  access="public" output="false" returntype="boolean">
        <cfargument  name="text" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", text, "^[ A-Za-z0-9_@./:&+-]*$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

    <!---function to validate time--->
    <cffunction  name="validTime"  access="public" output="false" returntype="boolean">
        <cfargument  name="time" type="string" required="true"/>
        <cfset local.valid=true/>
        <cfif NOT isValid("regex", time, "^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])$")>
            <cfset local.valid=false/>
        </cfif>
        <cfreturn local.valid/>
    </cffunction>

</cfcomponent>
