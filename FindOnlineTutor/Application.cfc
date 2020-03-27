<cfcomponent output="false">
	<cfset this.name = 'FindOnlineTutor' />
	<cfset this.applicationTimeout = createtimespan(0,2,0,0) />
	<cfset this.datasource = 'FindingTutor' />
<!--- 	<cfset this.customTagPaths = expandPath('/final/customTags') /> --->
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimespan(0,0,30,0) />

	<!---OnApplicationStart() method--->
	<cffunction name="onApplicationStart" returntype="boolean" >
<<<<<<< HEAD
		<cfset application.utils = CreateObject("component","FindOnlineTutor.Components.utils") />
		<cfset application.validation = createObject("component", "FindOnlineTutor.Components.validation")>

=======
		<cfset application.utils = CreateObject("component",'FindOnlineTutor.Components.utils') />
>>>>>>> f9497468d2b0b926214d297d7b6fe90a950c8a63
		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" >
		<cfargument name="targetPage" type="string" required="true" />
		<!---handle some special URL parameters--->
		<cfif isDefined('url.restartApp')>
			<cfset this.onApplicationStart() />
		</cfif>
		<!---Implement ressource Access control for the 'admin' folder--->
		<cfreturn true />
	</cffunction>
	
</cfcomponent>
