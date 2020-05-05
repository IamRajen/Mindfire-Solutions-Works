<div class="col-sm-6 mt-3">
    <div class="border rounded shadow p-5">
        <p id="feedbackId" class="hidden">
            <cfoutput>
                #batchFeedbackId#
            </cfoutput>
        </p>
        <p id="feedback" class="d-block text-secondary text-center font-italic">
            <cfoutput>  
                #feedback#
            </cfoutput>    
        </p>
        <a href="userDetails.cfm?user="+<cfoutput>#userId#</cfoutput> id="studentName" class="d-block text-primary mt-3">
            <cfoutput>
                #student#
            </cfoutput>
        </a>
        <small id="feedbackDateTime" class="text-secondary mb-3">
            <cfoutput>
                #feedbackDateTime#
            </cfoutput>    
        </small>
    </div>
</div>