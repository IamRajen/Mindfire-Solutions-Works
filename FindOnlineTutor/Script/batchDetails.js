
$(document).ready(function()
{
    $("#submitFeedback").click(function()
    {
        var batchId = $("#batchId").text();
        var feedback = $("#feedback").val();
        var rating = 4;
        if($.trim(feedback) == '')
        {   
            return;
        }
        $.ajax({
            type:"POST",
            url:"../Components/batchService.cfc?method=submitFeedback",
            cache: false,
            timeout: 2000,
            error: function(){
                swal({
                    title: "Error",
                    text: "Some server error occurred. Please try after sometimes while we fix it.",
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
                submitFeedbackInfo = JSON.parse(submitFeedbackInfo);
                if(submitFeedbackInfo.hasOwnProperty("ERROR"))
                {
                    swal({
                        title: "Error",
                        text: submitFeedbackInfo.ERROR,
                        icon: "error",
                        button: "Ok",
                    });
                }
                else if(submitFeedbackInfo.validatedSuccessfully == false)
                {
                    $("#feedback").next().text(submitFeedbackInfo.feedback);
                }
                else if(submitFeedbackInfo.hasOwnProperty('key'))
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
                title: "Error",
                text: "Some server error occurred. Please try after sometimes while we fix it.",
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
            if(feedbackInfo.hasOwnProperty("ERRORR"))
            {
                $("#feedbackSection").empty();
                $("#feedbackSection").append('<p class="py-3 m-3 alert alert-danger tezt-center w-100">'+feedbackInfo.ERROR+'</p>');
            }
            else if(feedbackInfo.FEEDBACKS.DATA.length > 0)
            {
                var feedbacks = feedbackInfo.FEEDBACKS.DATA;
                for(let feedback in feedbacks)
                {
                    var feedbackDiv = $($("#feedbackSection").children()[0]).clone();
                    if(feedbackDiv.length == 0)
                    {
                        window.location.reload(true);
                    }
                    if(feedback == 0)
                    {
                        $("#feedbackSection").empty();
                    }
                    $(feedbackDiv).removeClass('hidden')
                    $(feedbackDiv).find("#feedbackId").text(feedbacks[feedback][0]);
                    $(feedbackDiv).find("#feedback").text(feedbacks[feedback][3]);
                    $(feedbackDiv).find("#studentName").text(feedbacks[feedback][6]).attr('href',"../userDetails.cfm?user="+feedbacks[feedback][5]);
                    var feedbackDate = new Date(feedbacks[feedback][2]);
                    var date = ('0'+feedbackDate.getDate()).slice(-2);
                    var month = ('0'+feedbackDate.getMonth()).slice(-2);
                    var year = feedbackDate.getFullYear();
                    var hour = feedbackDate.getHours();
                    var minute = ('0'+feedbackDate.getMinutes()).slice(-2);
        
                    $(feedbackDiv).find("#feedbackDateTime").text(date+'-'+month+'-'+year+'  '+hour+':'+minute);
                    $("#feedbackSection").append(feedbackDiv);
                }
            }
        }
    });
}

// function loadNotification(element)
// {
//     $('#viewBatchNotificationModal').modal();
    
//     var notificationId = $(element).find('p')[0];
//     $.ajax({
//         type:"POST",
//         url:"../Components/batchService.cfc?method=getNotificationById",
//         cache: false,
//         timeout: 2000,
//         error: function(){
//             swal({
//                 title: "Error",
//                 text: "Some server error occurred. Please try after sometimes while we fix it.",
//                 icon: "error",
//                 button: "Ok",
//             });
//         },
//         data:{
//                 "batchNotificationId" : $(notificationId).text()
//             },
//         success: function(error) 
//         {
//             var notificationInfo = JSON.parse(error);
//             if(notificationInfo.hasOwnProperty("error"))
//             {
//                 //error msg will be displayed 
//             }
//             else
//             {
//                 $("#viewNotificationId").text(notificationInfo.NOTIFICATION.DATA[0][0])
//                 $("#viewNotificationTitle").text(notificationInfo.NOTIFICATION.DATA[0][3]);
//                 $("#viewNotificationDateTime").text(notificationInfo.NOTIFICATION.DATA[0][2]);
//                 $("#viewNotificationDetails").text(notificationInfo.NOTIFICATION.DATA[0][4]);
//             }
//         }
//     });

// }
