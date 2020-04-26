/*
Project Name: FindOnlineTutor.
File Name: editBatchDetails.js.
Created In: 20th Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file helps to edit the batch information like timing, overview, notification, requests..etc 
*/

//pattern variable declared here
var patternName=/^[A-Za-z ]+$/;
var patternNumber=/^[0-9]+$/;
var patternText=/^[ A-Za-z0-9_@./&+:-]*$/;
var patternTime = /^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])$/;
var patternLink = /^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$/;

//all maps are declared here...!!
var inputOverview = new Map();
var inputTiming = new Map();

$(document).ready(function(){
    //initializing the batch overview fields..
    inputOverview.set("editBatchName",{id:"editBatchName", errorMsg:""});
    inputOverview.set("editBatchType",{id:"editBatchType", errorMsg:""});
    inputOverview.set("editBatchDetails",{id:"editBatchDetails", errorMsg:""});
    inputOverview.set("editBatchStartDate",{id:"editBatchStartDate", errorMsg:""});
    inputOverview.set("editBatchEndDate",{id:"editBatchEndDate", errorMsg:""});
    inputOverview.set("editBatchCapacity",{id:"editBatchCapacity", errorMsg:""});
    inputOverview.set("editBatchFee",{id:"editBatchFee", errorMsg:""});

    
    $("#editBatchOverview").submit(function(e)
    {
        e.preventDefault();
        var successfullyValidated=true;
        //client-side validation starts here
        for(var key of inputOverview.keys())
        {
            if(inputOverview.get(key).errorMsg)
            {
                setErrorBorder(inputOverview.get(key));
                successfullyValidated=false;
            }
        }

        if(successfullyValidated)
        {
            //ajax call be made for updating the database
            $.ajax({
                type:"POST",
                url:"../Components/batchService.cfc?method=updateBatch",
                cache: false,
                timeout: 2000,
                error: function(){
                    swal({
                        title: "Failed to retrieve the batch details!!",
                        text: "Some error occured. Please try after sometime",
                        icon: "error",
                        button: "Ok",
                    });
                },
                data:{
                        "batchId":parseInt($("#batchId").text()),
                        "editBatchName":$("#editBatchName").val(),
                        "editBatchType": $('input[name="editBatchType"]:checked').val(),
                        "editBatchDetails": $("#editBatchDetails").val(),
                        "editBatchStartDate": $("#editBatchStartDate").val(),
                        "editBatchEndDate": $("#editBatchEndDate").val(),
                        "editBatchCapacity": $("#editBatchCapacity").val(),
                        "editBatchFee": $("#editBatchFee").val()
                    },
                success: function(error) 
                {
                    errorMsgs=JSON.parse(error);
                    if(!errorMsgs.validatedSuccessfully)
                    {
                        //validation error msg..
                        for(var key in errorMsgs) 
                        {
                            if(errorMsgs[key].hasOwnProperty("MSG"))
                            {
                                inputOverview.get(key).errorMsg=errorMsgs[key]["MSG"];
                                setErrorBorder(inputOverview.get(key));
                            } 
                        }
                        swal({
                            title: "Failed to update the BATCH!!",
                            text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                            icon: "error",
                            button: "Ok",
                        });
                    }
                    else if(errorMsgs.hasOwnProperty('error') && !errorMsgs.error)
                    {
                        //some server error occurred msg..
                        swal({
                            title: "Failed to Update Batch!!",
                            text: "Unable to update the batch. Please, try after sometime!!",
                            icon: "error",
                            button: "Ok",
                        });
                    }
                    else if(errorMsgs.updatedSuccessfully)
                    {
                        //updated successfully msg will be displayed...
                        swal({
                            title: "Successfully Updated",
                            text: "Batch: "+$("#editBatchName").val(),
                            icon: "success",
                            buttons: false,
                        })
                        setTimeout(function(){window.location.reload(true)},2000);
                    }
                    
                }
            });
        }
    });

    $("#editBatchTiming").submit(function(e)
    {
        e.preventDefault();
        var successfullyValidated=true;
        //client-side validation starts here
        for(var key of inputTiming.keys())
        {
            //if the starttime has a time but endtime doesn't
            if(key.slice(4,9)=="Start" && $("#"+key).val() && $("#editEndTime"+key.slice(-1)).val()=="")
            {   
                inputTiming.get("editEndTime"+key.slice(-1)).errorMsg="Must also have the end time or you can keep both blank.";
                setErrorBorder(inputTiming.get("editEndTime"+key.slice(-1)));
                successfullyValidated=false;
            }
            //if the end time has a time but start time doesn't
            else if(key.slice(4,7)=="End" && $("#"+key).val() && $("#editStartTime"+key.slice(-1)).val()=="")
            {
                inputTiming.get("editStartTime"+key.slice(-1)).errorMsg="Must also have the start time or you can keep both blank.";
                setErrorBorder(inputTiming.get("editStartTime"+key.slice(-1)));
                successfullyValidated=false;
            }
            //if the end time has a time is less than start time
            else if($("#editEndTime"+key.slice(-1)).val() < $("#editStartTime"+key.slice(-1)).val())
            {
                inputTiming.get("editEndTime"+key.slice(-1)).errorMsg="End time must be greater than start time";
                setErrorBorder(inputTiming.get("editEndTime"+key.slice(-1)));
                successfullyValidated=false;
            }
            //if both the start and end time doesn't have any data..
            else if($("#editEndTime"+key.slice(-1)).val()=="" && $("#editStartTime"+key.slice(-1)).val()=="")
            {
                setSuccessBorder(inputTiming.get("editStartTime"+key.slice(-1)));
                setSuccessBorder(inputTiming.get("editEndTime"+key.slice(-1)));
            } 
            
        }

        if(successfullyValidated)
        {
            //ajax call be made for updating the database
            $.ajax({
                type:"POST",
                url:"../Components/batchService.cfc?method=updateBatchTiming",
                cache: false,
                timeout: 2000,
                error: function(){
                    swal({
                        title: "Failed to retrieve the batch details!!",
                        text: "Some error occured. Please try after sometime",
                        icon: "error",
                        button: "Ok",
                    });
                },
                data:{
                        "batchId" :   parseInt($("#batchId").text()),
                        "Monday" :    JSON.stringify({"startTime":$("#editStartTime0").val(), "endTime":$("#editEndTime0").val(), "batchTimingId":inputTiming.get("editStartTime0").batchTimingId}),
                        "Tuesday" :   JSON.stringify({"startTime":$("#editStartTime1").val(), "endTime":$("#editEndTime1").val(), "batchTimingId":inputTiming.get("editStartTime1").batchTimingId}),
                        "Wednesday" : JSON.stringify({"startTime":$("#editStartTime2").val(), "endTime":$("#editEndTime2").val(), "batchTimingId":inputTiming.get("editStartTime2").batchTimingId}),
                        "Thrusday" :  JSON.stringify({"startTime":$("#editStartTime3").val(), "endTime":$("#editEndTime3").val(), "batchTimingId":inputTiming.get("editStartTime3").batchTimingId}),
                        "Friday" :    JSON.stringify({"startTime":$("#editStartTime4").val(), "endTime":$("#editEndTime4").val(), "batchTimingId":inputTiming.get("editStartTime4").batchTimingId}),
                        "Saturday" :  JSON.stringify({"startTime":$("#editStartTime5").val(), "endTime":$("#editEndTime5").val(), "batchTimingId":inputTiming.get("editStartTime5").batchTimingId}),
                        "Sunday" :    JSON.stringify({"startTime":$("#editStartTime6").val(), "endTime":$("#editEndTime6").val(), "batchTimingId":inputTiming.get("editStartTime6").batchTimingId})
                    },
                success: function(error) 
                {
                    var errorMsgs = JSON.parse(error);
                    // if validation fails the error msgs should be shown to the required fields
                    if(!errorMsgs["validatedSuccessfully"])
                    {
                        delete errorMsgs["validatedSuccessfully"];
                        //loop over the json object for error msgs
                        for(var key in errorMsgs) 
                        {
                            if(errorMsgs[key].hasOwnProperty("endTime"))
                            {
                                inputTiming.get("editEndTime"+key).errorMsg=errorMsgs[key]["endTime"];
                                setErrorBorder(inputTiming.get("editEndTime"+key));
                            }
                            if(errorMsgs[key].hasOwnProperty("startTime"))
                            {
                                
                                inputTiming.get("editStartTime"+key).errorMsg=errorMsgs[key]["startTime"];
                                setErrorBorder(inputTiming.get("editStartTime"+key));
                            }
                        }
                        swal({
                            title: "Failed to update the BATCH Timing!!",
                            text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                            icon: "error",
                            button: "Ok",
                        });
                    }
                    //if the validation is done successfully but failed to update the timing
                    else if(!errorMsgs.COMMIT)
                    {
                        swal({
                            title: "Failed to update the BATCH Timing!!",
                            text: "Some internal problem occurred. Please, try after sometimes.",
                            icon: "error",
                            button: "Ok",
                        });
                    }
                    // if successfully updated 
                    else if(errorMsgs.COMMIT)
                    {
                        swal({
                            title: "Successfully Updated!!",
                            text: "The batch timing has been successfully updated.",
                            icon: "success",
                            button: "Ok",
                        });
                        setTimeout(function(){window.location.reload(true)},2000);
                    }
                    
                }
            });
        }
    });

    $("#addBatchNotification").submit(function(e){
        e.preventDefault();
        var successfullyValidated = true;
        if(!isValidPattern($("#notificationTitle").val(), patternText) || $("#notificationTitle").val().length==0)
        {   
            $("#notificationTitle").next().text("Mandatory field and Should contain only alphanumeric characters and [_@./&:+-] symbols.");
            $("#notificationTitle").css({"border-color": "#CD5C5C", "border-width":"2px"});
            successfullyValidated = false;
        }
        else if($("#notificationTitle").val().length > 20)
        {
            $("#notificationTitle").next().text("Field should not contain more than 20 characters");
            $("#notificationTitle").css({"border-color": "#CD5C5C", "border-width":"2px"});
            successfullyValidated = false;
        }
        else 
        {
            $("#notificationTitle").css({"border-color": "#ddd", "border-width":"1px"});
            $("#notificationTitle").next().text("");
            successfullyValidated = true;
        }
        if(!isValidPattern($("#notificationDetails").val(), patternText) || $("#notificationDetails").val().length==0)
        {   
            $("#notificationDetails").next().text("Mandatory field and Should contain only alphanumeric characters and [_@./&:+-] symbols.");
            $("#notificationDetails").css({"border-color": "#CD5C5C", "border-width":"2px"});
            successfullyValidated = false;
        }
        else if($("#notificationDetails").val().length > 200)
        {
            $("#notificationDetails").next().text("Field should not contain more than 200 characters");
            $("#notificationDetails").css({"border-color": "#CD5C5C", "border-width":"2px"});
            successfullyValidated = false;
        }
        else 
        {
            $("#notificationDetails").css({"border-color": "#ddd", "border-width":"1px"});
            $("#notificationDetails").next().text("");
            successfullyValidated = true;
        }

        if(successfullyValidated)
        {
            //an ajax call will be initiated for insertion of notification...
            $.ajax({
                type:"POST",
                url:"../Components/batchService.cfc?method=addNotification",
                cache: false,
                timeout: 2000,
                error: function(){
                    swal({
                        title: "Failed to insert new notification!!",
                        text: "Some error occured. Please try after sometime",
                        icon: "error",
                        button: "Ok",
                    });
                },
                data:{
                        "batchId":parseInt($("#batchId").text()),
                        "notificationTitle" : $("#notificationTitle").val(),
                        "notificationDetails" : $("#notificationDetails").val(),
                    },
                success: function(error) 
                {
                    var errorMsg = JSON.parse(error);
                    if(!errorMsg["validatedSuccessfully"])
                    {
                        delete errorMsgs["validatedSuccessfully"];
                        for(var key in errorMsgs) 
                        {
                            if(errorMsgs[key]!='')
                            {
                                $("#"+key).next().text(errorMsg[key]);
                                $("#"+key).css({"border-color": "#CD5C5C", "border-width":"2px"});
                            }
                        }
                    }
                    else if(errorMsg.hasOwnProperty("insertion"))
                    {
                        if(errorMsg["insertion"])
                        {
                            //if inserted successfully
                            swal({
                                title: "Created Successfully!!",
                                text: "Notification has been successfully created",
                                icon: "success",
                                button: "Ok",
                            });
                            setTimeout(function(){window.location.reload(true)},2000); 
                        }
                        else 
                        {
                            //if inserted fails
                            swal({
                                title: "Failed!!",
                                text: "Failed to create the notification.Some error occured. Please try after sometime",
                                icon: "error",
                                button: "Ok",
                            });
                        }

                    }
                }
            });
        }
        
    });
});

//function to retrieve the batch overview data...
function loadBatchOverview() 
{
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=getBatchOverviewById",
        cache: false,
        timeout: 2000,
        error: function(){
            swal({
                title: "Failed to retrieve the batch details!!",
                text: "Some error occured. Please try after sometime",
                icon: "error",
                button: "Ok",
            });
        },
        data:{
                "batchId" : $("#batchId").text()
            },
        success: function(error) 
        {
            //initializing the overview data and timing data of batch
            var batchOverView = JSON.parse(error);

            //if successfully overview is retrieved then the batch edit model will be initialized by respective data..
            if(batchOverView.hasOwnProperty("BATCH"))
            {
                $("input[name=editBatchType][value=" + batchOverView.BATCH.DATA[0][2] + "]").prop('checked', true);
                $("#editBatchName").val(batchOverView.BATCH.DATA[0][3]);
                $("#editBatchDetails").val(batchOverView.BATCH.DATA[0][4]);
                $("#editBatchCapacity").val(batchOverView.BATCH.DATA[0][7]);
                $("#editBatchFee").val(batchOverView.BATCH.DATA[0][9]);   
                
                //getting the startdate and converting it into HTML date format ..
                var startDate = new Date(batchOverView.BATCH.DATA[0][5]);
                var day = ("0" + startDate.getDate()).slice(-2);
                var month = ("0" + (startDate.getMonth() + 1)).slice(-2);
                startDate = startDate.getFullYear()+"-"+(month)+"-"+(day) ;
                $("#editBatchStartDate").val(startDate);

                //getting the enddate and converting it into HTML date format ..
                var endDate = new Date(batchOverView.BATCH.DATA[0][6]);
                var day = ("0" + endDate.getDate()).slice(-2);
                var month = ("0" + (endDate.getMonth() + 1)).slice(-2);
                endDate = endDate.getFullYear()+"-"+(month)+"-"+(day) ;
                $("#editBatchEndDate").val(endDate);
            }
            //else if some error occurred an alert will be displayed...
            else if(batchOverView.hasOwnProperty("ERROR"))
            {
                $("#editBatchOverviewModelBody").hide();
                $("#editBatchOverviewfooter").hide();
                $("#errorEditBatchDetails").show();
                $("#errorEditBatchDetails").children('p').text(batchOverView.ERROR);
            }
        }
    });
}
//function to retrieve the batch timing data...
function loadBatchTiming() 
{
    //declaring the weekday array for creating the batch timing input fields..
    var weekDays = ["Monday","Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday", "Sunday"];
    $("#editBatchTimingModelBody").empty();
    //loop which create 7 different dynamic field for timing of batch
    for(var day=0; day<weekDays.length; day++)
    {
        var dayDiv= '<label class="d-block text-center" class="control-label">'+weekDays[day]+'</label>'+
                '<div class="row m-3 p-2 border-buttom ">'+
                    '<div class="col-md-6">'+
                        '<label class="text-info" class="control-label" >Start Time:<span class="text-danger">*</span></label>'+
                        '<input class="form-control" type="time" id="editStartTime'+day+'" onblur="checkTime(this)">'+
                        '<span class="text-danger small float-left"></span>'+
                    '</div>'+
                    '<div class="col-md-6">'+
                        '<label class="text-info" class="control-label">End Time:<span class="text-danger">*</span></label>'+
                        '<input class="form-control" type="time" id="editEndTime'+day+'"  onblur="checkTime(this)">'+
                        '<span class="text-danger small float-left"></span>'+
                    '</div>'+
                '</div>'

        $("#editBatchTimingModelBody").append(dayDiv);

        //creating the map values for batch timing..
        inputTiming.set("editStartTime"+day, {id: "editStartTime"+day , errorMsg:"", batchTimingId:""});
        inputTiming.set("editEndTime"+day, {id: "editEndTime"+day , errorMsg:"", batchTimingId:""});
        
    }
    // ajax call to retrieve the timing data and fixing it to the respective places...
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=getBatchTimingById",
        cache: false,
        timeout: 2000,
        error: function(){
            swal({
                title: "Failed to retrieve the batch Timing!!",
                text: "Some error occured. Please try after sometime",
                icon: "error",
                button: "Ok",
            });
        },
        data:{
                "batchId" : $("#batchId").text()
            },
        success: function(error) 
        {
            var batchTiming = JSON.parse(error);
            if(batchTiming.hasOwnProperty("ERROR"))
            {
                //show the error msgs occurred while the retrieval if batch timing...
                $("#editBatchTimingModelBody").hide();
                $("#editBatchTimingfooter").hide();
                $("#errorEditBatchTiming").show();
                $("#errorEditBatchTiming").children('p').text(batchTiming.ERROR);
            }
            else
            {
                //setting the batch times as per the days
                for(var data in batchTiming.TIME)
                {
                    if((batchTiming.TIME[data][weekDays[data]]).hasOwnProperty("BATCHID"))
                    {
                        var startTime = new Date(batchTiming.TIME[data][weekDays[data]].STARTTIME);
                        var endTime = new Date(batchTiming.TIME[data][weekDays[data]].ENDTIME);
                        
                        var time =("0"+startTime.getHours()).slice(-2)+":"+("0"+startTime.getMinutes()).slice(-2);
                        $("#editStartTime"+(data)).val(time);
                        time =("0"+endTime.getHours()).slice(-2)+":"+("0"+endTime.getMinutes()).slice(-2);
                        $("#editEndTime"+(data)).val(time);
                        inputTiming.get("editStartTime"+data).batchTimingId = batchTiming.TIME[data][weekDays[data]].BATCHTIMINGID;
                        inputTiming.get("editEndTime"+data).batchTimingId = batchTiming.TIME[data][weekDays[data]].BATCHTIMINGID;
                    }
                    else 
                    {
                        $("#editStartTime"+data).val("");
                        $("#editEndTime"+data).val("");
                    }
                }
            }
        }
    });
}

function loadNotification(element)
{
    $('#viewBatchNotificationModal').modal();
    
    var notificationId = $(element).find('p')[0];
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=getNotificationById",
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
                "batchNotificationId" : $(notificationId).text()
            },
        success: function(error) 
        {
            var notificationInfo = JSON.parse(error);
            if(notificationInfo.hasOwnProperty("error"))
            {
                //error msg will be displayed 
            }
            else
            {
                $("#viewNotificationId").text(notificationInfo.NOTIFICATION.DATA[0][0])
                $("#viewNotificationTitle").text(notificationInfo.NOTIFICATION.DATA[0][3]);
                $("#viewNotificationDateTime").text(notificationInfo.NOTIFICATION.DATA[0][2]);
                $("#viewNotificationDetails").text(notificationInfo.NOTIFICATION.DATA[0][4]);
            }
        }
    });

}

function deleteNotification(element)
{
    var notificationId = $(element).parent().next().find('p')[0];
    console.log($(notificationId).text())
    $.ajax({
        type:"POST",
        url:"../Components/batchService.cfc?method=deleteNotification",
        cache: false,
        timeout: 2000,
        error: function(){
            swal({
                title: "Failed to delete the Notification!!",
                text: "Some error occured. Please try after sometime",
                icon: "error",
                button: "Ok",
            });
        },
        data:{
                "batchNotificationId" : $(notificationId).text()
            },
        success: function(error) 
        {
            var deleteNotificationInfo = JSON.parse(error);
            if(deleteNotificationInfo.hasOwnProperty("error"))
            {
                swal({
                    title: "Failed to delete notifiaction!!",
                    text: "Unable to delete the notifiaction. Please, try after sometime!!",
                    icon: "error",
                    button: "Ok",
                });
            }
            else 
            {
                swal({
                    title: "Deleted Successfully",
                    text: "the notification is been successfully deleted",
                    icon: "success",
                    buttons: false,
                })
                //success message
                setTimeout(function(){window.location.reload(true)},2000); 
            }
        }
    });
}


//border work
function setErrorBorder(object)
{
    $("#"+object.id).css({"border-color": "#CD5C5C", "border-width":"2px"}); 
    $('#'+object.id).next().text(object.errorMsg);
}
function setSuccessBorder(object)
{
    $("#"+object.id).css({"border-color": "#ddd", "border-width":"1px"}); 
    object.errorMsg=""
    $('#'+object.id).next().text(object.errorMsg);
}
function isEmpty(object)
{
    if(!($.trim($("#"+object.id).val())))
    {
        object.errorMsg="Mandatory Fields";
        setErrorBorder(object);
        return true;
    }
    return false;
}
//function for valid pattern..
function isValidPattern(text,pattern)
{
    return pattern.test(text);
}

//validaton functions overview
function checkBatchName(element)
{
    var object= inputOverview.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    if(!isValidPattern($(element).val(),patternName))
    {
        object.errorMsg="Invalid Pattern. Should contain only alphabets and spaces."
        setErrorBorder(object);
        return;
    }
    if($(element).val().length>20)
    {   
        object.errorMsg="Batch name should be less than 20 characters long.";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}

function checkBatchDetails(element)
{
    var object= inputOverview.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    if(!isValidPattern($(element).val(),patternText))
    {
        object.errorMsg="Invalid Pattern. Should contain only alphanumeric characters and [_@./&:+-] symbols."
        setErrorBorder(object);
        return;
    }
    if($(element).val().length>300)
    {   
        object.errorMsg="Batch details should be less than 300 characters long.";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}

function checkDate(element)
{
    var object=inputOverview.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    var today = new Date();
    var enteredDate = new Date($(element).val());
    if(enteredDate<today)
    {
        object.errorMsg="Date should be more than today`s date";
        setErrorBorder(object);
        return;
    }    
    if($("#batchStartDate").val()!=null && $("batchEndDate").val()!=null)
    {
        var startDate = new Date($("#batchStartDate").val());
        var endDate = new Date($("#batchEndDate").val());

        if(startDate > endDate)
        {
            inputOverview.get("batchEndDate").errorMsg="End Date should not be less than Start Date";
            setErrorBorder(inputOverview.get("batchEndDate"));
            return;
        }
        else
        {
            setSuccessBorder(inputOverview.get("batchEndDate"));
            return;
        }
    }
    setSuccessBorder(object);
}

function checkCapacityFee(element)
{
    var object=inputOverview.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    if(!isValidPattern($(element).val(), patternNumber))
    {
        object.errorMsg="Should contain only numbers";
        setErrorBorder(object);
        return;
    }
    if(element.id=="batchCapacity" && parseInt($(element).val())>30000 )
    {
        object.errorMsg="Capacity should not exceed 30000";
        setErrorBorder(object);
        return;
    }
    if(element.id=="batchFee" && parseInt($(element).val())>1000000 )
    {
        object.errorMsg="Fee should be less than 10Lacs";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}

function checkTime(element)
{
    var object = inputTiming.get(element.id);
    if(isEmpty(object))
    {
        setSuccessBorder(object);
        return;
    }
    if(!isValidPattern($(element).val(), patternTime))
    {   
        object.errorMsg="Invalid Time. Please type a valid time";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}

function updateBatchAddress(id)
{
    if($("#batchType").text() == 'online')
    {
        if(!isValidPattern($("#addressLink").val(),patternLink))
        {
            $("#addressLink").next().text("Invalid Link Address");
            $("#addressLink").css({"border-color": "#CD5C5C", "border-width":"2px"});
            return;
        }
        else 
        {
            $("#addressLink").css({"border-color": "#ddd", "border-width":"1px"});
            $("#addressLink").next().text("");
        }
        $.ajax({
            type:"POST",
            url:"../Components/batchService.cfc?method=updateBatchAddressLink",
            cache: false,
            timeout: 2000,
            error: function(){
                swal({
                    title: "Failed to update the batch address!!",
                    text: "Some error occured. Please try after sometime",
                    icon: "error",
                    button: "Ok",
                });
            },
            data:{
                    "batchId":parseInt($("#batchId").text()),
                    "addressLink":$("#addressLink").val(),
                },
            success: function(error) 
            {
                var updateInfo = JSON.parse(error);
                if(updateInfo.hasOwnProperty("error"))
                {
                    swal({
                        title: "Failed to update the batch address!!",
                        text: "Some error occured. Please try after sometime",
                        icon: "error",
                        button: "Ok",
                    });
                }
                else{
                    swal({
                        title: "successfully updated!!",
                        text: "Successfully updated the batch address",
                        icon: "success",
                        button: "Ok",
                    });
                    setTimeout(function(){window.location.reload(true)},2000);
                }
            }
        });
    }
    else if($("#batchType").text() == 'coaching')
    {
        //ajax call be made for updating the database
        $.ajax({
            type:"POST",
            url:"../Components/batchService.cfc?method=updateBatchAddressId",
            cache: false,
            timeout: 2000,
            error: function(){
                swal({
                    title: "Failed to update the batch address!!",
                    text: "Some error occured. Please try after sometime",
                    icon: "error",
                    button: "Ok",
                });
            },
            data:{
                    "batchId":parseInt($("#batchId").text()),
                    "addressId":$("#addressId").val(),
                },
            success: function(error) 
            {
                var updateInfo = JSON.parse(error);
                if(updateInfo.hasOwnProperty("error"))
                {
                    swal({
                        title: "Failed to update the batch address!!",
                        text: "Some error occured. Please try after sometime",
                        icon: "error",
                        button: "Ok",
                    });
                }
                else{
                    swal({
                        title: "successfully updated!!",
                        text: "Successfully updated the batch address",
                        icon: "success",
                        button: "Ok",
                    });
                    setTimeout(function(){window.location.reload(true)},2000);
                }
            }
        });
    }
}