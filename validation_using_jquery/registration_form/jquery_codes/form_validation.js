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

$( document ).ready(function() 
{
    first_name = new inputFieldIds( "first_name" , "Enter First Name..!!","" );
    middle_name = new inputFieldIds("middle_name" , "","" );
    last_name = new inputFieldIds("last_name" , "Enter Last Name..!!","" );
    email_id = new inputFieldIds("email_id" , "Enter Email Address" );
    gender = new inputFieldIds("gender", "Choose Your Gender", "" );
    password1 = new inputFieldIds("password1" , "Create a Password1", "" );
    password2 = new inputFieldIds("password2", "Password not Matched", "" );
    phone_number = new inputFieldIds( "phone_number" , "Enter Your Phone Number", "" );
    alt_phone_number = new inputFieldIds( "alt_phone_number" , "" ,"");
    current_address = new inputFieldIds( "current_address" , "Enter Your Current Address", "" );
    permanent_address = new inputFieldIds( "permanent_address" , "", "" );
    current_country = new inputFieldIds( "current_country" , "Enter Your Current Country", "" );
    current_state = new inputFieldIds( "current_state" , "Enter Your Current State", "" );
    current_city = new inputFieldIds( "current_city" , "Enter Your Current City", "" );
    subscription = new inputFieldIds( 'subscription' , "", "");
    answer_captcha = new inputFieldIds( "answer_captcha" , "Invalid Captcha", "" );
    captcha_refresh_button = $('#captcha_refresh_button');
});

$(document).ready(function(){
    $('#submit_button').click(function()
    {
        return false;
    });
});

$(function()
{
    $('#first_name').focusout(function()
    {
        first_name.setValue($(this).val());
        checkName(first_name);
    });
    $('#middle_name').focusout(function()
    {
        middle_name.setValue($(this).val());
        checkName(middle_name);
    });
    $('#last_name').focusout(function()
    {
        last_name.setValue($(this).val());
        checkName(last_name);
    });
    $('#email_id').focusout(function()
    {
        email_id.setValue($(this).val());
        checkEmailId(email_id);
    });
    // $('#gender').on('blur',function()
    // {
    //     gender.setValue($(this).val());
    //     checkGender(gender);
    // });
    $('#password1').on('blur',function()
    {
        password1.setValue($(this).val());
        checkPassword(password1);
    });
    $('#password2').on('blur',function()
    {
        password2.setValue($(this).val());
        checkPassword(password2);
    });
    $('#phone_number').on('blur',function()
    {
        phone_number.setValue($(this).val());
        checkPhoneNumber(phone_number);
    });
    $('#alt_phone_number').on('blur',function()
    {
        alt_phone_number.setValue($(this).val());
        checkPhoneNumber(alt_phone_number);
    });
    $('#current_address').on('blur',function()
    {
        current_address.setValue($(this).val());
        checkAddress(current_address);
    });
    $('#permanent_address').on('blur',function()
    {
        permanent_address.setValue($(this).val());
        checkAddress(permanent_address);
    });
    $('#current_country').on('blur',function()
    {
        current_country.setValue($(this).val());
        checkAreaName(current_country);
    });
    $('#current_state').on('blur',function()
    {
        current_state.setValue($(this).val());
        checkAreaName(current_state);
    });
    $('#current_city').on('blur',function()
    {
        current_city.setValue($(this).val());
        checkAreaName(current_city);
    });
    $('#answer_captcha').on('blur',function()
    {
        answer_captcha.setValue($(this).val());
        checkCaptcha(answer_captcha);
    });
    captcha_refresh_button.click(function(){
        refresh_captcha();
    });




    
    function setErrorBorder(object)
    {
        $("#"+object.getId()).css({"border-color": "red", "border-width":"2px"}); 
        $("#"+object.getId()+"_span").text(object.getErrorMsg());
        console.log($("#"+object.getId()+"_span").val());
    }

    function setSuccessBorder(object)
    {
        $("#"+object.getId()).css({"border-color": "green", "border-width":"2px"}); 
        object.setErrorMsg("");
        $("#"+object.getId()+"_span").text(object.getErrorMsg());
        console.log($("#"+object.getId()+"_span").val()+"All Clear");
    }


    function checkName(object)
    {
        var pattern = /^[A-Za-z']+$/;
        var text = $.trim(object.getValue());
        console.log(object.getId()+"hello");
        if(text =="" && object.getId() == 'middle_name')
        {
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
            return;
        }
    }

    
    function checkEmailId(object)
    {
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
            object.setErrorMsg("Invalid Email Address.");
            setErrorBorder(object);
        }
        else{
            setSuccessBorder(object);
        }

    }
    function checkGender()
    {

    }
    function checkPassword(object)
    {
        var pattern = /^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$/
        var text = $.trim(object.getValue());
        if(object.getId() == 'password1' && text == "")
        {
            object.setErrorMsg("Create a Password.");
            setErrorBorder(object);
        }
        else if(text.length > 15)
        {
            object.setErrorMsg("Password must be of 8 to 15 characters.");
            setErrorBorder(object);
        }
        else if(object.getId() == "password1" && !pattern.test(text))
        {
            object.setErrorMsg("Must contain at least 1 UPPERCASE 1 LOWERCASE 1 SPECIAL CHARACTER.");
            setErrorBorder(object);
        }
        else if((object.getId() == 'password2' && password1.getValue().length > 0 && text != password1.getValue()) || 
                (object.getId() == "password1" && password2.getValue().length > 0 && password2.getValue() != text))
        {
            password2.setErrorMsg("Password not matched");
            setErrorBorder(password2);
        }
        else if(object.getId() == 'password1' && password2.getValue() == object.getValue())
        {
            setSuccessBorder(password2);
        }
        setSuccessBorder(object);

        

    }
    function checkPhoneNumber(object)
    {
        var pattern = /^[^0-1][0-9]{9}$/;
        var text = $.trim(object.getValue());
        if(object.getId() == "phone_number" && text == "")
        {
            object.setErrorMsg("Enter your Phone number.")
            setErrorBorder(object);
        }
        else if(!pattern.test(text))
        {
            object.setErrorMsg("Invalid Phone Number");
            setErrorBorder(object);
        }
        else if((object.getId() == "alt_phone_number" && phone_number.getValue() && text == phone_number.getValue())
            || (object.getId() == "phone_number" && alt_phone_number.getValue() && text == alt_phone_number.getValue()))
        {
            alt_phone_number.setErrorMsg("Number should not be same.");
            setErrorBorder(alt_phone_number);
        }
        else {
            setSuccessBorder(object);
        }
        
        
        
    }
    function checkAddress(object)
    {
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

    function checkAreaName(object)
    {   
        var pattern = /^[a-zA-Z ]*$/;
        var text = $.trim(object.getValue());
        
        if(!pattern.test(text) || text == "")
        {
            object.setErrorMsg('Please select a valid name. Can Use Only UPPERCASE LOWERCASE and spaces');
            setErrorBorder(object);
            return;
        }
        setSuccessBorder(object);

    }
    function checkCaptcha(object)
    {
        var text = $.trim(object.getValue());
        if(captcha_result != text)
        {
            object.setErrorMsg("Invalid Captcha");
            setErrorBorder(object);
            return;
        }
        setSuccessBorder(object);
    }


    
    function refresh_captcha()
    {
        // canvas.width = canvas.width;
        var $captcha = $("#canvas");
        $captcha.drawRect({
            fillStyle: 'steelblue',
            strokeStyle: 'blue',
            strokeWidth: 4,
            x: 450, y: 500,
            fromCenter: false,
            width: 200,
            height: 100
          });
        // var context = captcha.getContext("2d");
        // var operator = ["+","-","*","/"];

        // var operand1 = Math.floor(Math.random() * 10)+1; 
        // var operand2 = Math.floor(Math.random() * 10)+1;
        // var symbol = operator[Math.floor(Math.random()*4)];
        // if(symbol == '/' && operand1 % operand2 != 0)
        // {
        //     symbol = "+";
        // }
        // context.font = "60px Arial";
        // context.fillText(operand1,20,80);
        // context.fillText(symbol,90,80);
        // context.fillText(operand2,160,80);
        // console.log(operand1 + operand2);
        // switch(symbol)
        // {
        //     case "+": ans = operand1 + operand2;
        //                 break;
        //     case "-": ans = operand1 - operand2;
        //                 break;
        //     case "/": ans = operand1 / operand2;
        //                 break;
        //     case "*": ans = operand1 * operand2;   
        // }
    }


});
