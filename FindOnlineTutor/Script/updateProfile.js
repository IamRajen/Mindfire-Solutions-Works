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

//document ready function
$(document).ready(function()
{
    //Adding submit button..
    $("#buttonDiv").append($("<input>").attr({"id":"submitButton","type":"submit","value":"UPDATE","name":"submitButton"}).addClass("btn btn-danger btn-block"));
    //setting the inputfields keys and values..
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
    
    var userId = '';
    //ajax call to retrieve the userId
    $.ajax({
        type:"POST",
        url:"Components/databaseService.cfc?method=getUserId",
        data: "username="+$("#headingUsername").text(),
        async: false,
        cache: false,
        timeout: 30000,
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
                userId=message.ID;
            }
        }
    });
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
                    var address = message.ADDRESS.DATA;
                    
                }
            }
        });
    }
});