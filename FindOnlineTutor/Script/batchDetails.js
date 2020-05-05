
$(document).ready(function()
{
    $("#submitFeedback").click(function()
    {
        var batchId = $("#batchId").text();
        var feedback = $("#feedback").val();
        var rating = 4;
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
            data:{
                "batchId" : batchId,
                "feedback" : feedback,
                "rating" : rating
            },
            success: function(submitFeedbackInfo) 
            {   
                submitFeedbackInfo = JSON.parse(submitFeedbackInfo)
                if(submitFeedbackInfo.hasOwnProperty('ERROR'))
                {
                    //show error msg
                    swal({
                        title: "Failed to Submit!!",
                        text: submitFeedbackInfo.error,
                        icon: "error",
                        button: "Ok",
                    });
                }
                else if(submitFeedbackInfo.hasOwnProperty('INSERTFEEDBACK') && submitFeedbackInfo.INSERTFEEDBACK)
                {
                    //refresh the feedback column
                    swal({
                        title: "Successfully Submitted!!",
                        text: "successfully submitted your feedback",
                        icon: "success",
                        button: "Ok",
                    });
                    $("#feedback").val('');
                    retrieveFeedback();
                }
            }
        });
    });
    retrieveFeedback();
});

function retrieveFeedback()
{
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=retrieveBatchFeedback",
        cache: false,
        timeout: 2000,
        error: function(){
            swal({
                title: "Failed to retrieve the Feedbacks!!",
                text: "Some error occured. Please try after sometime",
                icon: "error",
                button: "Ok",
            });
        },
        data:{
            "batchId" : $("#batchId").text()
        },
        success: function(feedbackInfo) 
        {   
            feedbackInfo = JSON.parse(feedbackInfo);
            console.log(feedbackInfo)
            if(feedbackInfo.hasOwnProperty("ERROR"))
            {

            }
            else if(feedbackInfo.FEEDBACK.DATA.length > 0)
            {
                var feedbacks = feedbackInfo.FEEDBACK.DATA;
                for(let feedback in feedbacks)
                {
                    var feedbackDiv = $($("#feedbackSection").children()[0]).clone();
                    if(feedback == 0)
                    {
                        $("#feedbackSection").empty();
                    }
                    $(feedbackDiv).removeClass('hidden')
                    $(feedbackDiv).find("#feedbackId").text(feedbacks[feedback][0]);
                    $(feedbackDiv).find("#feedback").text(feedbacks[feedback][3]);
                    $(feedbackDiv).find("#studentName").text(feedbacks[feedback][6]).attr('href',feedbacks[feedback][5]);
                    var feedbackDate = new Date(feedbacks[feedback][2]);
                    var date = ('0'+feedbackDate.getDate()).slice(-2);
                    var month = ('0'+feedbackDate.getMonth()).slice(-2);
                    var year = feedbackDate.getFullYear();
                    var hour = feedbackDate.getHours();
                    var minute = ('0'+feedbackDate.getMinutes()).slice(-2);
        
                    $(feedbackDiv).find("#feedbackDateTime").text(date+'-'+month+'-'+year+'  '+hour+':'+minute);
                    $("#feedbackSection").append(feedbackDiv)
                }
            }
        }
    });
}