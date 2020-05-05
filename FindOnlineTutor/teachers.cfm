<!---
Project Name: FindOnlineTutor.
File Name: teachers.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the teacher overview and a link for teacher's details
--->

<cfset databaseServiceObj = createObject("component","FindOnlineTutor.Components.databaseService")/>
<cfset getTeacherInfo = databaseServiceObj.getTeacher(isTeacher=1)/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">
<div class="container">
    <cfif structKeyExists(getTeacherInfo, "error")>
        <!---display error msg--->
    <cfelseif structKeyExists(getTeacherInfo, "user")>
        <div class="row">
            <cfoutput query="getTeacherInfo.user">
                <cfinclude  template="Include/userOverview.cfm">
            </cfoutput>
        </div>
    </cfif>
</div>
</cf_header>