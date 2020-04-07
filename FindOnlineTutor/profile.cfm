<cf_header homeLink="index.cfm" logoPath="Images/logo.png" stylePath="Styles/style.css" scriptPath="Script/loginFormValidation.js">

<cfif structKeyExists(session, "stLoggedInUser")>
    <div class="container center-container bg-light" style="margin-top:50px">
		
   	</div>

<cfelse>
    <cflocation  url="/assignments_mindfire/FindOnlineTutor"/>
</cfif>