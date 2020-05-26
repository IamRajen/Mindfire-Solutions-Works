/*
Project Name: FindOnlineTutor.
File Name: updateProfile.js.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file helps update the profile of user.
*/

var inputFieldsProfile=new Map();
var inputFieldsPhoneNumber=new Map();
var inputFieldsAddress=new Map();
var inputFieldsPassword=new Map();
var countryMap=new Map();
var stateMap=new Map();
var addressArray;

var patternName=/^[A-Za-z']+$/;
var patternEmail=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
var patternPhone=/^[^0-1][0-9]{9}$/;
var patternText=/^[a-zA-Z0-9\s,'-]*$/;
var patternPassword=/^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$/;
var patternPincode=/^[0-9]{6}$/;
var patternExperience=/^[0-9]+$/;


//document ready function
$(document).ready(function()
{
    //Adding submit button..
    $("#buttonUserDetailDiv").html($("<input>").attr({"id":"submitButton1","type":"submit","value":"UPDATE","name":"submitButton"}).addClass("btn btn-danger"));
    $("#buttonUserPhoneDetailDiv").html($("<input>").attr({"id":"submitButton2","type":"submit","value":"UPDATE","name":"submitButton"}).addClass("btn btn-danger"));
    $("#buttonUserAddressDetailDiv").html($("<input>").attr({"id":"submitButton3","type":"submit","value":"UPDATE","name":"submitButton"}).addClass("btn btn-danger"));
    $("#buttonUserInterestDetailDiv").html($("<input>").attr({"id":"submitButton3","type":"submit","value":"UPDATE","name":"submitButton"}).addClass("btn btn-danger px-auto"));
      
    
    //setting the inputfields keys and values..
    inputFieldsProfile.set("firstName",{id:"firstName", errorMsg:"", value:""});
    inputFieldsProfile.set("lastName",{id:"lastName", errorMsg:"", value:""});
    inputFieldsProfile.set("emailAddress",{id:"emailAddress", errorMsg:"", value:""});
    inputFieldsProfile.set("dob",{id:"dob", errorMsg:"", value:""});
    inputFieldsProfile.set("bio",{id:"bio", errorMsg:"", value:""});

    inputFieldsPhoneNumber.set("primaryPhoneNumber",{id:"primaryPhoneNumber", errorMsg:"", value:""});
    inputFieldsPhoneNumber.set("alternativePhoneNumber",{id:"alternativePhoneNumber", errorMsg:"", value:""});
    

    inputFieldsAddress.set("currentAddress",{id:"currentAddress", errorMsg:"", value:""});
    inputFieldsAddress.set("currentCountry",{id:"currentCountry", errorMsg:"", value:""});
    inputFieldsAddress.set("currentState",{id:"currentState", errorMsg:"", value:""});
    inputFieldsAddress.set("currentCity",{id:"currentCity", errorMsg:"", value:""});
    inputFieldsAddress.set("currentPincode",{id:"currentPincode", errorMsg:"", value:""});
    inputFieldsAddress.set("alternativeAddress",{id:"alternativeAddress", errorMsg:"", value:""});
    inputFieldsAddress.set("alternativeCountry",{id:"alternativeCountry", errorMsg:"", value:""});
    inputFieldsAddress.set("alternativeState",{id:"alternativeState", errorMsg:"", value:""});
    inputFieldsAddress.set("alternativeCity",{id:"alternativeCity", errorMsg:"", value:""});
    inputFieldsAddress.set("alternativePincode",{id:"alternativePincode", errorMsg:"", value:""});
    var alternativeAddress=["alternativeAddress","alternativeCountry","alternativeState","alternativeCity","alternativePincode"];
    
    var userId = $('#headingUserId').text();
    //ajax call been made if we successfully retrieve the userId
    if(userId != '')
    {
        $.ajax({
            type:"POST",
            url:"Components/profileService.cfc?method=getMyAddress",
            cache:false,
            error: function(){
                swal({
                    title: "Error",
                    text: "Some server error occurred. Please try after sometimes while we fix it.",
                    icon: "error",
                    button: "Ok",
                });
            },
            success: function(returnedValue) 
            {
                var address=JSON.parse(returnedValue);
                if(address.hasOwnProperty('error'))
                {
                    swal({
                        title: "Error",
                        text: address.error,
                        icon: "error",
                        button: "Ok",
                    });
                }
                else 
                {
                    addressArray = address.ADDRESS.DATA;
                    // populate the country and state maps
                    loadCountryStateMap();
                    //populating the current address fields
                    $("#currentAddress").val(addressArray[0][1]);
                    $("#currentCity").val(addressArray[0][4]);
                    $("#currentPincode").val(addressArray[0][5]);

                    if(addressArray.length==2)
                    {
                        //populating the alternative address fields
                        $("#alternativeAddress").val(addressArray[1][1]);
                        $("#alternativeCity").val(addressArray[1][4]);
                        $("#alternativePincode").val(addressArray[1][5]);
                    }
                }
            }
        });
    }

    //user profile form submission start here...
    $("#formUserDetail").submit(function(e)
    {
        var successfullyValidated=true;

        for(var i of inputFieldsProfile.keys())
        {
            if(inputFieldsProfile.get(i).errorMsg)
            {
                setErrorBorder(inputFieldsProfile.get(i));
                successfullyValidated=false;
            }
        }
        //after validating the default settings is prevented for ajax call
        e.preventDefault();
        if(!successfullyValidated)
        {
            swal({
                title: "Validation Fails!!",
                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                icon: "warning",
                button: "Ok",
            });
        }
        //
        else
        {
            //ajax call made to validate and update the user profile...
            $.ajax({
                type:"POST",
                url:"Components/profileService.cfc?method=updateUserProfile",
                cache: false,
                error: function(){
                    swal({
                        title: "Error",
                        text: "Some server error occurred. Please try after sometimes while we fix it.",
                        icon: "error",
                        button: "Ok",
                    });
                },
                data:{
                        "firstName": $("#firstName").val(),
                        "lastName": $("#lastName").val(),
                        "emailAddress": $("#emailAddress").val(),
                        "dob":$("#dob").val(),
                        "bio":$("#bio").val()
                },
                success: function(returnValue) {
                    var updateUserProfileInfo=JSON.parse(returnValue);
                    // if everything goes fine then user if registered by giving a success message
                    if(updateUserProfileInfo.hasOwnProperty("error"))
                    {
                        swal({
                            title: "Error",
                            text: updateUserProfileInfo.error,
                            icon: "error",
                            buttons: 'Ok',
                        });
                    }
                    else if(updateUserProfileInfo.hasOwnProperty('updatedSuccessfully'))
                    { 
                        swal({
                            title: "Successfully Updated!!",
                            text: "Your profile has been successfully updated",
                            icon: "success",
                            buttons: false,
                        });
                        setTimeout(function(){ window.location.reload(true) },2000);
                    }
                    //else the error is been rectified and message been shown 
                    else if(!updateUserProfileInfo['validatedSuccessfully'])
                    {
                        delete(updateUserProfileInfo['validatedSuccessfully']);
                        for (var key in updateUserProfileInfo) 
                        {
                            if(!updateUserProfileInfo[key])
                            {
                                inputFieldsProfile.get(key).errorMsg = updateUserProfileInfo[key];
                                setErrorBorder(inputFieldsProfile.get(key));
                                showErrorModel=true;
                            } 
                        }
                        swal({
                                title: "Failed to updated!!",
                                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                                icon: "error",
                                button: "Ok",
                        });
                    }
                }
            });
        }
    });

    //user Phone Number form submission start here...
    $("#formUserPhoneDetail").submit(function(e)
    {
        var successfullyValidated=true;

        for(var i of inputFieldsPhoneNumber.keys())
        {
            if(inputFieldsPhoneNumber.get(i).errorMsg)
            {
                setErrorBorder(inputFieldsPhoneNumber.get(i));
                successfullyValidated=false;
            }
        }
        //after validating the default settings is prevented for ajax call
        e.preventDefault();
        if(!successfullyValidated)
        {
            swal({
                title: "Validation Fails!!",
                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                icon: "warning",
                button: "Ok",
            });
        }
        //
        else
        {
            //ajax call made to validate and update the user profile...
            $.ajax({
                type:"POST",
                url:"Components/profileService.cfc?method=updateUserPhoneNumber",
                cache: false,
                error: function(){
                    swal({
                        title: "Error",
                        text: "Some server error occurred. Please try after sometimes while we fix it.",
                        icon: "error",
                        button: "Ok",
                    });
                },
                data:{
                        "primaryPhoneNumber": $("#primaryPhoneNumber").val(),
                        "alternativePhoneNumber":$("#alternativePhoneNumber").val()
                    },
                success: function(error) {
                    var errorMsgs=JSON.parse(error);
                    //if everything goes fine then user if registered by giving a success message
                    if(errorMsgs.hasOwnProperty("error"))
                    {
                        swal({
                            title: "Error",
                            text: errorMsgs.error,
                            icon: "success",
                            buttons: false,
                        });
                    }
                    else if(errorMsgs["updatedSuccessfully"])
                    { 
                        swal({
                            title: "Successfully Updated!!",
                            text: "Your Phone Number has been successfully updated",
                            icon: "success",
                            buttons: false,
                        });
                        setTimeout(function(){ window.location.reload(true) },2000);
                    }
                    //else the error is been rectified and message been shown 
                    else if(!errorMsgs['validatedSuccessfully'])
                    {
                        var showErrorModel=false;
                        for (var key in errorMsgs) {
                            if(key!="validatedSuccessfully" && !errorMsgs[key])
                            {
                                inputFieldsPhoneNumber.get(key).errorMsg=errorMsgs[key];
                                setErrorBorder(inputFieldsPhoneNumber.get(key));
                                showErrorModel=true;
                            } 
                        }
                        if(showErrorModel)
                        {
                            swal({
                                title: "Failed to Update!!",
                                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                                icon: "error",
                                button: "Ok",
                            });
                        }
                        else 
                        {
                            swal({
                                title: "Failed to update!!",
                                text: "Registration fails due to some server problem. Please, try after some time!!",
                                icon: "error",
                                button: "Ok",
                            });
                        }
                    }
                }
            });
        }
    });

    //user profile form submission start here...
    $("#formUserAddressDetail").submit(function(e)
    {
        var successfullyValidated=true;
        var havingAlternativeAddress=checkAlternativeAddress(alternativeAddress);

        for(var i of inputFieldsAddress.keys())
        {
            if(i.length>7 && i.slice(0,-7)=="Country")
            {
                inputFieldsAddress.get(i).value=countryMap.get($("#"+id).val());
            }
            else if(i.length>6 && i.slice(0,-5)=="State")
            {
                inputFieldsAddress.get(i).value=stateMap.get($("#"+id).val());
            }
            if(inputFieldsAddress.get(i).errorMsg)
            {
                setErrorBorder(inputFieldsAddress.get(i));
                successfullyValidated=false;
            }
        }
        //after validating the default settings is prevented for ajax call
        e.preventDefault();
        if(!successfullyValidated)
        {
            swal({
                title: "Validation Fails!!",
                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                icon: "warning",
                button: "Ok",
            });
        }
        //
        else
        {
            //ajax call made to validate and update the user profile...
            $.ajax({
                type:"POST",
                url:"Components/profileService.cfc?method=updateUserAddress",
                cache: false,
                error: function(){
                    swal({
                        title: "Error",
                        text: "Some server error occurred. Please try after sometimes while we fix it.",
                        icon: "error",
                        button: "Ok",
                    });
                },
                data:{
                        "currentAddress":$("#currentAddress").val(),
                        "currentCountry":countryMap.get(parseInt($("#currentCountry").val())),
                        "currentState":stateMap.get($("#currentState").val()).name,
                        "currentCity":$("#currentCity").val(),
                        "currentPincode":$("#currentPincode").val(),
                        "havingAlternativeAddress": havingAlternativeAddress,
                        "alternativeAddress": havingAlternativeAddress == true ? $("#alternativeAddress").val() : '',
                        "alternativeCountry":havingAlternativeAddress == true ? countryMap.get(parseInt($("#alternativeCountry").val())) : '',
                        "alternativeState":havingAlternativeAddress == true ? stateMap.get($("#alternativeState").val()).name:'',
                        "alternativeCity":havingAlternativeAddress == true ? $("#alternativeCity").val():'',
                        "alternativePincode":havingAlternativeAddress == true ? $("#alternativePincode").val():''
                    },
                success: function(error) {
                    var errorMsgs=JSON.parse(error);
                    //if everything goes fine then user if registered by giving a success message
                    if(errorMsgs.hasOwnProperty("error"))
                    {
                        swal({
                            title: "Error",
                            text: errorMsgs.error,
                            icon: "success",
                            buttons: false,
                        })
                    }
                    else if(errorMsgs["updatedSuccessfully"] == true)
                    { 
                        swal({
                            title: "Successfully Updated!!",
                            text: "Your profile has been successfully updated",
                            icon: "success",
                            buttons: false,
                        });
                        setTimeout(function(){ window.location.reload(true) },2000);
                    }
                    //else the error is been rectified and message been shown 
                    else if(!errorMsgs['validatedSuccessfully'])
                    {
                        var showErrorModel=false;
                        for (var key in errorMsgs) {
                            if(key!="validatedSuccessfully" && !errorMsgs[key])
                            {
                                inputFieldsAddress.get(key).errorMsg=errorMsgs[key];
                                setErrorBorder(inputFieldsAddress.get(key));
                                showErrorModel=true;
                            } 
                        }
                        if(showErrorModel)
                        {
                            swal({
                                title: "Registration Fails!!",
                                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                                icon: "error",
                                button: "Ok",
                            });
                        }
                        else 
                        {
                            swal({
                                title: "Registration Fails!!",
                                text: "Registration fails due to some server problem. Please, try after some time!!",
                                icon: "error",
                                button: "Ok",
                            });
                        }
                    }
                }
            });
        }
    });

    //user Phone Number form submission start here...
    $("#formUserInterestDetail").submit(function(e)
    {
        e.preventDefault();
        var otherLocation=0;
        var homeLocation=0;
        var onlineLocation=0;
        if ($('#otherLocation').is(":checked"))
        {
            otherLocation=1;
        }
        if ($('#homeLocation').is(":checked"))
        {
            homeLocation=1;
        }
        if ($('#online').is(":checked"))
        {
            onlineLocation=1;
        }
        // console.log(otherLocation,homeLocation,onlineLocation)
        // ajax call made to validate and update the user profile...
        $.ajax({
            type:"POST",
            url:"Components/profileService.cfc?method=updateUserInterest",
            cache: false,
            error: function(){
                swal({
                    title: "Error",
                    text: "Some server error occurred. Please try after sometimes while we fix it.",
                    icon: "error",
                    button: "Ok",
                });
            },
            data:{
                    "otherLocation": otherLocation,
                    "homeLocation": homeLocation,
                    "online": onlineLocation
                },
            success: function(error) {
                var errorMsgs=JSON.parse(error);
                //if everything goes fine then user if registered by giving a success message
                if(errorMsgs.hasOwnProperty("error"))
                {
                    swal({
                        title: "Error",
                        text: errorMsgs.error,
                        icon: "success",
                        buttons: false,
                    });
                }
                else if(errorMsgs["updatedSuccessfully"] == true)
                { 
                    swal({
                        title: "Successfully Updated!!",
                        text: "Your Phone Number has been successfully updated",
                        icon: "success",
                        buttons: false,
                    })
                    setTimeout(function(){ window.location.reload(true) },2000);
                }
                //else the error is been rectified and message been shown 
                else if(!errorMsgs['validatedSuccessfully'])
                {
                    swal({
                        title: "Failed to update!!",
                        text: "Registration fails due to some server problem. Please, try after some time!!",
                        icon: "error",
                        button: "Ok",
                    });
                }
            }
        });
    });
});
    
//get the first country key of value from provide object map.. 
function getCountryKeyByValue(object, value) 
{
    for(var key of object.keys())
    {
        if(object.get(key) == value)
        {
            return key;
        }
    }
    return '';
}
//get the first state key of value from provide object map.. 
function getStateKeyByValue(object, value) 
{
    for(var key of object.keys())
    {
        if(object.get(key).name == value)
        {
            return key;
        }
    }
    return '';
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
        populateCountry($("#currentCountry"));
        var countryCode = getCountryKeyByValue(countryMap,addressArray[0][2]);
        $('#currentCountry').find('option[value="'+countryCode+'"]').attr("selected",true);
        if(addressArray.length==2)
        {
            populateCountry($("#alternativeCountry"));
            countryCode = getCountryKeyByValue(countryMap,addressArray[1][2]);
            $('#alternativeCountry').find('option[value="'+countryCode+'"]').attr("selected",true);
        }

    });
    $.getJSON('JsonFiles/states.json',function(states)
    { 
        for(let i = 0; i < states.length; i++)
        {
            stateMap.set(states[i].id ,{"name":states[i].name,"countryId":states[i].country_id});
        }
        populateState($("#currentState"),$("#currentCountry").val());
        $('#currentState').find('option[value="'+getStateKeyByValue(stateMap,addressArray[0][3])+'"]').attr("selected",true);
        if(addressArray.length==2)
        {
            populateState($("#alternativeState"),$("#alternativeCountry").val());
            $('#alternativeState').find('option[value="'+getStateKeyByValue(stateMap,addressArray[1][3])+'"]').attr("selected",true);
        }
    });  
}
//populate countries select input
function populateCountry(element)
{
    if($(element).val()=='')
    {
        var countryOptions="<option value=''>---Select Country---</option>";
        for(var id of countryMap.keys())
        {
            countryOptions+="<option value='"+id+"'>"+countryMap.get(id)+"</option>";
        }
        $("#"+element.attr('id')).html(countryOptions); 
    }
}
//populate states on choosing country
function populateState(element,countryCode)
{
    let stateOptions="";
    stateOptions="<option value=''>---Select State---</option>";
    for(var id of stateMap.keys())
    {
        
        if(stateMap.get(id).countryId==countryCode)
        {
            stateOptions+="<option value='"+id+"'>"+stateMap.get(id).name+"</option>";
        }
    }
    $("#"+element.attr('id')).html(stateOptions);
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

// All Validation Functions Starts here
function checkName(element)
{
    var object = inputFieldsProfile.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    var text = $.trim($(element).val());
    if(!isValidPattern(text,patternName))
    {
        object.errorMsg="Please use only Alphabets";
        setErrorBorder(object);
        return;
    }
    if(text.length>20)
    {
        object.errorMsg='Name must be less than 20 Alphabets';
        setErrorBorder(object);
        return;
    }
    else { 
        setSuccessBorder(object);
    }
}
function checkEmailId(element)
{
    var object = inputFieldsProfile.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    var text = $.trim($(element).val());
    if(!isValidPattern(text,patternEmail))
    {
        object.errorMsg="Invalid Email Address.";
        setErrorBorder(object);
        return;
    }
    $.ajax({
        type:"POST",
        url:"Components/profileService.cfc?method=validateEmail",
        data: "emailId="+text,
        cache:false,
        success: function(error) {
            error=JSON.parse(error);
            if(error.hasOwnProperty("error"))
            {
                swal({
                    title: "failed to validate Email address!!",
                    text: error.error,
                    icon: "error",
                    button: "Ok",
                })
            }
            else if(error.hasOwnProperty("MSG"))
            {
                object.errorMsg=error['MSG'];
                setErrorBorder(object);
                return;
            }
        }
    });
    setSuccessBorder(object);
}
function checkPhoneNumber(element)
{
    let object = inputFieldsPhoneNumber.get(element.id);
    let text = $.trim($(element).val());
    if(text == "" && object.id=="primaryPhoneNumber")
    {
        object.errorMsg="Enter your Phone number.";
        setErrorBorder(object);
        return;
    }
    if(text=="" && object.id=="alternativePhoneNumber")
    {
        setSuccessBorder(object);
        return;
    }
    if(!isValidPattern(text,patternPhone))
    {
        object.errorMsg="Number should not include 0 or 1 at begining and should contain only number";
        setErrorBorder(object);
        return;
    }
    if((object.id=="primaryPhoneNumber" && text==$('#alternativePhoneNumber').val())
        || (object.id=="alternativePhoneNumber" && text==$('#primaryPhoneNumber').val()))
    {
        inputFieldsPhoneNumber.get('alternativePhoneNumber').errorMsg="Alternative number should not be same.You can keep this blank.";
        setErrorBorder(inputFieldsPhoneNumber.get('alternativePhoneNumber'));
        return
    }
    $.ajax({
        type:"POST",
        url:"Components/profileService.cfc?method=validatePhone",
        data: "phoneNumber="+text,
        cache:false,
        success: function(error) {
            error=JSON.parse(error)
            if(error.hasOwnProperty("error"))
            {
                swal({
                    title: "failed to validate Phone Number!!",
                    text: error.error,
                    icon: "error",
                    button: "Ok",
                })
            }
            else if(error.hasOwnProperty("MSG"))
            {
                object.errorMsg=error['MSG'];
                setErrorBorder(object);
                return;
            }
        }
    });
    setSuccessBorder(object);
}   
function checkAddress(element)
{
    var addressType=element.id.toString().slice(0,-7);
    populateCountry($("#"+addressType+"Country"));
    var object = inputFieldsAddress.get(element.id);
    var text = $.trim($("#"+object.id).val());
    if(text == "")
    {   
        object.errorMsg="Mandatory Field";
        if(addressType.slice(0,1)!="a" )
        {
            setErrorBorder(object);
        }
        return;
    }
    if(!isValidPattern(text,patternText))
    {
        object.errorMsg="Should contain only alphabets, number and ',''/''&' ";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkCountry(element)
{
    var addressType=element.id.toString().slice(0,-7);
    var object=inputFieldsAddress.get(element.id);

    populateState($("#"+addressType+"State"),$(element).val());
    if($(element).val()!="")
    {
        setSuccessBorder(object);
        return true;
    }  
    object.errorMsg="Mandatory Field!! Provide Country";
    setErrorBorder(object);
    return false;
}
function checkState(element)
{
    var object=inputFieldsAddress.get(element.id);
    if(element.id.slice(0,1)!="a" && !$(element).val())
    {
        object.errorMsg="Mandatory Field!! Provide Current State";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkPincode(element)
{
    var object=inputFieldsAddress.get(element.id);
    if(!($(element).val()))
    {
        if(object.id.slice(0,5)!="alter")
        {
            object.errorMsg="Please Provide Pincode";
            setErrorBorder(object);
        }
        return;
    }
    else if(!isValidPattern($(element).val(),patternPincode))
    {
        object.errorMsg="Invalid Pincode.Must be Number of 6 digit";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);

}

function checkPassword(element)
{
    var object = inputFields.get(element.id);
    var text = $.trim($(element).val());
    console.log(text)
    var confirmPassword = inputFields.get('confirmPassword');
    if(object.id == 'password' && text == "")
    {
        object.errorMsg="Create a Password.";
        if($("#"+confirmPassword.id).val() == "")
        {
            setSuccessBorder(confirmPassword);
        }
        setErrorBorder(object);
        return;
    }
    if((object.id == 'confirmPassword' && $("#password").val().length>0 && text!=$("#password").val() ||  
    (object.id == "password" && $("#confirmPassword").val().length>0 && $("#confirmPassword").val()!=text)))
    {
        confirmPassword.errorMsg="Password not matched";
        setErrorBorder(confirmPassword);
        return;
    }
    if(object.id=='confirmPassword' && $.trim($("#password").val())=="")
    {
        setSuccessBorder(object);
        return;
    }
    if(text.length>15 || text.length<8)
    {
        object.errorMsg="Password must be of 8 to 15 characters.";
        setErrorBorder(object);
        return;
    }
    if(!isValidPattern(text,patternPassword) && object.id=="password")
    {
        object.errorMsg="Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.";
        setErrorBorder(object);
        return;
    }
    if(object.id == 'password' && $("#confirmPassword").val()==$("#"+object.id).val())
    {
        setSuccessBorder(confirmPassword);
    }
    setSuccessBorder(object);
}
function checkDOB(element)
{
    var today = new Date();
    var object=inputFieldsProfile.get(element.id);
    var dateObject = new Date($(element).val());
    if(dateObject.getFullYear()>=today.getFullYear()-2 || dateObject.getFullYear()<today.getFullYear()-80)
    {
        object.errorMsg="Should be greater than 2 years and less than 80 years old";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkBio(element)
{
    var object=inputFieldsProfile.get(element.id);
    text=$.trim($("#"+object.id).val());
    if(!text)
        return;
    if(text.length>300)
    {
        object.errorMsg="Bio should be within 300 charachers";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkAlternativeAddress(alternativeAddress)
{
    var havingAlternativeAddress=true;
    for(let i=0;i<alternativeAddress.length;i++)
    {
        if($("#"+alternativeAddress[i]).val() == "")
        {
            havingAlternativeAddress=false;
        }
    }
    return havingAlternativeAddress;
}
