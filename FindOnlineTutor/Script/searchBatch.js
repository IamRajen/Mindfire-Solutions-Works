/*
Project Name: FindOnlineTutor.
File Name: searchBatch.js.
Created In: 27th Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file helps the user to filter the batches and enroll for batches
*/

var countryMap=new Map();
var stateMap=new Map();

var batchFormat;

$(document).ready(function(){
    loadCountryStateMap();
    batchFormat = $($("#batchesDiv").children()[0]).clone();


    $("input[name=filterOption]").change(function()
    {
        //get the filterOption value and call the specified ajax function to get the batches and show the batches...
        var filterValue = $(this).val();
        if(filterValue == "batchesNearMe")
        {
            //call the ajax function for retriving the near by batches of logged in user
            makeAjaxCall(country=null,state=null);
            $("#batchCountry").hide();
            $("#batchStateDiv").hide();
        }
        else if(filterValue == "batchesInCountry" )
        {
            if($("#batchCountry").val()=="")
            {
                populateCountry();
                $("#batchCountry").show()
            }
            else{
                makeAjaxCall(country=countryMap.get(parseInt($("#batchCountry").val())),state=null);
            }
        }
        else if(filterValue == "batchesInState")
        {
            populateState();
            $("#batchState").show();
        }
    });

    $("#batchCountry").change(function(){
        if($("#batchCountry").val() && $("input[name=filterOption]:checked").val()=="batchesInCountry")
        {
            makeAjaxCall(country=countryMap.get(parseInt($("#batchCountry").val())),state=null);
        }
    });
    $("#batchState").change(function(){
        if($("#batchState").val() && $("input[name=filterOption]:checked").val()=="batchesInState")
        {
            makeAjaxCall(country=countryMap.get(parseInt($("#batchCountry").val())),state=stateMap.get($("#batchState").val()).name);
        }
    });
});

function makeAjaxCall(country ,state)
{
    //making an ajax call for retrieving the requests made by the user previously..
    $.ajax({
        type:"POST",
        url:"Components/batchService.cfc?method=getMyRequests",
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
        success: function(returnData) {
            
            var myRequestIds = new Map();
            returnData = JSON.parse(returnData);
            if(returnData.hasOwnProperty("error"))
            {
                swal({
                    title: "Failed to retrieve the Batches",
                    text: "Some error occured. Please try after sometime.",
                    icon: "error",
                    button: "Ok",
                });
            }
            else 
            {
                var data = returnData.REQUESTS.DATA;
                for(let request=0;request<data.length;request++)
                {
                    myRequestIds.set(data[request][1], data[request][3]);
                    sendRequest(myRequestIds,country ,state);
                }
            }  
        }
    });  
}

function sendRequest(myRequestIds,country ,state)
{
    $.ajax({
        type:"POST",
        url:"Components/batchService.cfc?method=getNearByBatch",
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
                "country" : country,
                "state" : state
            },
        success: function(returnData) {
            returnData=JSON.parse(returnData);
            if(returnData.hasOwnProperty("error"))
            {
                //display some error mSG
                var errorMsg = '<div class="alert alert-danger pt-3 pb-3 rounded-top">'+
                    '<p class="text-danger text-center">Some error occured while retrieving your batches. Please, try after sometime.</p>'+
                '</div>';
                $("#batchesDiv").empty();
                $(errorMsg).appendTo("#batchesDiv");
            }
            else
            {
                var isOldBatchCleared = false;
                var batches = (returnData.BATCH.DATA);
                $("#batchesDiv").empty();
                if(batches.length != 0)
                {
                    //looping the batches data and appending it into the required div
                    for(var batch in batches)
                    {
                        if(!isOldBatchCleared)
                        {
                            var data = batchFormat;
                            isOldBatchCleared=true
                        }
                        else 
                        {
                            var data = $($("#batchesDiv").children()[0]).clone();
                        } 
                        //checking the request info of the batch made by the user
                        
                        $(data).find('a').attr("href", "batchesDetails.cfm?id="+batches[batch][0]);
                        $(data).find('#batchName').html(batches[batch][1]);
                        $(data).find("#batchDetails").text(batches[batch][2]);
                        $(data).find("#batchAddress").text(batches[batch][3]+", "+batches[batch][4]+", "+batches[batch][5]+", "+batches[batch][6]+", "+batches[batch][7]);
                        var startDate = new Date(batches[batch][8]);
                        var endDate = new Date(batches[batch][9]);
                        $(data).find("#batchStartDate").text(startDate.getFullYear()+"-"+("0"+startDate.getMonth()).slice(-2)+"-"+("0"+startDate.getDate()).slice(-2));
                        $(data).find("#batchEndDate").text(endDate.getFullYear()+"-"+("0"+endDate.getMonth()).slice(-2)+"-"+("0"+endDate.getDate()).slice(-2));
                        $(data).find("#batchType").text(batches[batch][10]);
                        $(data).find("#batchFee").text(batches[batch][11]);
                        $(data).find("#batchCapacity").text(batches[batch][12]);
                        $(data).find("#batchEnrolled").text(batches[batch][13]);
                        $(data).find("#requestStatus").empty();
                        if( myRequestIds.has(batches[batch][0]) )
                        {
                            if( myRequestIds.get(batches[batch][0]) == "Pending" )
                            {
                                $('<button class="btn btn-success float-right d-inline rounded text-light shadow mx-1 disabled">Pending...</button>').appendTo($(data).find("#requestStatus"));
                            }
                            else if(myRequestIds.get(batches[batch][0]) == "Approved")
                            {
                                $('<small class="alert alert-success mt-2 text-success d-inline float-right p-1 px-2">Enrolled</small>').appendTo($(data).find("#requestStatus"));
                            }
                            else 
                            {
                                $('<button class="btn btn-success float-right d-inline rounded text-light shadow mx-1" onclick="enrollStudent(this)">Enroll</button>').appendTo($(data).find("#requestStatus"));
                            }
                        }
                        else 
                        {
                            $('<button class="btn btn-success float-right d-inline rounded text-light shadow mx-1" onclick="enrollStudent(this)">Enroll</button>').appendTo($(data).find("#requestStatus"));
                        }
                        $(data).appendTo("#batchesDiv");
                    }
                    if(country && !state)
                    {
                        $("#batchStateDiv").show();
                    }
                }
                else 
                {
                    var noDataMsg = '<div class="alert alert-info py-5 rounded">'+
                                        '<p class="text-md-center text-center">Sorry, we do not have any batches.</p>'+
                                    '</div>'
                    $(noDataMsg).appendTo("#batchesDiv");
                    console.log(state)
                    if(state == null)
                    {
                        $("#batchStateDiv").hide();
                    }
                }
            }
        }
    });
}

//populate country and state map
function loadCountryStateMap()
{
    $.getJSON('JsonFiles/countries.json',function(countries)
    { 
        for(let i=0; i<countries.length; i++)
        {
            countryMap.set(countries[i].id , countries[i].name);
        }
    });
    $.getJSON('JsonFiles/states.json',function(states)
    { 
        for(let i = 0; i < states.length; i++)
        {
            stateMap.set(states[i].id ,{"name":states[i].name,"countryId":states[i].country_id});
        }
    });    
}
//populate countries select input
function populateCountry()
{
    var countryOptions="<option value=''>-select country-</option>";
    for(var id of countryMap.keys())
    {
        countryOptions+="<option value='"+id+"'>"+countryMap.get(id)+"</option>";
    }
    $("#batchCountry").html(countryOptions);
}
//populate states on choosing country
function populateState()
{
    let stateOptions="";
    if($("#batchCountry").val())
    {
        stateOptions="<option value=''>-Select State-</option>";
        for(var id of stateMap.keys())
        {
            if(stateMap.get(id).countryId==$("#batchCountry").val())
            {
                stateOptions+="<option value='"+id+"'>"+stateMap.get(id).name+"</option>";
            }
        } 
    }
    $("#batchState").html(stateOptions);
}
//function to send request to particular batch
function enrollStudent(button)
{
    var index = $(button).parent().next().attr('href').indexOf("=");
    var batchId = $(button).parent().next().attr('href').slice(index+1);
    //sending request to batch via ajax call..
    $.ajax({
        type:"POST",
        url:"Components/batchService.cfc?method=makeRequest",
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
                "batchId" : batchId
            },
        success: function(returnData) {
            returnData=JSON.parse(returnData);
            console.log(returnData)
            if(returnData.hasOwnProperty("error"))
            {
                swal({
                    title: "Error",
                    text: returnData.error,
                    icon: "error",
                    button: "Ok",
                });
            }
            else if(returnData.hasOwnProperty("warning"))
            {
                swal({
                    title: "Warning",
                    text: returnData.warning,
                    icon: "warning",
                    button: "Ok",
                });
            }
            else 
            {
                $(button).text("Pending...").addClass("disabled");
            }
        } 
    });
}

