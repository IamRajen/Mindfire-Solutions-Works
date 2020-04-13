/*
Project Name: FindOnlineTutor.
File Name: updateProfile.js.
Created In: 7th Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file helps update the profile of user.
*/

var inputFields=new Map();
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
    $("#buttonDiv").html($("<input>").attr({"id":"submitButton","type":"submit","value":"UPDATE","name":"submitButton"}).addClass("btn btn-danger btn-block"));
    //setting the inputfields keys and values..
    inputFields.set("firstName",{id:"firstName", errorMsg:"", value:""});
    inputFields.set("lastName",{id:"lastName", errorMsg:"", value:""});
    inputFields.set("emailAddress",{id:"emailAddress", errorMsg:"", value:""});
    inputFields.set("primaryPhoneNumber",{id:"primaryPhoneNumber", errorMsg:"", value:""});
    inputFields.set("alternativePhoneNumber",{id:"alternativePhoneNumber", errorMsg:"", value:""});
    inputFields.set("dob",{id:"dob", errorMsg:"", value:""});
    inputFields.set("password",{id:"password", errorMsg:"", value:""});
    inputFields.set("confirmPassword",{id:"confirmPassword", errorMsg:"", value:""});
    // inputFields.set("experience",{id:"experience", errorMsg:"", value:""});
    inputFields.set("currentAddress",{id:"currentAddress", errorMsg:"", value:""});
    inputFields.set("currentCountry",{id:"currentCountry", errorMsg:"", value:""});
    inputFields.set("currentState",{id:"currentState", errorMsg:"", value:""});
    inputFields.set("currentCity",{id:"currentCity", errorMsg:"", value:""});
    inputFields.set("currentPincode",{id:"currentPincode", errorMsg:"", value:""});
    inputFields.set("alternativeAddress",{id:"alternativeAddress", errorMsg:"", value:""});
    inputFields.set("alternativeCountry",{id:"alternativeCountry", errorMsg:"", value:""});
    inputFields.set("alternativeState",{id:"alternativeState", errorMsg:"", value:""});
    inputFields.set("alternativeCity",{id:"alternativeCity", errorMsg:"", value:""});
    inputFields.set("alternativePincode",{id:"alternativePincode", errorMsg:"", value:""});
    inputFields.set("bio",{id:"bio", errorMsg:"", value:""});
    var alternativeAddress=["alternativeAddress","alternativeCountry","alternativeState","alternativeCity","alternativePincode"];
    
    var userId = $('#headingUserId').text();
    $("h2").hide();
    //ajax call been made if we successfully retrieve the userId
    if(userId != '')
    {
        $.ajax({
            type:"POST",
            url:"Components/databaseService.cfc?method=getMyAddress",
            data: "userId="+userId,
            cache:false,
            error: function(){
                swal({
                    title: "Failed to load!!",
                    text: "Cannot load the address due to some internal error. Please, try to after sometimes!!",
                    icon: "error",
                    button: "Ok",
                });
            },
            success: function(message) {
                message=JSON.parse(message);
                console.log(message)
                if(message.hasOwnProperty("ERROR"))
                {
                    swal({
                        title: "Failed to load!!",
                        text: "Cannot load the address due to some internal error. Please, try to after sometimes!!",
                        icon: "error",
                        button: "Ok",
                    });
                }
                else 
                {
                    addressArray = message.ADDRESS.DATA;
                    console.log(addressArray)
                    //populate the country and state maps
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

    $("form").submit(function(e)
    {
        var successfullyValidated=true;
        var havingAlternativeAddress=checkAlternativeAddress(alternativeAddress);

        for(var i of inputFields.keys())
        {
            if(i.length>7 && i.slice(0,-7)=="Country")
            {
                inputFields.get(i).value=countryMap.get($("#"+id).val());
            }
            else if(i.length>6 && i.slice(0,-5)=="State")
            {
                inputFields.get(i).value=stateMap.get($("#"+id).val());
            }
            if(inputFields.get(i).errorMsg)
            {
                // console.log(i+" "+inputFields.get(i).errorMsg)
                setErrorBorder(inputFields.get(i));
                successfullyValidated=false;
            }
        }
        //after validating the default settings is prevented for ajax call
        e.preventDefault();
        var self=this;
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
                url:"Components/databaseService.cfc?method=updateUserProfile",
                cache: false,
                error: function(){
                    swal({
                        title: "Registration Fails!!",
                        text: "Some of the internal function fails to register. Please try after some time!!",
                        icon: "error",
                        button: "Ok",
                    });
                
                },
                data:{
                        "firstName": $("#firstName").val(),
                        "lastName": $("#lastName").val(),
                        "emailAddress": $("#emailAddress").val(),
                        "primaryPhoneNumber": $("#primaryPhoneNumber").val(),
                        "alternativePhoneNumber":$("#alternativePhoneNumber").val(),
                        "dob":$("#dob").val(),
                        "password":$("#password").val(),
                        "confirmPassword":$("#confirmPassword").val(), 
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
                        "alternativePincode":havingAlternativeAddress == true ? $("#alternativePincode").val():'',
                        "bio":$("#bio").val()=="" ? '': $("#bio").val()
                    },
                success: function(error) {
                    var errorMsgs=JSON.parse(error);
                    //if everything goes fine then user if registered by giving a success message
                    if(errorMsgs["validatedSuccessfully"] == true)
                    { 
                        swal({
                            title: "Registration Successfull!!",
                            text: "Thank you for Registering",
                            icon: "success",
                            buttons: false,
                        })
                        setTimeout(function(){self.submit()},3000);
                    }
                    //else the error is been rectified and message been shown 
                    else
                    {
                        var showErrorModel=false;
                        for (var key in errorMsgs) {
                            if(key!="validatedSuccessfully" && !errorMsgs[key])
                            {
                                inputFields.get(key).errorMsg=errorMsgs[key];
                                setErrorBorder(inputFields.get(key));
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
    var object = inputFields.get(element.id);
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
    var object = inputFields.get(element.id);
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
        url:"Components/validation.cfc?method=validateEmail",
        data: "usrEmail="+text,
        cache:false,
        success: function(error) {
            error=JSON.parse(error);
            if(error)
            {
                object.errorMsg=error;
                setErrorBorder(object);
                return;
            }
        }
    });
    setSuccessBorder(object);
}
function checkPhoneNumber(element)
{
    let object = inputFields.get(element.id);
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
        inputFields.get('alternativePhoneNumber').errorMsg="Alternative number should not be same.You can keep this blank.";
        setErrorBorder(inputFields.get('alternativePhoneNumber'));
        return
    }
    $.ajax({
        type:"POST",
        url:"Components/validation.cfc?method=validatePhoneNumber",
        data: "usrPhoneNumber="+text,
        cache:false,
        success: function(error) {
            error=JSON.parse(error)
            if(error)
            {
                object.errorMsg=error;
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
    var object = inputFields.get(element.id);
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
    var object=inputFields.get(element.id);

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
    var object=inputFields.get(element.id);
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
    var object=inputFields.get(element.id);
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
    var object=inputFields.get(element.id);
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
    var object=inputFields.get(element.id);
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
