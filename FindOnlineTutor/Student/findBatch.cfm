<!---
Project Name: FindOnlineTutor.
File Name: findBatch.cfm.
Created In: 26th Apr 2020
Created By: Rajendra Mishra.
Functionality: It is a cfm file helps to find batches using some filtering options.
--->
<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css">

<div class="container">
<h1>Find Batches of your prefereneces....</h1>
<cfset batchServiceObj = createObject("component","FindOnlineTutor.Components.batchService")/>
<cfset myNearBatches = batchServiceObj.getNearByBatch()/>
<cfdump  var="#myNearBatches#">
<!--- <cfdump  var="#batch.getNearByBatch("#left(myCurrentAddress.Address.PINCODE[1],3)#")#"/> --->
</div>
</cf_header>