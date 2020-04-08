<!---
Project Name: FindOnlineTutor.
File Name: Application.cfc.
Created In: 27th Mar 2020
Created By: Rajendra Mishra.
Functionality: This page get first executed whenever a request comes to the website.Includes some of the essential functions.
--->
<cfcomponent output="false">
	<cfset this.name = 'FindOnlineTutor' />
	<cfset this.applicationTimeout = createtimespan(0,2,0,0) />
	<cfset this.datasource = 'DBFindOnlineTutor' />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimespan(1,0,0,0) />

	<!---OnApplicationStart() method--->
	<cffunction name="onApplicationStart" returntype="boolean" >
		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" >
		<cfargument name="targetPage" type="string" required="true" />
		<!---handle some special URL parameters--->
		<cfif isDefined('url.restartApp')>
			<cfset this.onApplicationStart() />
		</cfif>
		<cfreturn true />
	</cffunction>

	<cffunction name="onMissingTemplate" returntype="boolean">
		<cfargument name="targetPage" type="string" required=true/>
		<!--- Using a try block to catch errors. --->
		<cftry>
		<!--- Log all errors. --->
			<cflog type="error" text="Missing template: #Arguments.targetPage#">

			<!--- Display an error message. --->
			<cfinclude  template="missingTemplate.cfm">
			<cfreturn true />
			
			<cfcatch>
				<cfreturn false />
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>
