class InputField {
    constructor(id, error_msg, is_valid) {
      this.id = id;
      this.error_msg = error_msg;
      this.is_valid = is_valid;
    }
    getId()
    {
        return  `${ this.id }`; 
    }
}
var inputFieldIds;
var name_pattern = /^[A-Za-z]+$/;
var email_pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
// var password_pattern = /^[a-zA-Z]+?[@#$.].(A-Z)+$/
var phone_pattern = "";
var ans;
var user = {
    firstName:"",
    middleName:"",
    lastName:"",
    emailId:"",
    gender:"",
    password:"",
    phoneNumber:"",
    altPhoneNumber:"",
    permanentAddress:"",
    currentAddress:"",
    currentCountry:"",
    currentState:"",
    currentCity:"",
    subscription:""
};


function validate_form()
{
    // return false;


    var return_statement = false;

    
    for (let i = 0 ; i < inputFieldIds.length; i++)
    {
        alert(inputFieldIds[i].getId());
        // if(!inputFieldIds[i].is_valid)
        // {
        //     console.log(inputFieldIds[i].value);
        //     setErrorBorder(document.forms['form'][inputFieldIds[i].id],"");
        //     return_statement = false;
        // 
        // else return false;
    }
    
    return false;

}

function setErrorBorder(element,error_message)
{
    // alert("hello");
    element.style.borderWidth = "2px";
    element.style.borderColor = "red";
    element.id.is_valid = false;

}

function setSuccessBorder(element)
{
    // alert("hello");
    element.style.borderWidth = "2px";
    element.style.borderColor = "green";
    element.id.is_valid = true;
}


function check_name(element)
{
    if(element == document.forms['form']['middle_name'])
    {
        if(element.value.length==0)
        {
            setSuccessBorder(element);
        }
    }
    if(element.value.length==1 || element.value.length>15)
    {
        setErrorBorder(element,"Name must be between 2 to 15 characters long.");
    }
    else if(element.value.length>1 && element.value.length<=15)
    {
        if(element.value.match(name_pattern)==null)
        {
            setErrorBorder(element,"Must contains only alphabets.");
        }
        else {
            setSuccessBorder(element);

        }
    }
    
    
}
function check_email(element)
{
    if(element.value.match(email_pattern)==null)
    {
        setErrorBorder(element,"Invalid Email Address.");
    }
    else{
        setSuccessBorder(element);
    }
}



function check_password(element)
{
    if (element == document.forms["form"]["password1"])
    {
        if(element.value.length<6)
        {
            setErrorBorder(element,"Password must contain atleast 6 characters");
        }
        else {
            setSuccessBorder(element);
        }
    }
    else if(element.value != document.forms["form"]["password1"].value)
    {
        setErrorBorder(element,"Password not matched");

    }
    else if(element.value == document.forms["form"]["password1"].value && element.value.length>5)
    {
        setSuccessBorder(element);
    }
    else{
        setErrorBorder(element,"Invalid Password")
    }

}

function check_phone_number(element)
{
    if(element.value.length!=9 || element.value.match(phone_pattern)==null)
    {
        setErrorBorder(element,"Invalid Phone Number.");
    }
    else if(element == document.forms['form']['alt_phone_number'] && element.value == document.forms['form']['phone_number'].value)
    {
        setErrorBorder(element,"Same Number Entered. You can keep this Blank");
    }
    else 
    {
        setSuccessBorder(element);
    }
}

function check_address(element)
{
    if(element == document.forms['form']['permanent_address'] && element.value.length==0)
    {
        setSuccessBorder(element);

    }
    if(element.value.length < 10 || element.value.length > 100)
    {
        setErrorBorder(element,"Address must have length between 10 to 100");
        return;
    }
    else {
        setSuccessBorder(element);
    }
}




function reload_captcha(){

    var country_select_element = document.getElementById("current_country");
    countries= ['Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Austrian Empire', 'Azerbaijan', 'Baden', 'Bahamas', 'The Bahrain', 'Bangladesh', 'Barbados', 'Bavaria', 'Belarus', 'Belgium', 'Belize', 'Benin (Dahomey)', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Brunswick and Lcneburg', 'Bulgaria', 'Burkina Faso (Upper Volta)', 'Burma', 'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Cayman Islands, The', 'Central African Republic', 'Central American Federation*', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo Free State, The', 'Costa Rica', 'Cote Ivoire (Ivory Coast)', 'Croatia', 'Cuba', 'Cyprus', 'Czechia', 'Czechoslovakia', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Duchy of Parma', 'East Germany', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia', 'Federal Government of Germany (1848-49)*', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia, The', 'Georgia', 'Germany', 'Ghana', 'Grand Duchy of Tuscany, The*', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Hanover*', 'Hanseatic Republics*', 'Hawaii*', 'Hesse*', 'Holy See', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kingdom of Serbia/Yugoslavia', 'Kiribati', 'Korea', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Lew Chew (Loochoo)', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mecklenburg-Schwerin', 'Mecklenburg-Strelitz', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Namibia', 'Nassau*', 'Nauru', 'Nepal', 'Netherlands, The', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North German Confederation', 'North German Union*', 'North Macedonia', 'Norway', 'Oldenburg*', 'Oman', 'Orange Free State', 'Pakistan', 'Palau', 'Panama', 'Papal States', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Piedmont-Sardinia*', 'Poland', 'Portugal', 'Qatar', 'Republic of Genoa*', 'Republic of Korea (South Korea)', 'Republic of the Congo', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Schaumburg-Lippe*', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Tajikistan', 'Tanzania', 'Texas*', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Two Sicilies*', 'Uganda', 'Ukraine', 'Union of Soviet Socialist Republics', 'United Arab Emirates', 'United Kingdom', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Venezuela', 'Vietnam', 'crttemberg*', 'Yemen', 'Zambia', 'Zimbab'];
    for(let i =0 ; i<countries.length;i++)
    {
        var child = document.createElement('option');
        child.value = countries[i];
        var node = document.createTextNode(countries[i]);
        child.appendChild(node);
        country_select_element.appendChild(child);

    }
    
    canvas.width = canvas.width;
    var captcha=document.getElementById("canvas");
    var context=captcha.getContext("2d");
    var operator=["+","-","*","/"];

    var operand1=Math.floor(Math.random() * 10)+1; 
    var operand2=Math.floor(Math.random() * 10)+1;
    var symbol=operator[Math.floor(Math.random()*4)];
    if(symbol=='/' && operand1%operand2 != 0)
    {
        symbol="+";
    }
    // var equal="  =";
    context.font = "60px Arial";
    context.fillText(operand1,10,80);
    context.fillText(symbol,80,80);
    context.fillText(operand2,150,80);
    // context.fillText(equal,190,80);
    
    switch(symbol)
    {
        case "+": ans=operand1+operand2;
                    break;
        case "-": ans=operand1-operand2;
                    break;
        case "/": ans=operand1/operand2;
                    break;
        case "*": ans=operand1*operand2;
        
    }

    inputFieldIds = ["first_name","middle_name","last_name"];

    var first_name = new InputField(document.forms['form']['first_name'].id , "", false);
    var middle_name = new InputField(document.forms['form']['middle_name'].id,"",false);
    var last_name = new InputField(document.forms['form']['last_name'].id,"",false);
    var email_id = new InputField(document.forms['form']['email_id'].id,"",false);
    var gender = new InputField(document.forms['form']['gender'].id,"",false);
    var password1 = new InputField(document.forms['form']['password1'].id,"",false);
    var password2 = new InputField(document.forms['form']['password2'].id,"",false);
    var phone_number = new InputField(document.forms['form']['phone_number'].id,"",false);
    var alt_phone_number = new InputField(document.forms['form']['alt_phone_number'].id,"",true);
    var current_address = new InputField(document.forms['form']['current_address'].id,"",false);
    var permanent_address = new InputField(document.forms['form']['permanent_address'].id,"",true);
    var current_country = new InputField(document.forms['form']['current_country'].id,"",false);
    var current_state = new InputField(document.forms['form']['current_state'].id,"",false);
    var current_city = new InputField(document.forms['form']['current_city'].id,"",false);
    var subscription = new InputField(document.forms['form']['subscription'].id,"",true);
    var answer_captcha = new InputField(document.forms['form']['answer_captcha'].id,"",false);


}