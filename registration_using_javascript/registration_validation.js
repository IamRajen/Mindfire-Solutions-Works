class InputField {
    constructor(id, error_msg, is_valid) {
      this.id = id;
      this.error_msg = error_msg;
      this.is_valid = is_valid;
    }
    getId()
    {
        return this.id; 
    }
    geterror_msg()
    {
        return this.error_msg;
    }
    getis_valid()
    {
        return this.is_valid;
    }
    
    setErrorMsg(msg)
    {
        this.error_msg = msg;
    }
    setIsValid(value)
    {
        this.is_valid = value;
    }

}
var inputFieldIds = new Array();

var name_pattern = /^[A-Za-z']+$/;
var email_pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
var phone_pattern = /^[^0-1][0-9]{9}$/;

var ans;

function validate_form()
{
    if(validate())
    {
        return false;
    }
    else{
        return true;
    }

}

function validate()
{
    let return_statement = true;
    var s="";
    if(document.forms['form']['answer_captcha'].value != ans)
    {
        inputFieldIds[15].setIsValid(false);
        setErrorBorder(document.forms['form']['answer_captcha']);
        inputFieldIds[15].setErrorMsg("Invalid Captcha");
        spanVisible("answer_captcha_span",inputFieldIds[15].geterror_msg());
    }
    else {
        setSuccessBorder(document.forms['form']['answer_captcha']);
        inputFieldIds[15].setIsValid(true);
        inputFieldIds[15].setErrorMsg("");
        spanHidden("answer_captcha_span");
    }

    check_password1();
    check_password2();
    

    for (let i = 0 ; i < inputFieldIds.length; i++)
    {
        var span;
        console.log(inputFieldIds[i].getId()+" "+inputFieldIds[i].geterror_msg()+" "+inputFieldIds[i].getis_valid());
        if(!inputFieldIds[i].getis_valid())
        {
            if(inputFieldIds[i].getId()=='gender')
            {
                document.getElementById("gender_span").innerHTML = inputFieldIds[i].geterror_msg();
                document.getElementById("gender_span").style.visibility = "visible";
                setErrorBorder(document.getElementById('gender_bor'));
            }
            else{
                span = document.getElementById(inputFieldIds[i].getId()+"_span");
                span.innerHTML = inputFieldIds[i].geterror_msg();
                span.style.visibility = "visible";
                setErrorBorder(document.forms['form'][inputFieldIds[i].getId()]);
                
            }
            return_statement = false;
        }
        else if(inputFieldIds[i].getis_valid() && inputFieldIds[i].getId() != "gender" && inputFieldIds[i].getId() != 'subscription')
        {
            span = document.getElementById(inputFieldIds[i].getId()+"_span");
            span.style.visibility = "hidden";
            setSuccessBorder(document.forms['form'][inputFieldIds[i].getId()]);
        }
        else if(inputFieldIds[i].getis_valid() && inputFieldIds[i].getId() == 'gender')
        {
            span = document.getElementById(inputFieldIds[i].getId()+"_span");
            span.style.visibility = "hidden";
            setSuccessBorder(document.getElementById('gender_bor'));
        }
    }
    if(return_statement)
    { 
        alert("Successfully Registered. Click OK to proceed");
        return false;}
    else {
        alert("Failed to Registered. Many Fields are not entered correctely..!!");
        return true;
    }
}


function setErrorBorder(element)
{
    element.style.borderWidth = "2px";
    element.style.borderColor = "red";   
}

function setSuccessBorder(element)
{
    element.style.borderWidth = "2px";
    element.style.borderColor = "green";
    

}

function spanHidden(element)
{
    document.getElementById(element).style.visibility = "hidden";
}

function spanVisible(element,msg)
{
    document.getElementById(element).innerHTML = msg;
    document.getElementById(element).style.visibility = "visible";
}


function check_first_name()
{
    var element = document.forms['form']['first_name'];
    if(element.value.trim() == " ")
    {
        setSuccessBorder(element);
        inputFieldIds[0].setErrorMsg("Enter Your Name");
        inputFieldIds[0].setIsValid(false);
        spanVisible("first_name_span","Enter Your Name");
        return;
    }
    if(element.value.trim().match(name_pattern)==null)
    {
        setErrorBorder(element);
        inputFieldIds[0].setErrorMsg('Please use only characters');
        inputFieldIds[0].setIsValid(false);
        spanVisible("first_name_span","Please use only characters");
        return;
    }
    if(element.value.trim().length>15)
    {
        setErrorBorder(element);
        inputFieldIds[0].setErrorMsg('Name must be less than 15 characters');
        inputFieldIds[0].setIsValid(false);
        spanVisible("first_name_span",'Name must be less than 15 characters');
        return;
    }
    else {
        setSuccessBorder(element);
        inputFieldIds[0].setErrorMsg("");
        inputFieldIds[0].setIsValid(true);
        spanHidden("first_name_span");
        return;
    }

}
function check_middle_name()
{
    var element = document.forms['form']['middle_name'];
    if(element.value.trim() == "")
    {
        setSuccessBorder(element);
        inputFieldIds[1].setErrorMsg("");
        inputFieldIds[1].setIsValid(true);
        spanHidden("middle_name_span")
        return;
    }
    if(element.value.trim().match(name_pattern)==null)
    {
        setErrorBorder(element);
        inputFieldIds[1].setErrorMsg('only characters');
        inputFieldIds[1].setIsValid(false);
        spanVisible("middle_name_span",inputFieldIds[1].geterror_msg())
        return;
    }
    if(element.value.trim().length>15)
    {
        setErrorBorder(element);
        inputFieldIds[1].setErrorMsg('Upto 15 characters');
        inputFieldIds[1].setIsValid(false);
        spanVisible("middle_name_span",inputFieldIds[1].geterror_msg())
        return;
    }
    else {
        setSuccessBorder(element)
        inputFieldIds[1].setErrorMsg("");
        inputFieldIds[1].setIsValid(true);
        spanHidden("middle_name_span",)
        return;
    }

}
function check_last_name()
{
    var element = document.forms['form']['last_name'];
    if(element.value.trim() == " ")
    {
        setErrorBorder(element);
        inputFieldIds[2].setErrorMsg("Enter Surame");
        inputFieldIds[2].setIsValid(false);
        spanVisible("last_name_span",inputFieldIds[2].geterror_msg())
        return;
    }
    if(element.value.trim().match(name_pattern)==null)
    {
        setErrorBorder(element);
        inputFieldIds[2].setErrorMsg('Please use only characters');
        inputFieldIds[2].setIsValid(false);
        spanVisible("last_name_span",inputFieldIds[2].geterror_msg())
        return;
    }
    if(element.value.trim().length>15)
    {   
        setErrorBorder(element);
        inputFieldIds[2].setErrorMsg('Name must be less than 15 characters');
        inputFieldIds[2].setIsValid(false);
        spanVisible("last_name_span",inputFieldIds[2].geterror_msg())
        return;
    }
    else {
        setSuccessBorder(element);
        inputFieldIds[2].setErrorMsg("");
        inputFieldIds[2].setIsValid(true);
        spanHidden("last_name_span");
        return;
    }

}
function check_email()
{
    var element = document.forms['form']['email_id'];
    if(element.value.trim() =="")
    {
        setErrorBorder(element);
        inputFieldIds[3].setErrorMsg("Please Enter your Email ID");
        inputFieldIds[3].setIsValid(false);
        spanVisible("email_id_span",inputFieldIds[3].geterror_msg());
    }
    if(element.value.trim().match(email_pattern)==null)
    {
        setErrorBorder(element);
        inputFieldIds[3].setErrorMsg("Invalid Email Address.");
        inputFieldIds[3].setIsValid(false);
        spanVisible("email_id_span",inputFieldIds[3].geterror_msg());
    }
    else{
        setSuccessBorder(element);
        inputFieldIds[3].setErrorMsg("");
        inputFieldIds[3].setIsValid(true);
        spanHidden("email_id_span");
    }
}
function check_gender()
{
    if(document.forms['form']['gender'].value == "")
    {
        inputFieldIds[4].setIsValid(false);
        inputFieldIds[4].setErrorMsg("Please Select your Gender");
        setErrorBorder(document.getElementById('gender_bor'));
        spanVisible("gender_span",inputFieldIds[4].geterror_msg());
    }
    else {
        inputFieldIds[4].setIsValid(true);
        inputFieldIds[4].setErrorMsg("");
        setSuccessBorder(document.getElementById('gender_bor'));
        spanHidden("gender_span");
    }
}
function check_password1()
{
    var element = document.forms['form']['password1'];
    if(element.value =="" )
    {
        setErrorBorder(element);
        inputFieldIds[5].setErrorMsg('Please Create a Password');
        inputFieldIds[5].setIsValid(false);
        spanVisible("password1_span",inputFieldIds[5].geterror_msg());
        return;
    }
    else if(element.value.trim() == "" || element.value.length != element.value.trim().length)
    {
        setErrorBorder(element);
        inputFieldIds[5].setErrorMsg('Password have spaces at starting or ending');
        inputFieldIds[5].setIsValid(false);
        spanVisible("password1_span",inputFieldIds[5].geterror_msg());
        
        return;
    }
    else if(element.value.length < 6)
    {
        setErrorBorder(element);
        inputFieldIds[5].setErrorMsg('Password must of atleast length 6 to 15');
        inputFieldIds[5].setIsValid(false);
        spanVisible("password1_span",inputFieldIds[5].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[5].setErrorMsg("");
    inputFieldIds[5].setIsValid(true);
    spanHidden("password1_span");
    return;
}
function check_password2()
{
    var element = document.forms['form']['password2'];
    if(element.value != document.forms['form']['password1'].value)
    {
        setErrorBorder(element);
        inputFieldIds[6].setErrorMsg('Password not Matched');
        inputFieldIds[6].setIsValid(false);
        spanVisible('password2_span',inputFieldIds[6].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[6].setErrorMsg("");
    inputFieldIds[6].setIsValid(true);
    spanHidden('password2_span');
}

function check_phone_number()
{
    var element = document.forms['form']['phone_number']
    if(element.value.trim()=="")
    {
        setErrorBorder(element);
        inputFieldIds[7].setErrorMsg("Enter Your number");
        inputFieldIds[7].setIsValid(false);
        spanVisible("phone_number_span",inputFieldIds[7].geterror_msg());
        return;
    }
    if(element.value.trim().length!=10 || element.value.trim().match(phone_pattern)==null)
    {
        setErrorBorder(element);
        inputFieldIds[7].setErrorMsg("Invalid Phone Number");
        inputFieldIds[7].setIsValid(false);
        spanVisible("phone_number_span",inputFieldIds[7].geterror_msg());
        return;
    }
    if(element.value.trim() == document.forms['form']['alt_phone_number'])
    {
        setErrorBorder(element);
        inputFieldIds[7].setErrorMsg("Phone Number Should not be Same.");
        inputFieldIds[7].setIsValid(false);
        spanVisible("phone_number_span",inputFieldIds[7].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[7].setErrorMsg("");
    inputFieldIds[7].setIsValid(true);
    spanHidden("phone_number_span");
}

function check_alt_phone_number()
{
    var element = document.forms['form']['alt_phone_number']
    if(element.value.trim() == "")
    {
        setSuccessBorder(element);
        inputFieldIds[8].setErrorMsg("");
        inputFieldIds[8].setIsValid(true);
        spanHidden("alt_phone_number_span");
        return;
    }
    else if(element.value.trim().length!=10 || element.value.trim().match(phone_pattern)==null)
    {
        setErrorBorder(element);
        inputFieldIds[8].setErrorMsg("Invalid Phone Number");
        inputFieldIds[8].setIsValid(false);
        spanVisible("alt_phone_number_span",inputFieldIds[8].geterror_msg());
        return;
    }
    else if(element.value.trim() == document.forms['form']['phone_number'].value)
    {
        setErrorBorder(element);
        inputFieldIds[8].setErrorMsg("Alternate Phone Number Should not be Same.");
        inputFieldIds[8].setIsValid(false);
        spanVisible("alt_phone_number_span",inputFieldIds[8].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[8].setErrorMsg("");
    inputFieldIds[8].setIsValid(true);
    spanHidden("alt_phone_number_span")
}


function check_current_address()
{
    var element = document.forms['form']['current_address'];
    if(element.value.trim() == "")
    {
        setErrorBorder(element);
        inputFieldIds[9].setErrorMsg("Enter your current Address");
        inputFieldIds[9].setIsValid(false);
        spanVisible("current_address_span",inputFieldIds[9].geterror_msg());
        return;
    } 
    if(element.value.trim().length < 6)
    {
        setErrorBorder(element);
        inputFieldIds[9].setErrorMsg("Address must be of atleast 6 letters long");
        inputFieldIds[9].setIsValid(false);
        spanVisible("current_address_span",inputFieldIds[9].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[9].setErrorMsg("");
    inputFieldIds[9].setIsValid(true);
    spanHidden("current_address_span");
    return;
}

function check_permanent_address()
{
    var element = document.forms['form']['permanent_address'];
    if(element.value.trim() == "")
    {
        setSuccessBorder(element);
        inputFieldIds[10].setErrorMsg("");
        inputFieldIds[10].setIsValid(true);
        spanHidden("permanent_address_span");
        return;
    } 
    else if(element.value.trim().length < 6)
    {
        setErrorBorder(element);
        inputFieldIds[10].setErrorMsg("Address must be of atleast 6 letters long");
        inputFieldIds[10].setIsValid(false);
        spanVisible("permanent_address_span",inputFieldIds[10].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[10].setErrorMsg("");
    inputFieldIds[10].setIsValid(true);
    spanHidden("permanent_address_span");
    return;
}

function check_current_country()
{
    if(document.forms['form']['current_country'].value == "")
    {
        inputFieldIds[11].setIsValid(false);
        setErrorBorder(document.forms['form']['current_country']);
        inputFieldIds[11].setErrorMsg("Please Select your current Country");
        spanVisible("current_country_span",inputFieldIds[11].geterror_msg());
    }
    else {
        setSuccessBorder(document.forms['form']['current_country']);
        inputFieldIds[11].setIsValid(true);
        inputFieldIds[11].setErrorMsg("");
        spanHidden("current_country_span");
    }
}
function check_current_state()
{
    if(document.forms['form']['current_state'].value=="")
    {
        inputFieldIds[12].setIsValid(false);
        setErrorBorder(document.forms['form']['current_state']);
        inputFieldIds[12].setErrorMsg("Please Select your current State");
        spanVisible("current_state_span",inputFieldIds[12].geterror_msg());
    }
    else {
        setSuccessBorder(document.forms['form']['current_state']);
        inputFieldIds[12].setIsValid(true);
        inputFieldIds[12].setErrorMsg("");
        spanHidden("current_state_span");
    }
}
function check_current_city()
{
    element = document.forms['form']['current_city'];
    if(element.value.trim()=="")
    {
        inputFieldIds[13].setErrorMsg("Enter your Current city");
        inputFieldIds[13].setIsValid(false);
        setErrorBorder(element);
        spanVisible("current_city_span",inputFieldIds[13].geterror_msg());
        return;
    }
    setSuccessBorder(element);
    inputFieldIds[13].setErrorMsg("");
    inputFieldIds[13].setIsValid(true);
    spanHidden("current_city_span");
    return;

}

//on load() body called function Activiies..!!

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
    context.font = "60px Arial";
    context.fillText(operand1,10,80);
    context.fillText(symbol,80,80);
    context.fillText(operand2,150,80);
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
    inputFieldIds[0] = new InputField(document.forms['form']['first_name'].id,"Enter your First Name", false);
    inputFieldIds[1] = new InputField(document.forms['form']['middle_name'].id,"",true);
    inputFieldIds[2] = new InputField(document.forms['form']['last_name'].id,"Enter your Last Name",false);
    inputFieldIds[3] = new InputField(document.forms['form']['email_id'].id,"Please Enter Your Email Address",false);
    inputFieldIds[4] = new InputField('gender',"Select Your Gender",false);
    inputFieldIds[5] = new InputField(document.forms['form']['password1'].id,"Please Create a Password",false);
    inputFieldIds[6] = new InputField(document.forms['form']['password2'].id,"Password Not Matched",false);
    inputFieldIds[7] = new InputField(document.forms['form']['phone_number'].id,"Please Enter Your Phone Number",false);
    inputFieldIds[8] = new InputField(document.forms['form']['alt_phone_number'].id,"",true);
    inputFieldIds[9] = new InputField(document.forms['form']['current_address'].id,"Please Enter your Current Address",false);
    inputFieldIds[10] = new InputField(document.forms['form']['permanent_address'].id,"",true);
    inputFieldIds[11] = new InputField(document.forms['form']['current_country'].id,"Select Your Country",false);
    inputFieldIds[12] = new InputField(document.forms['form']['current_state'].id,"Select Your Country",false);
    inputFieldIds[13] = new InputField(document.forms['form']['current_city'].id,"Select Your Country",false);
    inputFieldIds[14] = new InputField(document.forms['form']['subscription'].id,"",true);
    inputFieldIds[15] = new InputField(document.forms['form']['answer_captcha'].id,"Invalid Captcha",false);
}