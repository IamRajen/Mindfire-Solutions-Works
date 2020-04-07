<cfcomponent output="false">

	<!---validateUser() method--->
	<cffunction name="validateUser" access="remote" output="false" returntype="struct" returnformat="json">

		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />

		<cfset var errorMsgs=structNew() />
		<!---Validate the eMail---->
		<cfif NOT isValid('regex', arguments.username,'^[a-zA-Z0-9_@]+$')>
			<cfset errorMsgs['username']='Please, provide a valid eMail address' />
		</cfif>
		<!---Validate the password---->
		<cfif arguments.password EQ ''>
			<cfset errorMsgs['password']='Please, provide a password' />
		</cfif>
        <cfif NOT structIsEmpty(errorMsgs)>
            <cfreturn errorMsgs />
        <cfelse>
            <cfset var isUserLoggedIn=doLogin(arguments.username,arguments.password)/>
            <cfif NOT isUserLoggedIn>
                <cfset errorMsgs['loginError']="User not found. Please try again!!" />
            <cfelseif structKeyExists(session,'stLoggedInUser')>
                <cfset errorMsgs['loggedInSuccessfully']=true/>
            </cfif>
        </cfif>
		
        <cfreturn errorMsgs/>
	</cffunction>

	<!---doLogin() method--->
	<cffunction name="doLogin" access="public" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
        <cfset var hashPassword = hash(arguments.password, "SHA-1", "UTF-8")/>

		<!---Create the isUserLoggedIn variable--->
		<cfset var isUserLoggedIn = false />

		<!---Get the user data from the database--->
		<cfquery name="rsLoginUser">
			SELECT firstName, lastName, username, emailId, password , isTeacher
			FROM [dbo].[User]
			WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" /> AND password = <cfqueryparam value="#hashPassword#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<!---Check if the query returns one and only one user--->
		<cfif rsLoginUser.recordCount EQ 1>
			<!---Log the user in--->
			<cflogin >
				<cfloginuser name="#rsLoginUser.USERNAME# #rsLoginUser.FIRSTNAME#" password="#rsLoginUser.PASSWORD#" roles="#rsLoginUser.ISTEACHER#">
			</cflogin>
			<!---Save user data in the session scope--->
			<cfset session.stLoggedInUser = {'firstName' = rsLoginUser.FIRSTNAME, 'lastName' = rsLoginUser.LASTNAME, 'username' = rsLoginUser.USERNAME} />
			<!---change the isUserLoggedIn variable to true--->
			<cfset var isUserLoggedIn = true />
		</cfif>
		<!---Return the isUserLoggedIn variable--->
		<cfreturn isUserLoggedIn />
	</cffunction>

	<!---doLogout() method--->
	<cffunction name="doLogout" access="public" output="false" returntype="void">
		<!---delete user data from the session scope--->
		<cfset structdelete(session,'stLoggedInUser') />
		<!---Log the user out--->
		<cflogout />
	</cffunction>

</cfcomponent>