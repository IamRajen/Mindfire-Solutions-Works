
$(document).ready(function()
{
    $("#submitFeedback").click(function()
    {
        console.log("hello")
        $.ajax({
            type:"POST",
            url:"../Components/batchService.cfc?method=submitFeedback",
            cache: false,
            timeout: 2000,
            error: function(){
                swal({
                    title: "Failed to retrieve the Notification details!!",
                    text: "Some error occured. Please try after sometime",
                    icon: "error",
                    button: "Ok",
                });
            },
            success: function(error) 
            {
                console.log(error);
            }
        });
    });
});