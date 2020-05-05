<!---
Project Name: FindOnlineTutor.
File Name: teachersDetails.cfm.
Created In: 4th Apr 2020
Created By: Rajendra Mishra.
Functionality: A teacher page containing the detail information about the teacher
--->

<cfset databaseServiceObj = createObject("component","FindOnlineTutor.Components.databaseService")/>
<cfset teacherOverview = databaseServiceObj.getTeacher(userId=url.Id)/>
<cfset teacherBatch = databaseServiceObj.collectTeacherBatch(teacherId=url.Id)/>
<cfset teacherBatchFeedback = databaseServiceObj.retrieveTeacherFeedback(teacherId=url.id)/>

<cfdump  var="#teacherBatchFeedback#"/>
<!--- <cfdump var =  "#teacherOverview#"/> --->
<cfdump var = "#teacherBatch#">

<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css">
<div class="container">

    <cfoutput query="teacherOverview.user">
        <cfinclude  template="Include/userOverview.cfm">
    </cfoutput>

    <div class="p-5">
        <cfinclude  template="Include/address.cfm">
    </div>

    <div class="container horizontal-scrollable"> 
                <div class="row text-center"> 
                    <div class="col-xs-4">1</div> 
                    <div class="col-xs-4">2</div> 
                    <div class="col-xs-4">3</div> 
                    <div class="col-xs-4">4</div> 
                    <div class="col-xs-4">5</div> 
                    <div class="col-xs-4">6</div> 
                    <div class="col-xs-4">7</div> 
                </div> 
            </div> 

</cf_header>