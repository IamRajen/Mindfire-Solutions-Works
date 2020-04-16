<cf_header homeLink="../index.cfm" logoPath="../Images/logo.png" stylePath="../Styles/style.css" scriptPath="../Script/batchValidation.js">

<cfif NOT structKeyExists(url, "id")>
	<cflocation  url="/assignments_mindfire/FindOnlineTutor">
</cfif>
<h1>Batch Detail</h1>

</cf_header>