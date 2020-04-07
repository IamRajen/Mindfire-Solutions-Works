<cfcomponent output="false">

    <cffunction  name="getMyProfile" access="public" output="false" returnformat="json" returntype="struct">
        <cfargument  name="userId" type="any" required="true"/>
        <cftry>
            <cfquery name="user">
                SELECT * 
                FROM [dbo].[User]
                WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_bigint" />
            </cfquery>
        <cfcatch type="database">
        </cfcatch>
        </cftry>
    </cffunction>

</cfcomponent>