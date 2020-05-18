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
var tableFormat = '<table class="table border">'+
                    '<thead>'+
                        '<tr class="bg-light border p-3">'+
                            '<th class="text-info" scope="col">No.</th>'+
                            '<th class="text-info" scope="col">Notification Title</th>'+
                            '<th class="text-info" scope="col">Batch</th>'+
                            '<th class="text-info" scope="col">Date</th>'+
                            '<th class="text-info" scope="col">Time</th>'+
                            '<th class="text-info" scope="col"></th>'+
                        '</tr>'+
                    '</thead>'+
                    '<tbody id="notifications">'+
                    '</tbody>'+
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
                // console.log(tbody);
                for(let notification in notifications)
                {
                    var tr = $('<tr></tr>');
                    if(notifications[notification][5] == true)
                    {
                        tr.addClass('font-weight-light');
                    }
                    else{
                        tr.addClass('font-weight-bold');
                    }
                    var tdNotificationNumber =  $('<td>').addClass('text-capitalize').text(1+parseInt(notification)+'.');
                    var tdNotificationTitle = $('<td>').attr('id',notifications[notification][0]).addClass('text-capitalize').text(notifications[notification][2]);
                    var tdbatchName =  $('<td>').addClass('text-capitalize').text(notifications[notification][3]);
                    var tdNotificationDate =  $('<td>').text(notifications[notification][1]);
                    var tdNotificationTime =  $('<td>').text(notifications[notification][1]);
                    var tdViewButton =  $('<button/>').attr({'id':notifications[notification][4], 'onClick':'getNotification(this)'}).addClass('btn button-color shadow rounded px-3 py-1').html("View");
                    var tdViewButtonSection = $('<td>').append(tdViewButton);
                    
                    $(tr).append(tdNotificationNumber,tdNotificationTitle,tdbatchName,tdNotificationDate,tdNotificationTime,tdViewButtonSection);
                    $(tr).appendTo($(tbody));
                }
            }
        }
    });
});

function getNotification(button)
{
    var notificationStatusId = $(button).attr('id');
    var notificationId = $(button).parent().siblings()[1].id;
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=getMyNotification",
        cache: false,
        timeout: 2000,
        error: function(){
            swal({
                title: "Failed to Retrieve Notifiaction",
                text: "Some error occured. Please try after sometime",
                icon: "error",
                button: "Ok",
            });
            
        },
        data:{
            "notificationStatusId" : notificationStatusId,
            "notificationId" : notificationId
        },
        success: function(notification) 
        {
            notification = JSON.parse(notification);
            if(notification.hasOwnProperty("ERROR"))
            {
                //display some error msg
            }
            else if(notification.hasOwnProperty("NOTIFICATION"))
            {
                var tRow = $(button).parent().parent();
                $(tRow).removeClass('font-weight-bold');
                $(tRow).removeClass('font-weight-light');
                $(tRow).addClass('font-weight-light');
                //display the model
                $("#notificationTitle").text(notification.NOTIFICATION.DATA[0][3])
                $("#notificationDateTime").text(notification.NOTIFICATION.DATA[0][2])
                $("#notificationDetail").text(notification.NOTIFICATION.DATA[0][4])

                $('#showNotification').modal('show');
            }
        }
    });
}