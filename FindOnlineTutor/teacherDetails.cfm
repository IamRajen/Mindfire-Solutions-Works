<!---
Project Name: FindOnlineTutor.
File Name: teachersDetails.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the detail information about the teacher
--->

<cfset databaseServiceObj = createObject("component","FindOnlineTutor.Components.databaseService")/>
<cfset teacherOverview = databaseServiceObj.getTeacher(teacherId=url.Id)/>
<cfset teacherBatch = databaseServiceObj.collectTeacherBatch(teacherId=url.Id)/>
<cfset teacherBatchFeedback = databaseServiceObj.retrieveTeacherFeedback(teacherId=url.id)/>

<cfdump  var="#teacherBatchFeedback#"/>
<cfdump var =  "#teacherOverview#"/>
<!--- <cfdump var =  "#teacherAddress#" /> --->
<cfdump var = "#teacherBatch#">

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">
<div class="container">

    <cfoutput query="teacherOverview.TEACHERS">
        <cfinclude  template="Include/teacherOverview.cfm">
    </cfoutput>

    <div class="p-5">
        <cfinclude  template="Include/address.cfm">
    </div>

    
</div>

</cf_header>