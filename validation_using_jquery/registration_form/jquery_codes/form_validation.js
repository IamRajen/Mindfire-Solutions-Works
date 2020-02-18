class inputFieldIds{
    constructor(id,error_msg,value)
    {
        this.id = id;
        this.error_msg = error_msg;
        this.value = value;
    }

    getErrorMsg(){return this.error_msg;}
    getId(){return this.id;}
    getValue(){return this.value;}
    setErrorMsg(error){this.error_msg = error;}
    setValue(value){this.value = value;}
}
var input_fields_array = new Map()
$( document ).ready(function() 
{
    input_fields_array.set("first_name" , new inputFieldIds( "first_name" , "Enter First Name.","" ))
                        .set("middle_name" , new inputFieldIds("middle_name" , "" ,"" ))
                        .set("last_name" , new inputFieldIds("last_name" , "Enter Last Name.","" ))
                        .set("email_id" , new inputFieldIds("email_id" , "Enter Email Address" ))
                        .set("gender" , new inputFieldIds("gender", "Choose Your Gender", "" ))
                        .set("password1" , new inputFieldIds("password1" , "Create a Password1", "" ))
                        .set("password2" , new inputFieldIds("password2", "", "" ))
                        .set("phone_number" , new inputFieldIds( "phone_number" , "Enter Your Phone Number", "" ))
                        .set("alt_phone_number" , new inputFieldIds( "alt_phone_number" , "" ,""))
                        .set("current_address" , new inputFieldIds( "current_address" , "Enter Your Current Address", "" ))
                        .set("permanent_address" , new inputFieldIds( "permanent_address" , "", "" ))
                        .set("current_country" , new inputFieldIds( "currnt_country" , "Select Current Country", "" ))
                        .set("current_state" , new inputFieldIds( "current_state" , "Select Current State", "" ))
                        .set("current_city" , new inputFieldIds( "current_city" , "Select Current City", "" ))
                        .set("subscription" , new inputFieldIds( 'subscription' , "", ""))
                        .set("answer_captcha" , new inputFieldIds( "answer_captcha" , "Invalid Captcha", "" ));
    refresh_captcha();

    $(function()
    {
        
        $('input[name ="gender"]').on('blur',function()
        {
            input_fields_array.get("gender").setValue($('input[name ="gender"]:checked').val());
            checkGender(gender);
        });
        $('#submit_button').click(function()
        {
            let total_error_fields = true;
            for(var key of input_fields_array.keys())
            {
                if(input_fields_array.get(key).getErrorMsg() != "")
                {
                    // $('html, body').animate({'scrollTop' : $("#"+key).position().top},1000);
                    setErrorBorder(input_fields_array.get(key));
                    total_error_fields = false;
                }
            }
            if(total_error_fields)
            {
                alert("Successfully Registered. Click OK to Proceed");
                return true;
            }
            else 
            {
                // $("html, body").animate({ scrollTop: "0" });
                alert("Registration Failed. Many Fields are empty or not correctely filled.")
                return total_error_fields;  
            }
        });
    });
    function refresh_captcha()
    {
        canvas.width = canvas.width;
        var captcha = $("#canvas");
        var context = captcha[0].getContext("2d");
        var operator = ["+","-","*","/"];

        var operand1 = Math.floor(Math.random() * 10)+1; 
        var operand2 = Math.floor(Math.random() * 10)+1;
        var symbol = operator[Math.floor(Math.random()*4)];
        if(symbol == '/' && operand1 % operand2 != 0)
        {
            symbol = "+";
        }
        context.font = "60px Arial";
        context.fillText(operand1,20,80);
        context.fillText(symbol,90,80);
        context.fillText(operand2,160,80);
        switch(symbol)
        {
            case "+": ans = operand1 + operand2;
                        break;
            case "-": ans = operand1 - operand2;
                        break;
            case "/": ans = operand1 / operand2;
                        break;
            case "*": ans = operand1 * operand2;   
        }
    }   
});
function setErrorBorder(object)
{
    $("#"+object.getId()).css({"border-color": "red", "border-width":"2px"}); 
    $("#"+object.getId()+"_span").text(object.getErrorMsg());
}
function setSuccessBorder(object)
{
    $("#"+object.getId()).css({"border-color": "green", "border-width":"2px"}); 
    object.setErrorMsg("");
    $("#"+object.getId()+"_span").text(object.getErrorMsg());
}
function setNormalBorder(object)
{
    $("#"+object.getId()).css({"border-color": "black", "border-width":"1px"}); 
    object.setErrorMsg("");
    $("#"+object.getId()+"_span").text(object.getErrorMsg());
}
function checkName(element)
{
    var object = input_fields_array.get(element.id);
    object.setValue($(element).val());
    var pattern = /^[A-Za-z']+$/;
    var text = $.trim(object.getValue());
    if(text =="" && object.getId() == 'middle_name')
    {
        setNormalBorder(object);
        return;
    }
    if(text == "")
    {
        object.setErrorMsg("Mandatory Field");
        setErrorBorder(object);
        return;
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Please use only Alphabets");
        setErrorBorder(object);
        return;
    }
    if(text.length>15)
    {
        object.setErrorMsg('Name must be less than 15 Alphabets');
        setErrorBorder(object);
        return;
    }
    else {
        setSuccessBorder(object);
    }
}
function checkEmailId(element)
{
    var object = input_fields_array.get(element.id);
    object.setValue($(element).val());
    var pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    var text = $.trim(object.getValue());
    if(text =="")
    {
        object.setErrorMsg("Please Enter your Email ID");
        setErrorBorder(object);
        return;
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Invalid Email Address.eg: ram@domain.com");
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkGender(element)
{
    var object = input_fields_array.get(element.id);
    if(object.getValue() == null)
    {
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkPassword(element)
{
    var object = input_fields_array.get(element.id);
    object.setValue($(element).val());
    var pattern = /^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$/;
    var text = $.trim(object.getValue());
    console.log(text);
    var password2 = input_fields_array.get('password2');
    var password1 = input_fields_array.get('password1');
    if(object.getId() == 'password1' && text == "")
    {
        object.setErrorMsg("Create a Password.");
        if(password2.getValue() == "")
        {
            setNormalBorder(password2);
        }
        setErrorBorder(object);
        return;
    }
    if((object.getId() == 'password2' && password1.getValue().length > 0 && text != password1.getValue()) || 
            (object.getId() == "password1" && password2.getValue().length > 0 && password2.getValue() != text))
    {
        password2.setErrorMsg("Password not matched");
        setErrorBorder(password2);
        return;
    }
    if(object.getId() == 'password2' && $.trim(password1.getValue())=="")
    {
        setNormalBorder(object);
        return;
    }
    if(text.length > 15 || text.length < 8)
    {
        object.setErrorMsg("Password must be of 8 to 15 characters.");
        setErrorBorder(object);
        return;
    }
    if(!pattern.test(text) && object.getId() == "password1")
    {
        object.setErrorMsg("Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.");
        setErrorBorder(object);
        return;
    }
    if(object.getId() == 'password1' && password2.getValue() == object.getValue())
    {
        setSuccessBorder(password2);
    }
    setSuccessBorder(object);
}
function checkPhoneNumber(element)
{
    var object = input_fields_array.get(element.id);
    object.setValue($(element).val());
    var pattern = /^[^0-1][0-9]{9}$/;
    var text = $.trim(object.getValue());
    if(object.getId() == 'alt_phone_number' && text == '')
    {
        setNormalBorder(object);
        return;
    }
    if(object.getId() == "phone_number" && text == "")
    {
        object.setErrorMsg("Enter your Phone number.")
        setErrorBorder(object);
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Invalid Phone Number");
        setErrorBorder(object);
        return;
    }
    if((object.getId() == "alt_phone_number" && input_fields_array.get("phone_number").getValue() && text == input_fields_array.get('phone_number').getValue())
        || (object.getId() == "phone_number" && input_fields_array.get("alt_phone_number").getValue() && text == input_fields_array.get("alt_phone_number").getValue()))
    {
        input_fields_array.get('alt_phone_number').setErrorMsg("Number should not be same.");
        setErrorBorder(input_fields_array.get('alt_phone_number'));
        return;
    }
    setSuccessBorder(object);   
}   
function checkAddress(element)
{
    var object = input_fields_array.get(element.id);
    object.setValue($(element).val());
    var pattern = /^[0-9 _ , / & a-zA-Z ]*$/;
    var text = $.trim(object.getValue());
    if(text == "" && object.getId() == "permanent_address")
    {
        setSuccessBorder(object);
        return;
    }
    if(text.length < 6)
    {
        object.setErrorMsg("Address must be of 6 characters long.");
        setErrorBorder(object);
        return;
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Must contain only alphabets, number and ',''/''&' ");
        setErrorBorder(object);
        return;
    }
    var permanent_address = input_fields_array.get('permanent_address');
    if((object.getId() == 'current_address' && permanent_address.getValue() && object.getValue() == permanent_address.getValue())
        || (object.getId() == 'permanent_address' && current_address.getValue() && object.getValue() == current_address.getValue()))
    {
        permanent_address.setErrorMsg("Address must not be the same.");
        setErrorBorder(permanent_address);
        return;
    }
    object.setErrorMsg("");
    setSuccessBorder(object);
}
function checkAreaName(element)
{   
    var object = input_fields_array.get($(element).attr('id'));
    object.setValue($(element).val())
    var text = $.trim(object.getValue());
    if(text == "")
    {
        object.setErrorMsg('Please select Your State');
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
}
function checkCaptcha(element)
{
    var object = input_fields_array.get(element.id);
    object.setValue($(element).val());
    var text = $.trim(object.getValue());
    if(ans != text)
    {
        object.setErrorMsg("Invalid Captcha");
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
} 
