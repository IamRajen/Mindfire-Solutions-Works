/*
Project Name: FindOnlineTutor.
File Name: registrationFormValidation.js.
Created In: 3rd Apr 2020
Created By: Rajendra Mishra.
Functionality: This javascript file helps the registration page to validated and register the user to our website.
*/

//Initiatization of credential
var inputFields=new Map();
var countryMap=new Map();
var stateMap=new Map();

var patternName=/^[A-Za-z']+$/;
var patternEmail=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
var patternPhone=/^[^0-1][0-9]{9}$/;
var patternText=/^[a-zA-Z0-9\s,'-]*$/;
var patternUserName=/^[a-zA-Z0-9_@]+$/;
var patternPassword=/^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@$%^&+=]).*$/;
var patternPincode=/^[0-9]{6}$/;
var patternExperience=/^[0-9]+$/;

//document ready function
$(document).ready(function()
{
    inputFields.set("firstName",{id:"firstName", errorMsg:"Please Provide Your Name", value:""});
    inputFields.set("lastName",{id:"lastName", errorMsg:"Please Provide Your Last Name", value:""});
    inputFields.set("emailAddress",{id:"emailAddress", errorMsg:"Mandatory Field!! Provide EmailId", value:""});
    inputFields.set("primaryPhoneNumber",{id:"primaryPhoneNumber", errorMsg:"Mandatory Field!! Provide Phone Number", value:""});
    inputFields.set("alternativePhoneNumber",{id:"alternativePhoneNumber", errorMsg:"", value:""});
    inputFields.set("dob",{id:"dob", errorMsg:"Mandatory Field!! Provide Date of Birth", value:""});
    inputFields.set("username",{id:"username", errorMsg:"Mandatory Field!! Create an username", value:""});
    inputFields.set("password",{id:"password", errorMsg:"Mandatory Field!! Create a password", value:""});
    inputFields.set("confirmPassword",{id:"confirmPassword", errorMsg:"", value:""});
    inputFields.set("experience",{id:"experience", errorMsg:"", value:""});
    inputFields.set("currentAddress",{id:"currentAddress", errorMsg:"Mandatory Field!! Provide Current Address", value:""});
    inputFields.set("currentCountry",{id:"currentCountry", errorMsg:"Mandatory Field!! Provide Current Country", value:""});
    inputFields.set("currentState",{id:"currentState", errorMsg:"Mandatory Field!! Provide Current State", value:""});
    inputFields.set("currentCity",{id:"currentCity", errorMsg:"Mandatory Field!! Provide Current City", value:""});
    inputFields.set("currentPincode",{id:"currentPincode", errorMsg:"Mandatory Field!! Provide Current Pincode", value:""});
    inputFields.set("alternativeAddress",{id:"alternativeAddress", errorMsg:"", value:""});
    inputFields.set("alternativeCountry",{id:"alternativeCountry", errorMsg:"", value:""});
    inputFields.set("alternativeState",{id:"alternativeState", errorMsg:"", value:""});
    inputFields.set("alternativeCity",{id:"alternativeCity", errorMsg:"", value:""});
    inputFields.set("alternativePincode",{id:"alternativePincode", errorMsg:"", value:""});
    inputFields.set("bio",{id:"bio", errorMsg:"", value:""});
    inputFields.set("captcha",{id:"captcha",errorMsg:"Invalid Captcha", value:""});
    alternativeAddress=["alternativeAddress","alternativeCountry","alternativeState","alternativeCity","alternativePincode"];
    
    //Adding submit button..
    $("#buttonDiv").append($("<input>").attr({"id":"submitButton","type":"submit","value":"SUBMIT","name":"submitButton"}).addClass("btn btn-danger btn-block"));
    
    $("#teacherSection").hide()
    
    $("#isTeacher").click(function(){
        if($(this).prop("checked") == true){
            $("#teacherSection").show();
            inputFields.get("experience").errorMsg="Please Mention Your Experience";
        }
        else if($(this).prop("checked") == false){
            $("#teacherSection").hide()
            inputFields.get("experience").errorMsg="";
            $("#experience").val('');
        }
    });
    //populate the country and state map
    loadCountryStateMap();
    //load captcha
    generateCaptcha();
    //after submition
    $('form').submit(function(e)
    {
        
        var successfullyValidated=true;
        var havingAlternativeAddress=checkAlternativeAddress(alternativeAddress);
        for(var i of inputFields.keys())
        {
            if(i=="experience" && $("#isTeacher").prop("checked"))
            {   
                var dob = new Date($("#dob").val());
                if(dob.getFullYear()+10+parseInt($("#experience").val()) > (new Date()).getFullYear())
                {
                    inputFields.get("experience").errorMsg="Experience having more than age not allowed!!"
                    setErrorBorder(inputFields.get("experience"));
                    successfullyValidated=false;
                }
            }
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
                setErrorBorder(inputFields.get(i))
                successfullyValidated=false;
            }
        }
        //after validating the default settings is prevented for ajax call
        e.preventDefault();
        //creating an object of this form 
        var self=this;
        //if successfully validated then we make an ajax call
        if(successfullyValidated)
        {
            //ajax call 
            $.ajax({
                type:"POST",
                url:"Components/validation.cfc?method=validateForm",
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
                        "username":$("#username").val(),
                        "password":$("#password").val(),
                        "confirmPassword":$("#confirmPassword").val(),
                        "isTeacher": $("#isTeacher").prop("checked") ? 1 : 0,
                        "experience": $("#isTeacher").prop("checked") ? $("#experience").val() : 0,
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
                        delete errorMsgs['validatedSuccessfully'];
                        if(errorMsgs.hasOwnProperty("serverError"))
                        {
                            swal({
                                title: "Registration Fails!!",
                                text: "Registration fails due to some server problem. Please, try after some time!!",
                                icon: "error",
                                button: "Ok",
                            });
                        }
                        else
                        {
                            delete errorMsgs['serverError'];
                            for(var key in errorMsgs) 
                            {
                                if(errorMsgs[key].hasOwnProperty("MSG"))
                                {
                                    inputFields.get(key).errorMsg=errorMsgs[key]["MSG"];
                                    setErrorBorder(inputFields.get(key));
                                    showErrorModel=true;
                                } 
                            }
                            swal({
                                title: "Registration Fails!!",
                                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                                icon: "error",
                                button: "Ok",
                            });
                        }
                    }
                }
            });
        }
        //if successfully js validation is not validated then error msg is shown
        else 
        {
            swal({
                title: "Registration Fails!!",
                text: "Some fields fails to validate they are marked red with respective reason's. Try to MODIFY and TRY AGAIN",
                icon: "error",
                button: "Ok",
            });
        }
    }); 

});

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
function populateCountry(addressType)
{
    var countryOptions="<option value=''>---Select Country---</option>";
    for(var id of countryMap.keys())
    {
        countryOptions+="<option value='"+id+"'>"+countryMap.get(id)+"</option>";
    }
    $("#"+addressType+"Country").append(countryOptions);
}
//populate states on choosing country
function populateState(element)
{
    var addressType=element.id.toString().slice(0,-7);
    let stateOptions="";
    if($(element).val())
    {
        stateOptions="<option value=''>---Select State---</option>";
        if(checkCountry(element))
        {
            for(var id of stateMap.keys())
            {
                if(stateMap.get(id).countryId==$(element).val())
                {
                    stateOptions+="<option value='"+id+"'>"+stateMap.get(id).name+"</option>";
                }
            }
        }  
    }
    $("#"+addressType+"State").html(stateOptions);
}
//generate captcha
function generateCaptcha()
{
    canvas.width = canvas.width;
    var captcha = $("#canvas");
    var context = captcha[0].getContext("2d");
    var aChars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'n', 'o', 'p', 'q', 'r', 's', 't',
                    'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var maxNum = 35;
    toReturn = '';

    for(let i=1; i<=5; i++)
    {
        var randNum = Math.floor(Math.random() * 35); 
        var letter = aChars[randNum];
        toReturn = toReturn+letter;
    }
    context.font = "60px Arial";
    context.fillText(toReturn,40,100);
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
    return true;
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
        error: function(){
            swal({
                title: "validation Fails!!",
                text: "Some of the server's function fails to vaidate. Please try after some time!!",
                icon: "error",
                button: "Ok",
            }); 
        },
        success: function(error) {
            error=JSON.parse(error);
            if(error.hasOwnProperty("ERROR"))
            {
                swal({
                    title: "failed to validate Email address!!",
                    text: "Some of the server's function fails to validate. Please try after some time!!",
                    icon: "error",
                    button: "Ok",
                }); 
            }
            else if(error.hasOwnProperty("MSG"))
            {
                object.errorMsg=error.MSG;
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
        error: function(){
            swal({
                title: "validation Fails!!",
                text: "Some of the server's function fails to vaidate. Please try after some time!!",
                icon: "error",
                button: "Ok",
            });  
        },
        success: function(error) {
            error=JSON.parse(error);
            if(error.hasOwnProperty("ERROR"))
            {
                swal({
                    title: "failed to validate Phone Number!!",
                    text: "Some of the server's function fails to validate. Please try after some time!!",
                    icon: "error",
                    button: "Ok",
                }); 
            }
            else if(error.hasOwnProperty("MSG"))
            {
                object.errorMsg=error.MSG;
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
    populateCountry(addressType);
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
    var object=inputFields.get(element.id);
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
function checkUsername(element)
{
    var object = inputFields.get(element.id);
    if(isEmpty(object))
    {
        return;
    }
    var text = $.trim($(element).val());
    if(!isValidPattern(text,patternUserName) || text.length>8)
    {
        object.errorMsg="Username should contain only alphabets, numbers, (_ @ .) and 8 characters long";
        setErrorBorder(object);
        return
    }
    $.ajax({
        type:"POST",
        url:"Components/validation.cfc?method=validateUsername",
        data: "usrUsername="+text,
        cache:false,
        error: function(){
            swal({
                title: "validation Fails!!",
                text: "Some of the server's function fails to vaidate. Please try after some time!!",
                icon: "error",
                button: "Ok",
            });  
        },
        success: function(error) {
            error=JSON.parse(error);
            if(error.hasOwnProperty("ERROR"))
            {
                swal({
                    title: "failed to validate username!!",
                    text: "Some of the server's function fails to validate. Please try after some time!!",
                    icon: "error",
                    button: "Ok",
                }); 
            }
            else if(error.hasOwnProperty("MSG"))
            {
                object.errorMsg=error.MSG;
                setErrorBorder(object);
                return;  
            }
        }
    });
    setSuccessBorder(object);
}
function checkPassword(element)
{
    var object = inputFields.get(element.id);
    var text = $.trim($(element).val());
    var confirmPassword = inputFields.get('confirmPassword');
    // var password = inputFields.get('password');
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
function checkExperience(element)
{
    var object=inputFields.get(element.id);
    var text=$.trim($(element).val())
    if(!text || text==0)
    {
        $(element).val(0);
        setSuccessBorder(object)
        return;
    }
    if(!isValidPattern(text,patternExperience) || text.toString().length>2)
    {
        object.errorMsg="Should be Integer of atleast 2 characters long."
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object)
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
function checkCaptcha(element)
{
    var object=inputFields.get(element.id);
    if($(element).val()!=toReturn)
    {
        object.errorMsg="Invalid Captcha";
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