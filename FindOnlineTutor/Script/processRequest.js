/*
Project Name: FindOnlineTutor.
File Name: processRequest.js.
Created In: 29th Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file for processing requests
*/

$(document).ready(function(){
    
});

function updateRequest(id,element)
{
    var status;
    if($(element).text()=="Approve")
    {
        status = "Approved";
    }
    else if($(element).text()=="Reject")
    {
        status = "Rejected";
    }
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=updateBatchRequest",
        cache: false,
        timeout: 2000,
        error: function(){
            swal({
                title: "Failed to retrieve the Batches",
                text: "Some error occured. Please try after sometime.",
                icon: "error",
                button: "Ok",
            });
        },
        data:{
                "batchRequestId" : id,
                "requestStatus" : status
            },
        success: function(returnData) {
            returnData=JSON.parse(returnData);
            if(returnData.hasOwnProperty("error"))
            {
                swal({
                    title: "Error",
                    text: returnData.error,
                    icon: "error",
                    button: "Ok",
                });
            }
            else 
            {
                setTimeout(function(){ window.location.reload(true) },2000);
            }
        } 
    });
}