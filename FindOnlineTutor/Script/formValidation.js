var inputFields=new Map()
var countryMap=new Map()
var stateMap=new Map()

var patternName=/^[A-Za-z']+$/;
var patternEmail=/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
var patternPhone=/^[^0-1][0-9]{9}$/;
var patternText=/^[a-zA-Z0-9\s,'-]*$/;
var patternUserName=/^[a-zA-Z0-9_@]+$/
var patternPassword=/^(?=.{8,15})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$/;
var patternPincode=/^[0-9]{6}$/
var patternExperience=/^[0-9]+$/

function loadImage(input)
{
    if (input.files && input.files[0])
    {
        console.log(inputFields)
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#profilePhoto').attr('src', e.target.result);
            inputFields.get("profilePhoto").value=e.target.result;
            inputFields.get('profilePhoto').errrorMsg = "";
        }
        reader.readAsDataURL(input.files[0]);
    }
}
$(document).ready(function()
{
    inputFields.set("profilePhoto",{id:"profilePhoto", errorMsg:"", value:""});
    inputFields.set("firstName",{id:"firstName", errorMsg:"Please Provide Your Name"});
    // inputFields.set("middleName",{id:"middleName", errorMsg:""});
    inputFields.set("lastName",{id:"lastName", errorMsg:"Please Provide Your Last Name"});
    inputFields.set("emailAddress",{id:"emailAddress", errorMsg:"Mandatory Field!! Provide EmailId"});
    inputFields.set("primaryPhoneNumber",{id:"primaryPhoneNumber", errorMsg:"Mandatory Field!! Provide Phone Number"});
    inputFields.set("alternativePhoneNumber",{id:"alternativePhoneNumber", errorMsg:""});
    inputFields.set("dob",{id:"dob", errorMsg:"Mandatory Field!! Provide Date of Birth"});
    inputFields.set("username",{id:"username", errorMsg:"Mandatory Field!! Create an username"});
    inputFields.set("password",{id:"password", errorMsg:"Mandatory Field!! Create a password"});
    inputFields.set("confirmPassword",{id:"confirmPassword", errorMsg:""});
    inputFields.set("experience",{id:"experience", errorMsg:""});
    inputFields.set("currentAddress",{id:"currentAddress", errorMsg:"Mandatory Field!! Provide Current Address"});
    inputFields.set("currentCountry",{id:"currentCountry", errorMsg:"Mandatory Field!! Provide Current Country"});
    inputFields.set("currentState",{id:"currentState", errorMsg:"Mandatory Field!! Provide Current State"});
    inputFields.set("currentCity",{id:"currentCity", errorMsg:"Mandatory Field!! Provide Current City"});
    inputFields.set("currentPincode",{id:"currentPincode", errorMsg:"Mandatory Field!! Provide Current Pincode"});
    inputFields.set("alternativeAddress",{id:"alternativeAddress", errorMsg:""});
    inputFields.set("alternativeCountry",{id:"alternativeCountry", errorMsg:""});
    inputFields.set("alternativeState",{id:"alternativeState", errorMsg:""});
    inputFields.set("alternativeCity",{id:"alternativeCity", errorMsg:""});
    inputFields.set("alternativePincode",{id:"alternativePincode", errorMsg:""});
    inputFields.set("bio",{id:"bio", errorMsg:""});
    inputFields.set("isTeacher",{id:"isTeacher",errorMsg:""})
    inputFields.set("captcha",{id:"captcha",errorMsg:"Invalid Captcha"});
    $("#teacherSection").hide()
    $("#isTeacher").click(function(){
        if($(this).prop("checked") == true){
            $("#teacherSection").show();
            inputFields.get("experience").errorMsg="Please Mention Your Experience";
        }
        else if($(this).prop("checked") == false){
            $("#teacherSection").hide()
            inputFields.get("experience").errorMsg="";
        }
    });
    console.log($("#profilePhoto").val())
    
    loadCountryStateMap();
    generateCaptcha();
    $('#submitButton').click(function()
    {
        alert("hello");
        for(var i of inputFields.keys())
        {
            if(inputFields.get(i).errorMsg)
            {

                setErrorBorder(inputFields.get(i))
            }
        }
        return false;
    });

    

})

function loadCountryStateMap()
{
    $.getJSON('JsonFiles/countries.json',function(countries)
    { 
        for(let i=0; i<countries.length; i++)
        {
            countryMap.set(""+countries[i].id , countries[i].name);
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
function populateCountry(addressType)
{
    var countryOptions="<option value=''>---Select Country---</option>";
    for(var id of countryMap.keys())
    {
        countryOptions+="<option value='"+id+"'>"+countryMap.get(id)+"</option>";
    }
    $("#"+addressType+"Country").append(countryOptions);
}
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

//border work
function setErrorBorder(object)
{
    // console.log(object)
    $("#"+object.id).css({"border-color": "#CD5C5C", "border-width":"2px"}); 
    $('#'+object.id).next().text(object.errorMsg);
}
function setSuccessBorder(object)
{
    $("#"+object.id).css({"border-color": "#ddd", "border-width":"1px"}); 
    object.errorMsg=""
    $('#'+object.id).next().text(object.errorMsg);
}

//All Validation Functions Starts here
function checkName(element)
{
    var object = inputFields.get(element.id);
    var text = $.trim($(element).val());
    if(text=="" && object.id=='middleName')
    {
        setSuccessBorder(object);
        return;
    }
    if(text=="")
    {
        object.errorMsg="Mandatory Field";
        setErrorBorder(object);
        return;
    }
    if(!patternName.test(text))
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
    var object=inputFields.get(element.id);
    var text=$.trim($("#"+object.id).val());
    if(text=="")
    {
        object.errorMsg="Please Enter your Email ID";
        setErrorBorder(object);
        return;
    }
    if(!patternEmail.test(text))
    {
        object.errorMsg="Invalid Email Address.";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkPhoneNumber(element)
{
    let object = inputFields.get(element.id);
    let text = $.trim($(element).val());
    console.log(object)
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
    if(!patternPhone.test(text))
    {
        object.errorMsg="Number should not include 0 or 1 at begining and should contain only number";
        setErrorBorder(object);
        return;
    }
    if((object.id=="primaryPhoneNumber" && text==$('#alternativePhoneNumber').val())
        || (object.id=="alternativePhoneNumber" && text==$('#primaryPhoneNumber').val()))
    {
        inputFields.get('alternativePhoneNumber').errorMsg="Alternative number should not be same.You can keep this blank."
        setErrorBorder(inputFields.get('alternativePhoneNumber'));
        return
    }
    setSuccessBorder(object);
    // if(element.id=="primaryPhoneNumber" && $("#alternativePhoneNumber").val()==$(element).val()) 
    // {
        
    // } 
}   
function checkAddress(element)
{
    var addressType=element.id.toString().slice(0,-7);
    populateCountry(addressType);
    var object = inputFields.get(element.id);
    var text = $.trim($("#"+object.id).val());
    if(text == "")
    {   
        if(addressType.slice(0,1)!="a" )
        {
            object.errorMsg="Mandatory Field";
            setErrorBorder(object);
        }
        return;
    }
    if(!patternText.test(text))
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
    if(element.id.slice(0,1)!="a" && $(element).val())
    {
        object.errorMsg="Mandatory Field!! Provide Current State";
        setErrorBorder(object);
        return;
    }
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
    else if(!patternPincode.test($(element).val()))
    {
        object.errorMsg="Invalid Pincode.Must be Number of 6 digit";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);

}
function checkUsername(element)
{
    var object=inputFields.get(element.id);
    var text=$.trim($(element).val());
    if(!text)
    {
        object.errorMsg="Mandatory Field";
        setErrorBorder(object);
        return;
    }
    if(!patternUserName.test(text) || text.length>8)
    {
        object.errorMsg="Username should contain only alphabets, numbers, (_ @ .) and 8 characters long";
        setErrorBorder(object);
        return
    }
    setSuccessBorder(object);
}
function checkPassword(element)
{
    var object = inputFields.get(element.id);
    var text = $.trim($(element).val());
    var confirmPassword = inputFields.get('confirmPassword');
    var password = inputFields.get('password');
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
    if(!patternPassword.test(text) && object.id=="password")
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
    if(dateObject.getFullYear()>=today.getFullYear()-2)
    {
        object.errorMsg="Should be greater than 2 years";
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkCaptcha(element)
{

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
    if(!patternExperience.test(text) || text.toString().length>2)
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

function generateCaptcha()
{
    canvas.width = canvas.width;
    var captcha = $("#canvas");
    var context = captcha[0].getContext("2d");
    var aChars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
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