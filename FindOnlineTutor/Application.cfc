<cfcomponent output="false">
	<cfset this.name = 'FindOnlineTutor' />
	<cfset this.applicationTimeout = createtimespan(0,2,0,0) />
	<cfset this.datasource = 'FindingTutor' />
<!--- 	<cfset this.customTagPaths = expandPath('/final/customTags') /> --->
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimespan(0,0,30,0) />

	<!---OnApplicationStart() method--->
	<cffunction name="onApplicationStart" returntype="boolean" >
<!--- 		<cfset application.pageService = createObject("component",'final.components.pageService') /> --->
<!--- 		<cfset application.eventsService = createObject("component",'final.components.eventsService') /> --->
<!--- 		<cfset application.newsService = createObject("component",'final.components.newsService') /> --->
<!--- 		<cfset application.userService = createObject("component",'final.components.userService') /> --->
<!--- 		<cfset application.commentsService = createObject("component",'final.components.commentsService') /> --->
		<cfset application.utils = CreateObject("component",'FindOnlineTutor.Components.utils') />

		<cfreturn true />
	</cffunction>
	
</cfcomponent>