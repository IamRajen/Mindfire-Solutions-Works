//Initiatization of credential
var inputFields=new Map();
$(document).ready(function(){
    generateCaptcha();
    //adding login button..
    $("#buttonDiv").append($("<input>").attr({"id":"submitButton","type":"submit","value":"SUBMIT","name":"submitButton"}).addClass("btn btn-danger btn-block"));
    inputFields.set("username",{id:"username", errorMsg:"Enter your username", value:""});
    inputFields.set("password",{id:"password", errorMsg:"Enter your password", value:""});
    inputFields.set("captcha",{id:"captcha", errorMsg:"Mandatory Field", value:""});
    
    $("#submitButton").click(function()
    {
        var successfullyLoggedIn=false;
        for(key of inputFields.keys())
        {
            if($("#"+key).val()=='')
            {
                inputFields.get(key).errorMsg="Field can't be empty!!"
                setErrorBorder(inputFields.get(key));
            }
        }
        if(toReturn!=$("#captcha").val())
        {
            inputFields.get("captcha").errorMsg="Captcha not matched!!";
            setErrorBorder(inputFields.get("captcha"));
            return successfullyLoggedIn;
        }
        else
        {
            setSuccessBorder(inputFields.get("captcha"));
        }
        $.ajax({
            type:"POST",
            async: "false",
            url:"Components/authenticationService.cfc?method=validateUser",
            async: false,
            cache: false,
            timeout: 30000,
            error: function(){
                successfullyLoggedIn=false;
            },
            data:{
                    "username":$("#username").val(),
                    "password": $("#password").val()
                },
            success: function(error) {
                errorMsgs=JSON.parse(error);
                console.log(errorMsgs);
                if(errorMsgs["loggedInSuccessfully"] == true)
                {
                    successfullyLoggedIn=true;
                }
                else
                {
                    successfullyLoggedIn=false;
                    if(errorMsgs["username"])
                    {
                        inputFields.get("username").errorMsg=errorMsgs["username"];
                        setErrorBorder(inputFields.get("username"));
                    }
                    if(errorMsgs["password"])
                    {
                        inputFields.get("password").errorMsg=errorMsgs["password"];
                        setErrorBorder(inputFields.get("password"));
                    }
                    $("#loginError").text(errorMsgs['loginError']);
                }
            }
        });
        return successfullyLoggedIn;
    });
});

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
function validCaptcha(element)
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