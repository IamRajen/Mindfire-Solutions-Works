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

//all maps are declared here...!!
var inputOverview = new Map();

$(document).ready(function(){
    //initializing the batch overview fields..
    inputOverview.set("editBatchName",{id:"editBatchName", errorMsg:""});
    inputOverview.set("editBatchType",{id:"editBatchType", errorMsg:""});
    inputOverview.set("editBatchDetails",{id:"editBatchDetails", errorMsg:""});
    inputOverview.set("editBatchStartDate",{id:"editBatchStartDate", errorMsg:""});
    inputOverview.set("editBatchEndDate",{id:"editBatchEndDate", errorMsg:""});
    inputOverview.set("editBatchCapacity",{id:"editBatchCapacity", errorMsg:""});
    inputOverview.set("editBatchFee",{id:"editBatchFee", errorMsg:""});

    $("#editBatchModal").submit(function(e)
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
                    console.log(errorMsgs)
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
                            title: "Failed to create a BATCH!!",
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
                        setTimeout(function(){window.location.reload(true)},2000)
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

function loadBatchTiming() 
{
    //declaring the weekday array for creating the batch timing input fields..
    var weekDays = ["Monday","Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday", "Sunday"];
    for(var day=1; day<weekDays.length; day++)
    {
        var batchDayFields = $("#batchTimingDesign").clone();
        var dates = batchDayFields.find('input');
        var label = batchDayFields.find('label');
        
        $(dates[0]).attr({"id":"startTime"+day});
        $(dates[1]).attr({"id":"endTime"+day});
        $(label).attr({"id":"label"+weekDays[day]});
        $(label).text(weekDays[day]);

        $("#editBatchTimingModelBody").append(batchDayFields);
    }
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
            console.log((batchTiming.TIME[0]))
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
                // for(var data in batchTiming.TIME)
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

//validaton fucntions 
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
