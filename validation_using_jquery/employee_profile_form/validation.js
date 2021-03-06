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
var phone_number_map = new Map();
var addresses_map = new Map();
var country_map = new Map();
var state_map = new Map();

$(document).ready(function()
{
    $('#employee_details').hide();
    
    map.set("profile_pic", new InputFields("profile_pic","Upload Profile Photo", ""))
        .set("first_name",new InputFields( "first_name" , "Enter First Name.","" ))
        .set("middle_name",new InputFields("middle_name" , "" ,"" ))
        .set("last_name",new InputFields("last_name" , "Enter Last Name.","" ))
        .set("email_id",new InputFields("email_id" , "Enter Email Address" ))
        .set("pan_card",new InputFields( 'pan_card' , "Enter Your Pan card Number", ""))
        .set("aadhar_card",new InputFields( "aadhar_card" , "Enter Your Aadhar card Number", "" ))
        .set("phone_number",new InputFields( "phone_number" , "Enter Your Phone Number", "" ))
        .set("current_address",new InputFields( "current_address" , "Enter Your Current Address", "" ))
        .set("current_country",new InputFields( "current_country" , "Select Current Country", "" ))
        .set("current_state",new InputFields( "current_state" , "Select Current State", "" ))
        .set("current_city",new InputFields( "current_city" , "Select Current City", "" ))
        .set("current_pincode",new InputFields("current_pincode","Enter your Pincode",""))
        .set("answer_captcha",new InputFields("answer_captcha","Invalid Captcha",""));

    phone_number_map.set('phone_number' , "");

    loadCountries($('#current_country'));
    refresh_captcha();
    loadCountryStateMap();
    
    $('#submit_button').click(function()
    {
        console.log(state_map)
        var valid = true;
        for(var key of map.keys())
        {
            if(key == "answer_captcha")
            {
                valid = checkCaptcha();
            }
            else if(map.get(key).getErrorMsg())
            {
                // $('html, body').animate({
                //     'scrollTop' : $("#"+key).position().top},1000);
                setErrorBorder(map.get(key));
                valid = false;
            }
        }
        if(valid) 
        {
            alt_addresses = new Array()
            for (var key of addresses_map.keys())
            {
                var address = addresses_map.get(key);
                alt_addresses.push(new Address( $(address.getAddress()).val(),
                                                $(address.getCountry()).val(),
                                                $(address.getState()).val(),
                                                $(address.getCity()).val(),
                                                $(address.getPincode()).val() ));
            }
            alt_phone_numbers = new Array()
            for (var key of phone_number_map.keys())
            {
                alt_phone_numbers.push(phone_number_map.get(key));
            }
            var current_address = new Address(
                map.get('current_address').getValue(),
                map.get('current_country').getValue(),
                map.get('current_state').getValue(),
                map.get('current_city').getValue(),
                map.get('current_pincode').getValue()
            );
            employee = {
                employee_name : map.get("first_name").getValue() + " " + map.get("middle_name").getValue() + " " + map.get('last_name').getValue(),
                employee_email : map.get("email_id").getValue(),
                employee_primary_phone_number : map.get("phone_number").getValue(),
                employee_current_address : current_address,
                pan_card : map.get("pan_card").getValue(),
                aadhar_card : map.get("aadhar_card").getValue(),
                alternative_phone_numbers : alt_phone_numbers,
                alternative_addresses : alt_addresses,
                profile_photo : map.get("profile_pic").getValue()
            }
            alert("Registration Succesful");
            $('#employee_registration_form').hide();
            return displayData();
        }
        else 
        {   
            $("html, body").animate({ scrollTop: "0" }
            );
        }
        return false;
    });
});

function loadCountryStateMap()
{
    $.getJSON('json_files/countries.json',function(countries)
    { 
        for(let i = 0; i < countries.length; i++)
        {
            country_map.set(""+countries[i].id , countries[i].name);
        }
    });
    $.getJSON('json_files/states.json',function(states)
    { 
        for(let i = 0; i < states.length; i++)
        {
            state_map.set(states[i].id , states[i].name);
        }
    });  
}
function loadCountries(country_field)
{
    var country_options = "";
    $.getJSON('json_files/countries.json',function(result)
    { 
        $.each(result, function(j,countries)
        {
            country_options+="<option value='"+countries.id+"'>"+countries.name+"</option>";
        });
        $(country_field).append(country_options);
    });
}
function loadStates(country_field)
{
    var state_field = $(country_field).parent().parent().next().children('.div_input').children('select');
    var country_field_value = $(country_field).val();
    // $('#'+state_field.id).
    var state_options = "<option value=''> Select State </option>";
    $.getJSON('json_files/states.json',function(result)
    {
        $.each(result, function(i,states)
        {
            if(country_field_value == states.country_id)
            {
                state_options+="<option value='"+states.id+"'>"+states.name+"</option>";
            }
        });
    $(state_field).html(state_options);
    });
}
function loadImage(input)
{
    if (input.files && input.files[0])
    {
        
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#profile_pic').attr('src', e.target.result);
            map.get('profile_pic').setErrorMsg("");
            map.get('profile_pic').setValue(e.target.result);
            setSuccessBorder(map.get('profile_pic'));
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function removePhoneField(element)
{ 
    var phone_field_id = $(element).siblings('.div_input').children('input').attr('id');
    phone_number_map.delete(phone_field_id);
    $(element).parent().remove();
}
function removeAddressField(element)
{
    var address_map_id = $(element).attr('id').slice(20);
    addresses_map.delete("alternative_address"+address_map_id);
    $(element).parent().remove();
}

function addPhoneField()
{
    var alternative_phone_field = $('#phone_div').clone();
    
    var input = alternative_phone_field.children('.div_input').children('input').attr({'id' : 'alt_phone_number'+alt_phone_number_ids,  "placeholder" : "Enter Alternative Number"});
    input.css({"border-color": "black", "border-width":"1px", "box-shadow" : "0px 0px  0px 0px"}); 
    $(input).val("");
    var level = alternative_phone_field.children('level').text('Alternative Number');
    var button = $("<button></button>").attr({"id" : 'remove_phone_field'+alt_phone_number_ids , "class" : "remove", 'onclick' : 'removePhoneField(this)'});    alternative_phone_field.attr('class' , 'div_row_phone');
    input.next().text("");
    alternative_phone_field.append(button);
    $(alternative_phone_field).insertAfter('#phone_div');
    map.set($(input).attr('id') , new InputFields($(input).attr('id'),"Enter Your Phone Number",""));
    phone_number_map.set($(input).attr('id') , "");
    alt_phone_number_ids++;
    return;
}

function addAddressField()
{
    var alternative_address_field = $('#address_field').clone();
    $(alternative_address_field).insertAfter('#address_field');

    alternative_address_field.children('button').attr({'class' : 'remove', 'id' : 'remove_address_field'+alt_address_ids, 'onclick' : 'removeAddressField(this)'}) 
    var address = alternative_address_field.children('.div_row').children('.div_input').children('#current_address').attr({'id' : 'alt_address'+alt_address_ids}).val(""); 
    var country = alternative_address_field.children('.div_row').children('.div_input').children('#current_country').attr({'id' : 'alt_country'+alt_address_ids});
    country.val($(country).val());
    var state = alternative_address_field.children('.div_row').children('.div_input').children('#current_state').attr({'id' : 'alt_state'+alt_address_ids}) 
    state.empty();
    var city = alternative_address_field.children('.div_row').children('.div_input').children('#current_city').attr({'id' : 'alt_city'+alt_address_ids}).val("")
    var pincode = alternative_address_field.children('.div_row').children('.div_input').children('#current_pincode').attr({'id' : 'alt_pincode'+alt_address_ids}).val("")
    alternative_address_field.children('h3').text('Alternative Address');
    address.css({"border-color": "black", "border-width":"1px", "box-shadow" : "0px 0px  0px 0px"});
    country.css({"border-color": "black", "border-width":"1px", "box-shadow" : "0px 0px  0px 0px"});
    state.css({"border-color": "black", "border-width":"1px", "box-shadow" : "0px 0px  0px 0px"});
    city.css({"border-color": "black", "border-width":"1px", "box-shadow" : "0px 0px  0px 0px"});
    pincode.css({"border-color": "black", "border-width":"1px", "box-shadow" : "0px 0px  0px 0px"});
    alternative_address_field.children('.div_row').children('.div_input').children('span').text("");
    addresses_map.set('alternative_address'+alt_address_ids , new Address(address, country, state, city, pincode));
    map.set($(address).attr('id'),new InputFields($(address).attr('id'),"Enter Your Address",""))
        .set($(country).attr('id'),new InputFields(country.attr('id'),"Enter Your Country",""))
        .set($(state).attr('id'),new InputFields(state.attr('id'),"Enter Your State",""))
        .set($(city).attr('id'),new InputFields(city.attr('id'),"Enter Your City",""))
        .set($(pincode).attr('id'),new InputFields(pincode.attr('id'),"Enter Your Pincode",""));

    alt_address_ids++;
    return;
}
function capitilizes(element)
{
    element.value = element.value.toUpperCase();
}

function setErrorBorder(object)
{
    $("#"+object.getId()).css({"border-color": "red", "box-shadow" : "0px 0px  5px 2px rgb(255, 100, 100)"}); 
    $('#'+object.getId()).next().text(object.getErrorMsg());
}
function setSuccessBorder(object)
{
    $("#"+object.getId()).css({"border-color": "lightgreen" , "box-shadow" : "0px 0px  5px 2px lightgreen"}); 
    object.setErrorMsg("");
    $('#'+object.getId()).next().text(object.getErrorMsg());
}
function setNormalBorder(object)
{
    $("#"+object.getId()).css({"border-color": "black", "border-width":"1px"}); 
    object.setErrorMsg("");
    $('#'+object.getId()).next().text(object.getErrorMsg());
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
    var id = $(element).attr("id");
    var object = map.get(id);
    object.setValue($('#'+id).val());
    var pattern = /^[^0-1][0-9]{9}$/;
    var text = $.trim(object.getValue());
    if(text == "")
    {
        object.setErrorMsg("Enter your Phone number.")
        setErrorBorder(object);
    }
    if(!pattern.test(text))
    {
        object.setErrorMsg("Number should not include 0 or 1 at begining and should contain only number");
        setErrorBorder(object);
        return;
    }
    for(var key of phone_number_map.keys())
    {
        if(phone_number_map.get(key) == object.getValue() && key != object.getId())
        {
            object.setErrorMsg("This Number has already been Entered..!!");
            setErrorBorder(object);
            return;
        }
    }
    phone_number_map.set(object.getId() , object.getValue());
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
function checkCaptcha()
{
    var object = map.get('answer_captcha');
    object.setValue($('#answer_captcha').val());
    var text = $.trim(object.getValue());
    if( ans != text)
    {
        object.setErrorMsg("Invalid Captcha");
        setErrorBorder(object);
        return false;
    }
    setSuccessBorder(object);
    return true;
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
        object.setErrorMsg("Invalid Pancard Number. Eg: JDYSD7654K ");
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
        object.setErrorMsg("Invalid AadharCard Pattern. Eg: XXXX-XXXX-XXXX");
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
    context.font = "60px Schoolbell";
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
    $('#display_profile_pic').attr('src' , employee.profile_photo)
    $('#employee_full_name').text(employee.employee_name);
    $('#employee_email_id').text(employee.employee_email);
    $('#employee_pan_card_number').text(employee.pan_card);
    $('#employee_aadhar_card_number').text(employee.aadhar_card);
    $('#employee_primary_phone_number').text(employee.employee_primary_phone_number);
    if(employee.alternative_phone_numbers.length > 1)
    {
        var phone_array = employee.alternative_phone_numbers;
        for (let i = 1; i < phone_array.length; i++)
        {
            var phone = phone_array[i].value;
            let div = $('<div></div>').attr({'class' : 'div_row'});
            let level = $('<level></level>').text('Alternative Phone Number'+i).addClass('level');
            let p = $('<p></p>').text(phone_array[i]);
            div.append(level,p);
            $(div).insertAfter('#employee_phone_div');
        }
    }  
    address = employee.employee_current_address
    displayAddress("Current Address" , address);
    let alt_addresses = employee.alternative_addresses;
    for(var i = 0; i < alt_addresses.length; i++)
    {
        address = alt_addresses[i];
        displayAddress("Alternative Address" , address);
    }
    return false;
}
function displayAddress(title , address)
{
    var div = $('<div></div>').addClass('div_row');
    var p = $('<p></p>').html( "Address: " + address.getAddress() + "<br>" +
                                "Country: " + country_map.get(address.getCountry()) + "<br>" +
                                "State: " + state_map.get(address.getState()) + "<br>" +
                                "City: " + address.getCity() + "<br>" +
                                "Pincode: " + address.getPincode() + "<br>");
    var level = $('<level></level>').addClass('level').text(title);
    div.append(level,p);
    $('#employee_address_field').append(div);
}