class Employee  
{
    constructor(first_name,middle_name,last_name,email_id,phone_number,address,profile_photo)
    {
        this.first_name = first_name;
        this.middle_name = middle_name;
        this.last_name = last_name;
        this.email_id = email_id;
        this.phone_number = phone_number;
        this.address = address;
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

$(document).ready(function()
{
    $('#div_container').addClass('blue_class');
    phone_number = new Array();
    address = new Array();
});