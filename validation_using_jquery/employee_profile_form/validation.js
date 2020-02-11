class Employee  
{
    constructor(first_name,middle_name,last_name,email_id,phone_number,current_address,pan_card_number,aadhar_card_number,
                addresses,profile_photo,alt_phone_numbers)
    {
        this.first_name = first_name;
        this.middle_name = middle_name;
        this.last_name = last_name;
        this.email_id = email_id;
        this.phone_number = phone_number;
        this.current_address = current_address;
        this.pan_card_number = pan_card_number;
        this.aadhar_card_number = aadhar_card_number;
        this.alt_phone_numbers = alt_phone_numbers;
        this.addresses = addresses;
        this.profile_photo = profile_photo;
    }
    getName()
    {
        return this.first_name+" "+this.middle_name+" "+this.last_name;
    }
    getEmailId()
    {
        return this.email_id;
    }
    getPrimaryPhoneNumber()
    {
        return this.phone_number;
    }
    getCurrentAddress()
    {
        var address = this.current_address.getAddress();
        var country = this.current_address.getCountry();
        var state = this.current_address.getState();
        var city = this.current_address.getCity();
        var pincode = this.current_address.getPincode();
   
        return address+" "+country+" "+state+" "+city+" "+pincode;
    }
    getPancardNumber()
    {
        return this.pan_card_number;
    }
    getAadharcardNumber()
    {
        return this.aadhar_card_number;
    }
    getAlternativePhoneNumbers()
    {
        return this.alt_phone_numbers;
    }
    getAddresses()
    {
        return this.addresses;
    }
    getProfilePhoto()
    {
        this.profile_photo;
    }
}

class Address
{
    constructor(address,country,state,city,pincode)
    {
        this.address = address;
        this.country = country;
        this.state = state;
        this.city = city;
        this.pincode = pincode;
    }
    getAddress(){return this.address;}
    getCountry(){return this.country;}
    getState(){return this.state;}
    getCity(){return this.city;}
    getPincode(){return this.pincode};

    setAddress(address){ this.address = address;}
    setCountry(country){ this.country = country;}
    setState(state){ this.state = state;}
    setCity(city){ this.city = city;}
    setPincode(pincode){ this.pincode = pincode};
}
class InputFields
{
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

alt_phone_number_ids = 1;
alt_address_ids = 1;
var map = new Map();



$(document).ready(function()
{
    $('#employee_details').hide();
    $('#div_container').addClass('blue_class');
    alt_phone_number = new Array();
    addresses = new Array();
    profile_photo = new InputFields("profile_photo","Upload Profile Photo", "");
    
    map.set("first_name",new InputFields( "first_name" , "Enter First Name.","" ))
       .set("middle_name",new InputFields("middle_name" , "" ,"" ))
       .set("last_name",new InputFields("last_name" , "Enter Last Name.","" ))
       .set("email_id",new InputFields("email_id" , "Enter Email Address" ))
       .set("phone_number",new InputFields( "phone_number" , "Enter Your Phone Number", "" ))
       .set("current_address",new InputFields( "current_address" , "Enter Your Current Address", "" ))
       .set("current_country",new InputFields( "current_country" , "Select Current Country", "" ))
       .set("current_state",new InputFields( "current_state" , "Select Current State", "" ))
       .set("current_city",new InputFields( "current_city" , "Select Current City", "" ))
       .set("current_pincode",new InputFields("current_pincode","Enter your Pincode",""))
       .set("pan_card",new InputFields( 'pan_card' , "Enter Your Pan card Number", ""))
       .set("aadhar_card",new InputFields( "aadhar_card" , "Enter Your Aadhar card Number", "" ))
       .set("answer_captcha",new InputFields("answer_captcha","Invalid Captcha",""));
    //    .set("profile_photo",new InputFields("profile_photo","Please Upload a photo",""));

    alt_phone_number.push(map.get("phone_number"));
    $('#add_phone_field').click(function()
    {
        addPhoneField();
    });
    
    $('#add_address_field').click(function()
    {
        addAddressField();
    });

    $('#captcha_refresh_button').click(function()
    {
        refresh_captcha();
    });
    $('#answer_captcha').blur(function()
    {
        checkCaptcha('answer_captcha');
    });
    
    refresh_captcha();

    $('#submit_button').click(function()
    {
        var valid = true;
        for(var key of map.keys())
        {
            if(map.get(key).getErrorMsg())
            {
                setErrorBorder(map.get(key));
                valid = false;
                refresh_captcha();
            }
        }
        if(valid) 
        {
            alt_address_objects = new Array()
            for (var address =0 ;address<addresses.length;address++)
            {
                alt_address_objects.push(addresses[address].getAddress().value + addresses[address].getCountry().value+addresses[address].getState().value+addresses[address].getCity().value+addresses[address].getPincode().value);
            }
            var current_address = new Address(
                map.get('current_address').getValue(),
                map.get('current_country').getValue(),
                map.get('current_state').getValue(),
                map.get('current_city').getValue(),
                map.get('current_pincode').getValue()
            );
            employee = new Employee(
                map.get('first_name').getValue(),
                map.get('middle_name').getValue(),
                map.get('last_name').getValue(),
                map.get('email_id').getValue(),
                map.get('phone_number').getValue(),
                current_address,
                map.get('pan_card').getValue(),
                map.get('aadhar_card').getValue(),
                alt_address_objects,
                "profile photo",
                alt_phone_number,
            );
            alert("Registration Succesful");
            $('#employee_registration_form').hide();
            return displayData();
        }
        return false;
    });
    loadCountries(document.getElementById('current_country'));
    $('#current_country').change(function()
    {
        loadStates('current_country',document.getElementById('current_state'));
    });
});

function validatedForm()
{

    var valid = true;
    for(var m of map.keys())
    {
        if(map.get(m).getErrorMsg())
        {
            setErrorBorder(map.get(m));
            valid = false;
            console.log(map.get(m))
        }
    }
    if(!valid)
    {
        refresh_captcha();

    }
    else 
    {
        var current_address = new Address(map.get("current_address"),map.get("current_country"),map.get("current_state"),map.get("current_city"),map.get("current_pincode"));
        var employee = new Employee(map.get('first_name').getValue(),map.get('middile_name').getValue(),map.get('last_name').getValue()
        ,map.get('email_id').getValue(),map.get('phone_number').getValue(),current_address,map.get('pan_card').getValue(),map.get('aadhar_card').getValue()
        ,addresses,map.get('profile_photo'),alt_phone_number);
        // console.log("validated");
        $('#employee_registration_form').hide();
    }
    return false;

}

function loadCountries(country_field)
{
    var country_options;
    $.getJSON('json_files/countries.json',function(result)
    { 
        $.each(result, function(j,countries)
        {
            country_options+="<option value='"+countries.id+"'>"+countries.name+"</option>";
        });
        $("#"+country_field.id).html(country_options);
    });
}

function loadStates(country_id,state_field)
{
    var state_options;
        $.getJSON('json_files/states.json',function(result)
        {
            $.each(result, function(i,states)
            {
                if($("#"+country_id).val()==states.country_id)
                {
                    state_options+="<option value='"+states.id+"'>"+states.name+"</option>";
                }
            });
        $("#"+state_field.id).html(state_options);
        });
}

function loadImage(input)
{
    if (input.files && input.files[0])
    {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#profile_photo').attr('src', e.target.result);
        }
    reader.readAsDataURL(input.files[0]);
    }
}

function removeField()
{ 
    for(let i =0;i<alt_phone_number.length;i++)
    {
        if(map.get(arguments[0].id).getId() == alt_phone_number[i].getId())
        {
            alt_phone_number.splice(i,1);
        }
    }
    for(let i=0;i<arguments.length;i++)
    {
        map.delete(arguments[i].id); 
    }
    
}

function addPhoneField()
{

    var div_row = document.createElement('div');
    var div_input = document.createElement('div');

    div_input.className = 'div_input';
    div_row.className = 'div_row';
    div_row.id = 'phone_field'+alt_phone_number_ids;

    var level = document.createElement('level');
    var input = document.createElement('input');
    var span = document.createElement('span');
    var remove_button = document.createElement('button');

    level.className = 'level phone_field';
    input.className = 'input phone_field';
    span.className = 'error_msg phone_field';
    remove_button.className = 'remove';

    level.innerHTML = 'Alternative Number';
    input.placeholder = "Enter Alternative Number";
    input.id = "alt_phone_number"+alt_phone_number_ids;
    span.id = input.id+"_span";
    remove_button.id = 'remove_phone_field'+alt_phone_number_ids;
    input.onblur = function()
    {
        checkPhoneNumber(input);
    } 

    remove_button.onclick = function(){
        removeField(input);
        div_row.remove();
    }
    div_input.append(input,span);
    div_row.append(level,div_input,remove_button);

    $(div_row).insertAfter('#phone_div');

    map.set(input.id,new InputFields(input.id,"Enter Your Phone Number",""));
    alt_phone_number.push(new InputFields(input.id,"Enter Your Phone Number",""));
    alt_phone_number_ids++;
    return;

}

function addAddressField()
{
    var div_row = new Array(5);
    for(let i=0;i<div_row.length;i++)
    {
        div_row[i] = document.createElement('div');
        div_row[i].className = 'div_row';
        div_row[i].id = 'div_row'+alt_address_ids+i;
    }
     
    var heading = document.createElement('h3');
    var remove_button = document.createElement('button');
    var hr = document.createElement('hr');
    heading.innerHTML = 'Alternative Address  ';
    remove_button.className = 'remove';
    remove_button.id = 'remove_address_field'+alt_address_ids;
    

    var address_level , country_level , state_level , city_level , pincode_level;
    var address_span , country_span , state_span , city_span , pincode_span;
    var level = new Array(address_level, country_level , state_level , city_level , pincode_level);
    var span = new Array(address_span , country_span , state_span , city_span , pincode_span);
    for(let i = 0;i <level.length ; i++)
    {
        level[i] = document.createElement('level');
        level[i].className = 'level';
        span[i] = document.createElement('span');
        span[i].className = 'error_msg'; 
    }

    level[0].innerHTML = "Address";
    level[1].innerHTML = 'Country';
    level[2].innerHTML = 'State';
    level[3].innerHTML = 'City';
    level[4].innerHTML = 'Pincode';

    var address_textarea = document.createElement('textarea');
    var select_country = document.createElement('select');
    var select_state = document.createElement('select');
    var select_city = document.createElement('input');
    var pincode = document.createElement('input')
    address_textarea.className = 'textarea';
    select_country.className = 'select';
    select_state.className = 'select';
    select_city.className = 'input';
    pincode.className = 'input';

    address_textarea.id = 'alt_address'+alt_address_ids;
    select_country.id = 'alt_country'+alt_address_ids;
    select_state.id = 'alt_state'+alt_address_ids;
    select_city.id = 'alt_city'+alt_address_ids;
    pincode.id = 'alt_pincode'+alt_address_ids;
    span[0].id = address_textarea.id+"_span";
    span[1].id = select_country.id+"_span";
    span[2].id = select_state.id+"_span";
    span[3].id = select_city.id+"_span";
    span[4].id = pincode.id+"_span";


    div_row[0].append(level[0],address_textarea,span[0]);
    div_row[1].append(level[1],select_country,span[1]);
    div_row[2].append(level[2],select_state,span[2]);
    div_row[3].append(level[3],select_city,span[3]);
    div_row[4].append(level[4],pincode,span[4]);

    loadCountries(select_country);
    select_country.onchange  = function(){loadStates(select_country.id,select_state)}

    address_textarea.onblur = function(){checkAddress(address_textarea);}
    select_city.onblur = function(){checkAddress(select_city)}
    select_country.onblur = function(){checkAddress(select_country)};
    select_state.onblur = function(){checkAddress(select_state)};
    pincode.onblur  = function(){checkPincode(pincode)}

    var phone_field = document.createElement('div');
    phone_field.id = 'alt_address_field'+alt_address_ids;
    phone_field.append(heading, remove_button, hr, div_row[0], div_row[1], div_row[2],div_row[3],div_row[4])
    $(phone_field).insertAfter('#address_field');
    alt_address_ids++;
    remove_button.onclick = function() {
        removeField(address_textarea,select_country,select_state,select_city,pincode);
        $('#'+phone_field.id).remove();
    }

    addresses.push(new Address(address_textarea,select_country,select_state,select_city,pincode));

    map.set(address_textarea.id,new InputFields(address_textarea.id,"Enter Your Address",""));
    map.set(select_country.id,new InputFields(select_country.id,"Enter Your Country",""));
    map.set(select_state.id,new InputFields(select_state.id,"Enter Your State",""));
    map.set(select_city.id,new InputFields(select_city.id,"Enter Your City",""));
    map.set(pincode.id,new InputFields(pincode.id,"Enter Your Pincode",""));
    return;

}

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
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
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
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
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
        return;
    }
    setSuccessBorder(object);
}
function checkPhoneNumber(element)
{
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
    var pattern = /^[^0-1][0-9]{9}$/;
    var text = $.trim(object.getValue());
    if(text == "")
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
    if(object.getId().slice(0,3) == 'alt' &&  alt_phone_number.length > 1)
    {
        for(let i = 0;i<alt_phone_number.length;i++)
        {
            if($('#'+alt_phone_number[i].getId()).val() == object.getValue() && alt_phone_number[i].getId() != object.getId())
            {
                object.setErrorMsg("This Number is already Entered..!!");
                setErrorBorder(object);
                return;
            }
        }
    }
    setSuccessBorder(object);   
}   
function checkAddress(element)
{
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
    var pattern = /^[0-9 _ , / & a-zA-Z ]*$/;
    var text = $.trim(object.getValue());
    if(text == "")
    {
        object.setErrorMsg("Mandatory Field");
        setErrorBorder(object);
        return;
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Must contain only alphabets, number and ',''/''&' ");
        setErrorBorder(object);
        return;
    }
    object.setErrorMsg("");
    setSuccessBorder(object);
}
function checkCaptcha(element)
{
    var object = map.get(element);
    object.setValue($('#'+element).val());
    var text = $.trim(object.getValue());
    if( ans != text)
    {
        object.setErrorMsg("Invalid Captcha");
        setErrorBorder(object);
        return;
    }
    setSuccessBorder(object);
} 
function checkPanCardNumber(element)
{
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
    var pattern = /^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/;
    var text = $.trim(object.getValue());
    if(text == "")
    {
        object.setErrorMsg("Enter Your Pan Card Number");
        setErrorBorder(object);
        return; 
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Invalid Pancard Number");
        setErrorBorder(object);
        return;
    }
    else 
    {
        setSuccessBorder(object);
    }
}
function checkAadharCardNumber(element)
{
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
    var pattern = /^([0-9]){4}([-]){1}([0-9]){4}([-]){1}([0-9]){4}?$/;
    var text = $.trim(object.getValue());
    if(text == "")
    {
        object.setErrorMsg("Enter Your Aadhar Card Number");
        setErrorBorder(object);
        return; 
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Invalid AadharCard Pattern");
        setErrorBorder(object);
        return;
    }
    else 
    {
        setSuccessBorder(object);
    }
}
function checkPincode(element)
{
    var object = map.get(element.id);
    object.setValue($('#'+element.id).val());
    var pattern = /^([0-9]){6}?$/;
    if(object.getValue() == "")
    {
        object.setErrorMsg("Please Enter your Required Pincode");
        setErrorBorder(object);
        return;
    }
    if(!pattern.test(object.getValue()))
    {
        object.setErrorMsg("Invalid Pincode");
        setErrorBorder(object);
        return;
    }
    else {
        setSuccessBorder(object);
    }
}

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

function displayData()
{
    $('#employee_details').show()
    // console.log(employee.getName());
    // console.log(employee.getAddresses());
    // console.log(employee.getPancardNumber());

    $('#employee_full_name').text(employee.getName());
    $('#employee_email_id').text(employee.getEmailId());
    $('#employee_pan_card_number').text(employee.getPancardNumber());
    $('#employee_aadhar_card_number').text(employee.getAadharcardNumber());
    $('#employee_primary_phone_number').text(employee.getPrimaryPhoneNumber());
    if(employee.getAlternativePhoneNumbers().length > 0)
    {
        var phone_array = employee.getAlternativePhoneNumbers();
        console.log(phone_array)
        for (let i = 1; i < phone_array.length; i++)
        {
            var phone = phone_array[i].value;
            let div = document.createElement('div');
            div.className = 'div_row';
            let level = document.createElement('level');
            level.innerHTML = 'Alternative Phone Number '+i;
            let p = document.createElement('p');
            p.innerHTML = phone;
            div.append(level,p);
            $(div).insertAfter('#employee_phone_div');
        }
    }  
    console.log(employee.getCurrentAddress());
    $('#employee_current_address').text(employee.getCurrentAddress());
    if(employee.getAddresses().length > 0)
    {
        var address_array = employee.getAddresses();
        console.log(address_array.length);
        for (let i = 0; i<address_array.length; i++)
        {
            address = address_array[i];
            // console.log(address);
            let div = document.createElement('div');
            div.className = 'div_row';
            let level = document.createElement('level');
            level.innerHTML = 'Alternative Address '+i;
            let p = document.createElement('p');
            p.innerHTML = address;
            div.append(level,p);
            $(div).insertAfter('#employee_address_field');
        }
    }  
    return false;
}