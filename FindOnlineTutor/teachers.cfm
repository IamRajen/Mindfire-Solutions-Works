<!---
Project Name: FindOnlineTutor.
File Name: teachers.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the teacher overview and a link for teacher's details
--->

<cfset databaseServiceObj = createObject("component","FindOnlineTutor.Components.databaseService")/>
<cfset getUserInfo = databaseServiceObj.getUser(isTeacher=1)/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">
<div class="container">
    <cfif structKeyExists(getUserInfo, "error")>
        <!---display error msg--->
    <cfelseif structKeyExists(getUserInfo, "user")>
        <div class="row">
            <cfoutput query="getUserInfo.user">
                <cfinclude  template="Include/userOverview.cfm">
            </cfoutput>
        </div>
    </cfif>
</div>
</cf_header>