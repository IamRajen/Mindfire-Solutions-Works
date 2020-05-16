<footer class="page-footer font-small pt-4 bg-light">

    <!-- Footer Links -->
    <div class="container-fluid text-center text-md-left">

        <!-- Grid row -->
        <div class="row">

            <!-- Grid column -->
            <div class="col-md-6 mt-md-0 mt-3">
                <!-- Content -->
                <img  src="<cfoutput>#attributes.logoPath#</cfoutput>" class="img-fluid mr-2" alt="logo"/>
                <a class="navbar-brand text-dark" width="187" href="<cfoutput>#attributes.homeLink#</cfoutput>"><b>FindOnlineTutor</b></a>						
            </div>
            <cfset folderUp = ''/>
            <cfif listFind(cgi.script_name,'Teacher', '/') OR listFind(cgi.script_name,'Student', '/')>
                <cfset folderUp = '../'>
            </cfif>
            <div class="col-md-6 mt-3">
                <!-- contact -->
                <img class="my-1 mx-2 float-right" src="<cfoutput>#folderUp#</cfoutput>Images/facebook.png">
                <img class="my-1 mx-2 float-right" src="<cfoutput>#folderUp#</cfoutput>Images/instagram.png">
                <img class="my-1 mx-2 float-right" src="<cfoutput>#folderUp#</cfoutput>Images/linkedIn.png">
                <img class="my-1 mx-2 float-right" src="<cfoutput>#folderUp#</cfoutput>Images/skype.png">
                <img class="my-1 mx-2 float-right" src="<cfoutput>#folderUp#</cfoutput>Images/twitter.png">
                <img class="my-1 mx-2 float-right" src="<cfoutput>#folderUp#</cfoutput>Images/whatsapp.png">		
            </div>
            <div class="col-md-12 mt-3 px-5 text-center">
                <p class="p-4 text-secondary w-50 m-auto">
                    At Website.com, we believe everyone deserves to have a website or online store. 
                    Innovation and simplicity makes us happy: our goal is to remove any technical or 
                    financial barriers that can prevent business owners from making their own website. 
                    We're excited to help you on your journey!
                </p>
        
            </div>
            <!-- Grid column -->
        </div>
        <!-- Grid row -->
    </div>


    <!-- Copyright -->
    <div class="footer-copyright text-center py-3 border-top-50 text-secondary">© 2020 Copyright:
        <a class="text-secondary" href="https://192.168.43.32/assignments_mindfire/FindOnlineTutor/index.cfm"> FindOnlineTutor.com</a>
    </div>
    <!-- Copyright -->

</footer>