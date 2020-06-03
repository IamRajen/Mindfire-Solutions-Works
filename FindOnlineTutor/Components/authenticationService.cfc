<!---
Project Name: FindOnlineTutor.
File Name: authenticationService.cfc.
Created In: 6th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file contains the functions which help to login the user in our website..!!
--->

<cfcomponent output="false">

	<!---validateUser() method--->
	<cffunction name="validateUser" access="remote" output="false" returntype="struct" returnformat="json">

		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />

		<cfset local.errorMsgs=structNew() />
		<!---Validate the eMail---->
		<cfif NOT isValid('regex', arguments.username,'^[a-zA-Z0-9_@]+$')>
			<cfset local.errorMsgs['username']='Please, provide a valid eMail address' />
		</cfif>
		<!---Validate the password---->
		<cfif arguments.password EQ ''>
			<cfset local.errorMsgs['password']='Please, provide a password' />
		</cfif>
        <cfif NOT structIsEmpty(local.errorMsgs)>
            <cfreturn local.errorMsgs />
        <cfelse>
            <cfset var isUserLoggedIn=doLogin(arguments.username,arguments.password)/>
            <cfif NOT isUserLoggedIn>
                <cfset local.errorMsgs['loginError']="Invalid User Credential. Please try again!!" />
            <cfelseif structKeyExists(session,'stLoggedInUser')>
                <cfset local.errorMsgs['loggedInSuccessfully']=true/>
            </cfif>
        </cfif>
		
        <cfreturn local.errorMsgs/>
	</cffunction>

	<!---doLogin() method--->
	<cffunction name="doLogin" access="public" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
        <cfset local.hashPassword = hash(arguments.password, "SHA-1", "UTF-8")/>

		<!---Create the isUserLoggedIn variable--->
		<cfset local.isUserLoggedIn = false />
		<cfset local.rsLoginUser = ''/>
		<!---Get the user data from the database--->
		<cftry>
			<cfquery name="local.rsLoginUser">
				SELECT firstName, lastName, username, emailId, password , isTeacher, userId, role
				FROM [dbo].[User]
				WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" /> AND password = <cfqueryparam value="#hashPassword#" cfsqltype="cf_sql_varchar" />
			</cfquery>
		<cfcatch type="any">
            <cflog text="error: #cfcatch#">
        </cfcatch>
        </cftry>
		
		<!---Check if the query returns one and only one user--->
		<cfif local.rsLoginUser.recordCount EQ 1>
			<!---Log the user in
			<cflogin>
				<cfloginuser name="#rsLoginUser.FIRSTNAME#" password="#rsLoginUser.PASSWORD#" roles="#rsLoginUser.role#">
			</cflogin>
			--->
			<!---Save user data in the session scope--->
			<cfset session.stLoggedInUser = {'firstName' = local.rsLoginUser.FIRSTNAME, 'lastName' = local.rsLoginUser.LASTNAME, 'username' = local.rsLoginUser.USERNAME, 'userId' = local.rsLoginUser.USERId, 'role' = local.rsLoginUser.role} />
			<!---change the isUserLoggedIn variable to true--->
			<cfset local.isUserLoggedIn = true />
		</cfif>
		<!---Return the isUserLoggedIn variable--->
		<cfreturn local.isUserLoggedIn />
	</cffunction>

	<!---doLogout() method--->
	<cffunction name="doLogout" access="public" output="false" returntype="void">
		<!---delete user data from the session scope--->
		<cfset structdelete(session,'stLoggedInUser') />
		<!---Log the user out--->
		<cflogout />
	</cffunction>

</cfcomponent>