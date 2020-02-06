class Employee  
{
    constructor(first_name,middle_name,last_name,email_id,phone_number,alt_phone_numbers,pan_card_number,aadhar_card_number,
                current_address,addresses,profile_photo)
    {
        this.first_name = first_name;
        this.middle_name = middle_name;
        this.last_name = last_name;
        this.email_id = email_id;
        this.phone_number = phone_number;
        this.current_address = current_address;
        this.profile_photo = profile_photo;
        this.pan_card_number = pan_card_number;
        this.aadhar_card_number = aadhar_card_number;
        this.alt_phone_numbers = alt_phone_numbers;
        this.addresses = addresses;
        this.profile_photo = profile_photo;
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
class inputFieldIds
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


$(document).ready(function()
{
    $('#div_container').addClass('blue_class');
    alt_phone_number = new Array();
    addresses = new Array();
    profile_photo = new inputFieldIds("profile_photo","Upload Profile Photo", "");
    first_name = new inputFieldIds( "first_name" , "Enter First Name.","" );
    middle_name = new inputFieldIds("middle_name" , "" ,"" );
    last_name = new inputFieldIds("last_name" , "Enter Last Name.","" );
    email_id = new inputFieldIds("email_id" , "Enter Email Address" );
    phone_number = new inputFieldIds( "phone_number" , "Enter Your Phone Number", "" );
    current_address = new inputFieldIds( "current_address" , "Enter Your Current Address", "" );
    current_country = new inputFieldIds( "current_country" , "Select Current Country", "" );
    current_state = new inputFieldIds( "current_state" , "Select Current State", "" );
    current_city = new inputFieldIds( "current_city" , "Select Current City", "" );
    current_pincode = new inputFieldIds("current_pincode","Enter your Pincode","");
    pan_card_number = new inputFieldIds( 'pan_card_number' , "Enter Your Pan card Number", "");
    aadhar_card_number = new inputFieldIds( "aadhar_card_number" , "Enter Your Aadhar card Number", "" );
    input_fields_array = new Array(first_name,middle_name,last_name,email_id,phone_number,current_address
                            ,current_country,current_state,current_city,current_pincode,pan_card_number,aadhar_card_number);

    $('#add_phone_field').click(function()
    {
        addPhoneField();
    });
    
    $('#ad_address_field').click(function()
    {
        addAddressField();
    });
});

function addPhoneField()
{
    var phone_address_div = document.createElement('div');
    var div_inner_col_input = document.createElement('div');
    var div_inner_col_button = document.createElement('div');

    phone_address_div.className = 'phone_address_div shadow'
    div_inner_col_input.className = 'div_inner_col';
    div_inner_col_button.className = 'div_inner_col div_button'

    var level = document.createElement('level');
    var input = document.createElement('input');
    var span = document.createElement('span');
    var minus_button = document.createElement('button');

    phone_address_div.id = 'phone_address_div'+alt_phone_number_ids;
    level.className = 'level';
    level.innerHTML = "Alternative Phone Number" ;

    input.className = 'input';
    input.placeholder = "Enter Alternative Number";
    input.id = "alt_phone_number"+alt_phone_number_ids;

    span.className = 'error_msg';
    span.id = 'alt_phone_number_span'+alt_phone_number_ids;

    minus_button.className = 'remove';
    minus_button.id = 'remove_button'+alt_phone_number_ids;
    minus_button.onclick = function(){
        phone_address_div.remove();
    }
    
    div_inner_col_input.append(level);
    div_inner_col_input.append(input);
    div_inner_col_input.append(span);

    div_inner_col_button.append(minus_button);

    phone_address_div.append(div_inner_col_input);
    phone_address_div.append(div_inner_col_button);
    $('#phone_address_div').append(phone_address_div);
    alt_phone_number.push(input);
    alt_phone_number_ids++;
    return;
}

function addAddressField()
{
    
}