<!---
Project Name: FindOnlineTutor.
File Name: teachers.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the teacher overview and a link for teacher's details
--->

<cfset local.databaseServiceObj = createObject("component","FindOnlineTutor.Components.databaseService")/>
<cfset local.getUserInfo = local.databaseServiceObj.getUser(isTeacher = 1)/>

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">
<div class="container">
    <cfif isQuery(local.getUserInfo)>
        <div class="row">
            <cfoutput query="local.getUserInfo">
                <cfinclude  template="Include/userOverview.cfm">
            </cfoutput>
        </div>
    <cfelse>
        <p class="error-msg">Some Error occurred. Please try after sometimes</p>
    </cfif>
</div>
</cf_header>