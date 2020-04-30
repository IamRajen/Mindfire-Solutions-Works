/*
Project Name: FindOnlineTutor.
File Name: notification.js.
Created In: 30th Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file for all notification activities 
*/
var errorMsg = '<div class="alert alert-danger pt-3 pb-3 rounded-top">'+
                '<p class="text-center">Some error occured. Please try after sometime</p>'+
                '</div>'
var tableFormat = '<table class="table">'+
                    '<thead>'+
                        '<tr  class="bg-info">'+
                        '<th class="text-light" scope="col">No.</th>'+
                        '<th class="text-light" scope="col">Notification Title</th>'+
                        '<th class="text-light" scope="col">Batch</th>'+
                        '<th class="text-light" scope="col">Date</th>'+
                        '<th class="text-light" scope="col">Time</th>'+
                        '<th class="text-light" scope="col"></th>'+
                        '</tr>'+
                    '</thead>'+
                    '<tbody></tbody>'+
                '</table>'

$(document).ready(function()
{
    //an ajax call that will get all the notification...
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=getMyNotification",
        cache: false,
        timeout: 2000,
        error: function(){
            $(".container").empty();
            //display error msg
            $(errorMsg).appendTo($('.container'));
            swal({
                title: "Failed to Retrieve Notifiaction",
                text: "Some error occured. Please try after sometime",
                icon: "error",
                button: "Ok",
            });
            
        },
        success: function(notificationInfo) 
        {
            notificationInfo = JSON.parse(notificationInfo);
            if(notificationInfo.hasOwnProperty("ERROR"))
            {
                $(".container").empty();
                //display error msg
                $(errorMsg).appendTo($('.container'));
            }
            else if(notificationInfo.hasOwnProperty("NOTIFICATIONS"))
            {
                var notifications = notificationInfo.NOTIFICATIONS.DATA;
                $(tableFormat).appendTo($('.container'));
                var tbody = $(".container").find('tbody');
                console.log(tbody);
                for(let notification in notifications)
                {
                    var tr = $('tr');
                    if(notifications[notification][5] == true)
                    {
                        tr.addClass('font-weight-bold');
                    }
                    else{
                        tr.addClass('font-weight-light');
                    }
                    // var tdNotificationNumber =  $('td').addClass('text-capitalize').text(notification+1);
                    // var tdNotificationTitle = $('td').addClass('text-capitalize').text(notifications[notification][2]);
                    // var tdbatchName =  $('td').addClass('text-capitalize').text(notifications[notification][3]);
                    // var tdNotificationDate =  $('td').text(notifications[notification][1]);
                    // var tdNotificationTime =  $('td').text(notifications[notification][1]);
                    // var tdViewButton =  $('button').addClass('btn btn-success rounded px-3').text('View');
                    // var tdViewButtonSection = $('td').appendTo($(tdViewButton));
                    
                    // $(tdNotificationNumber,tdNotificationTitle,tdbatchName,tdNotificationDate,tdNotificationTime,tdViewButtonSection).appendTo(tr);

                    console.log(notifications[notification])
                    $(tr).appendTo($(tbody));

                    
                }
            }
            
        }
    });
});