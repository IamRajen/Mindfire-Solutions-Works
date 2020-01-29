
var ans;
var user = {
    firstName:"",
    lastName:"",
    emailId:"",
    password:"",
    phoneNumber:"",
    altPhoneNumber:"",
    address:"",
    altAddress:"",
    country:"",
    subscription:""
};

function validate_form()
{
    
    if(ans != document.forms["form"]["captcha_output"].value)
    {
        alert("captcha Incorrect..!!");
        reload_captcha();
    }
    if(user.firstName=="" || user.lastName==""|| user.emailId==""||user.password==""||user.phoneNumber==""||user.address==""||user.country=="")
    {
        return false;
    }
    else 
    {
        // alert(user);
        return true;
    }
    
    // var first_name  = document.forms["form"]["first_name"].value;
    // var last_name  = document.forms["form"]["last_name"].value;
    // var email_id  = document.forms["form"]["email_id"].value;
    // var password1  = document.forms["form"]["password1"].value;
    // var password2  = document.forms["form"]["password2"].value;
    // var phone_number  = document.forms["form"]["phone_number"].value;
    // var alt_phone_number  = document.forms["form"]["alt_phone_number"].value;
    // var address  = document.forms["form"]["address"].value;
    // var alt_address  = document.forms["form"]["alt_address"].value;
    // var country  = document.forms["form"]["country"].value;
    // var subscription  = document.forms["form"]["subscription"].value;
    // var s = first_name+"\n"+last_name+"\n"+email_id+"\n"+country+"\n"+subscription;
    // 
}

function checkFields(_id)
{
    
    var _pattern;
    // alert(user)
    switch(_id.id){
        case "first_name":
            _pattern = /^[A-Za-z]+$/;
            if(_id.value.length<2 ||  _id.value.match(_pattern)==null)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                _id.focus();
            }
            else {
                user.firstName=_id.value;
                // alert(user.firstName);
                _id.style.borderColor="white"
            }
            break;

        case "last_name":
            _pattern = /^[A-Za-z]+$/;
            if(_id.value.length<2 ||  _id.value.match(_pattern)==null)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px";
                _id.focus();
            }
            else {
                user.lastName=_id.value;
                _id.style.borderColor="white"
            }
            break;

        case "email_id":
            _pattern = /^[a-zA-z][a-zA-z-0-9@#$%&*\.]+[@][a-z]+.com$/
            if(_id.value.length<2 ||  _id.value.match(_pattern)==null)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                _id.focus();
            }
            else {
                user.emailId=_id.value;
                _id.style.borderColor="white"
            }
            break;
        case "password1":
            if(_id.value.length<6)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                _id.focus();
            }else {
                user.password=_id.value;
                _id.style.borderColor="white"
            }
            break; 
        case "password2":
            if(document.getElementById("password1").value != _id.value)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                document.getElementById("password1").focus();
                document.getElementById("password1").style.borderColor = 'red';
            }
            else {
                _id.style.borderColor="white"
            }
            break;
        case "phone_number":
            if(_id.value.length !=10)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                _id.focus();
            }
            else 
            {
                _pattern = /^[6789][0-9]+/
                if(_id.value.match(_pattern)==null)
                {
                    _id.style.borderColor="red";
                    _id.style.borderWidth="2px"
                    _id.focus();
                }
                else {
                    user.phoneNumber=_id.value;
                    _id.style.borderColor="white"
                }
            }
            break;
        case "alt_phone_number":
            if(_id.value.length != 10)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
            }
            else 
            {
                _pattern = /^[6789][0-9]+/
                if(_id.value.match(_pattern)==null)
                {
                    _id.style.borderColor="red";
                    _id.style.borderWidth="2px"
                }
                else {
                    user.altPhoneNumber=_id.value;
                    _id.style.borderColor="white"
                }
            }
            break;
        case "address":
            if(_id.value=="" || _id.value.length<10)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                _id.focus();
            }
            else {
                user.address=_id.value;
                _id.style.borderColor="white"
            }
            break;
        case "alt_address":
            user.altAddress=_id.value;
            break;
        case "country":
            if(_id.value==null)
            {
                _id.style.borderColor="red";
                _id.style.borderWidth="2px"
                _id.focus();
            }
            else {
                user.country=_id.value;
                _id.style.borderColor="white"
            }
            break;
        case "subscription":
            user.subscription=_id.value;
            break;   

    }
}

function reload_captcha(){

    var country_option_str="";
    var country_select_element = document.getElementById("country");
    countries= ['Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Austrian Empire', 'Azerbaijan', 'Baden', 'Bahamas', 'The Bahrain', 'Bangladesh', 'Barbados', 'Bavaria', 'Belarus', 'Belgium', 'Belize', 'Benin (Dahomey)', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Brunswick and Lcneburg', 'Bulgaria', 'Burkina Faso (Upper Volta)', 'Burma', 'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Cayman Islands, The', 'Central African Republic', 'Central American Federation*', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo Free State, The', 'Costa Rica', 'Cote Ivoire (Ivory Coast)', 'Croatia', 'Cuba', 'Cyprus', 'Czechia', 'Czechoslovakia', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Duchy of Parma', 'East Germany', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia', 'Federal Government of Germany (1848-49)*', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia, The', 'Georgia', 'Germany', 'Ghana', 'Grand Duchy of Tuscany, The*', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Hanover*', 'Hanseatic Republics*', 'Hawaii*', 'Hesse*', 'Holy See', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kingdom of Serbia/Yugoslavia', 'Kiribati', 'Korea', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Lew Chew (Loochoo)', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mecklenburg-Schwerin', 'Mecklenburg-Strelitz', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Namibia', 'Nassau*', 'Nauru', 'Nepal', 'Netherlands, The', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North German Confederation', 'North German Union*', 'North Macedonia', 'Norway', 'Oldenburg*', 'Oman', 'Orange Free State', 'Pakistan', 'Palau', 'Panama', 'Papal States', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Piedmont-Sardinia*', 'Poland', 'Portugal', 'Qatar', 'Republic of Genoa*', 'Republic of Korea (South Korea)', 'Republic of the Congo', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Schaumburg-Lippe*', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Tajikistan', 'Tanzania', 'Texas*', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Two Sicilies*', 'Uganda', 'Ukraine', 'Union of Soviet Socialist Republics', 'United Arab Emirates', 'United Kingdom', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Venezuela', 'Vietnam', 'crttemberg*', 'Yemen', 'Zambia', 'Zimbab'];
    for(let i =0 ; i<countries.length;i++)
    {
        var child = document.createElement('option');
        child.value = countries[i];
        var node = document.createTextNode(countries[i]);
        child.appendChild(node);
        country_select_element.appendChild(child);

    }
    
    var a ,b;


    a = Math.floor(Math.random()*20 +11);
    b = Math.floor(Math.random()*20 +11);
    var signArray = ['+','-','/','*'];
    var sign = signArray[Math.floor(Math.random()*4)];
    if (sign=='/' && a%b!=0)
    {
        sign = '+';
    }

    switch (sign)
    {
        case '+':
            ans = a+b;
            break;
        case '-':
            ans = a-b;
            break;
        case '*':
            ans = a*b;
            break;
        case '/':
            ans = a/b;
            break;
    }


    document.getElementById('captcha').innerHTML = a+" "+sign+" "+b;
}