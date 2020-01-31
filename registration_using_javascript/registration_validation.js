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

var name_pattern = /^[A-Za-z]+$/;
var email_pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
// var password_pattern = /^[a-zA-Z]+?[@#$.].(A-Z)+$/
var phone_pattern = "";

var ans;

function validate_form()
{
    if(validation_failed())
    {
        return false;
    }
    else{
        return true;
    }

}

function validation_failed()
{
    let return_statement = true;
    var s="";
    if(document.forms['form']['gender'].value == "")
    {
        inputFieldIds[4].setIsValid(false);
        inputFieldIds[4].setErrorMsg("Please Select your Gender");
        // alert(inputFieldIds[4].getis_valid());
    }
    else {
        
        // alert(document.forms['form']['gender'].value)
        inputFieldIds[4].setIsValid(true);
    }
    if(document.forms['form']['current_country'].value == "")
    {
        inputFieldIds[11].setIsValid(false);
        setErrorBorder(document.forms['form']['current_country']);
        inputFieldIds[11].setErrorMsg("Please Select your current Country");
    }
    else {
        setSuccessBorder(document.forms['form']['current_country']);
        inputFieldIds[11].setIsValid(true);
    }
    if(document.forms['form']['current_state'].value=="")
    {
        inputFieldIds[12].setIsValid(false);

        setErrorBorder(document.forms['form']['current_state']);
        inputFieldIds[12].setErrorMsg("Please Select your current State");
    }
    else {
        setSuccessBorder(document.forms['form']['current_state']);
        inputFieldIds[12].setIsValid(true);
    }
    if(document.forms['form']['current_city'].value.trim() =="")
    {
        inputFieldIds[13].setIsValid(false);
        inputFieldIds[13].setErrorMsg("Please your current City");
    }
    else {
        setSuccessBorder(document.forms['form']['current_city']);
        inputFieldIds[13].setIsValid(true);
    }
    if(document.forms['form']['answer_captcha'].value!= ans)
    {
        inputFieldIds[15].setIsValid(false);
        inputFieldIds[15].setErrorMsg("Invalid Captcha");
    }
    else {
        setSuccessBorder(document.forms['form']['answer_captcha']);
        inputFieldIds[15].setIsValid(true);
    }
    

    for (let i = 0 ; i < inputFieldIds.length; i++)
    {
        if(!inputFieldIds[i].getis_valid() && inputFieldIds[i].geterror_msg()!="")
        {
            // alert(inputFieldIds[i].geterror_msg());
            if(inputFieldIds[i].getId()=='gender')
            {
                document.getElementById("gender_span").innerHTML = inputFieldIds[i].geterror_msg();
            }
            else{
                let span = document.getElementById(inputFieldIds[i].getId()+"_span");
                span.innerHTML = inputFieldIds[i].geterror_msg();
                setErrorBorder(document.forms['form'][inputFieldIds[i].getId()],"");
                
            }
            return_statement = false;
        }
    }
    
    if(return_statement)
    { 
        alert("Successfully Registered. Click OK to proceed");
        return false;}
    else {
        alert("Failed to Registered.");
        return true;
    }
}

// function setErrorToSpan(element,error)

function setErrorBorder(element,error_msg)
{
    element.style.borderWidth = "2px";
    element.style.borderColor = "red";   
    document.getElementById(element.id+"_span").style.visibility = "visible";
    // document.getElementById(element.id+"_span").innerHTML = error_msg;
}

function setSuccessBorder(element)
{
    element.style.borderWidth = "2px";
    element.style.borderColor = "green";
    document.getElementById(element.id+"_span").innerHTML = "";
    document.getElementById(element.id+"_span").style.visibility = "hidden";
    

}


function check_name(element)
{
    if(element == document.forms['form']['middle_name'])
    {
        if(element.value.length==0)
        {
            setSuccessBorder(element);
            inputFieldIds[1].setErrorMsg("");
            inputFieldIds[1].setIsValid(true);
            
        }
    }
    if(element.value.length == 1 || element.value.length > 15)
    {
        setErrorBorder(element,"");
        if(element.id == "middle_name")
        {
            inputFieldIds[1].setErrorMsg("Name must be between 2 to 15 characters long.");
            inputFieldIds[1].setIsValid(false);
        }
        else if(element.id == "first_name") {
            inputFieldIds[0].setErrorMsg("Name must be between 2 to 15 characters long.");
            inputFieldIds[0].setIsValid(false);
        }
        else if(element.id == "last_name")
        {
            inputFieldIds[2].setErrorMsg("Name must be between 2 to 15 characters long.");
            inputFieldIds[2].setIsValid(false);
        }
    }
    else if(element.value.length>1 && element.value.length<=15)
    {
        if(element.value.match(name_pattern) == null)
        {
            setErrorBorder(element,"");
            if(element.id == "middle_name")
            {
                inputFieldIds[1].setErrorMsg("Must contains only alphabets.");
                inputFieldIds[1].setIsValid(false);
            }
            else if(element.id == "first_name"){
                inputFieldIds[0].setErrorMsg("Must contains only alphabets.");
                inputFieldIds[0].setIsValid(false);
            }
            else if(element.id == "last_name"){
                inputFieldIds[2].setErrorMsg("Must contains only alphabets.");
                inputFieldIds[2].setIsValid(false);
            }
        }
        else 
        {
            setSuccessBorder(element);
            if(element.id == "middle_name")
            {
                inputFieldIds[1].setErrorMsg("");
                inputFieldIds[1].setIsValid(true);
            }
            else if(element.id == "first_name"){
                inputFieldIds[0].setErrorMsg("");
                inputFieldIds[0].setIsValid(true);
            }
            else if(element.id == "last_name")
            {
                inputFieldIds[2].setErrorMsg("");
                inputFieldIds[2].setIsValid(true);
            }

        }
    }
    
    
}
function check_email(element)
{
    if(element.value.match(email_pattern)==null)
    {
        setErrorBorder(element,"");
        inputFieldIds[3].setErrorMsg("Invalid Email Address.");
        inputFieldIds[3].setIsValid(false);
    }
    else{
        setSuccessBorder(element);
        inputFieldIds[3].setErrorMsg("");
        inputFieldIds[3].setIsValid(true);
    }
}



function check_password(element)
{
    if (element == "password1")
    {
        if(element.value.length<6)
        {
            setErrorBorder(element,"Password must contain atleast 6 characters");
            inputFieldIds[5].setErrorMsg("Password must contain atleast 6 characters");
            inputFieldIds[5].setIsValid(false);
        }
        else {
            setSuccessBorder(element);
            inputFieldIds[5].setErrorMsg("");
            inputFieldIds[5].setIsValid(true);
        }
    }
    else if(element.value != document.forms["form"]["password1"].value)
    {
        setErrorBorder(element,"Password not matched");
        inputFieldIds[6].setErrorMsg("Password not matched");
        inputFieldIds[6].setIsValid(false);
    }
    else if(element.value == document.forms["form"]["password1"].value && element.value.length>5)
    {
        setSuccessBorder(element);
        inputFieldIds[6].setErrorMsg("");
        inputFieldIds[6].setIsValid(true);
        inputFieldIds[5].setErrorMsg("");
        inputFieldIds[5].setIsValid(true);
    }
    

}

function check_phone_number(element)
{
    if(element.value.length!=10 || element.value.match(phone_pattern)==null)
    {
        setErrorBorder(element);
        if(element.id == "phone_number"){
            inputFieldIds[7].setErrorMsg("Invalid Phone Number");
            inputFieldIds[7].setIsValid(false);
        }
        else 
        {
            inputFieldIds[8].setErrorMsg("Invalid Phone Number");
            inputFieldIds[8].setIsValid(false);
        }

    }
    else if(element == document.forms['form']['alt_phone_number'] && element.value == document.forms['form']['phone_number'].value)
    {
        setErrorBorder(element,"");
        inputFieldIds[8].setErrorMsg("Same Number Entered. You can keep this Blank");
        inputFieldIds[8].setIsValid(false);
    }
    else 
    {
        setSuccessBorder(element);
        if(element.id == "phone_number"){
            inputFieldIds[7].setErrorMsg("");
            inputFieldIds[7].setIsValid(true);
        }
        else 
        {
            inputFieldIds[8].setErrorMsg("");
            inputFieldIds[8].setIsValid(true);
        }
    }
}


function check_address(element)
{
    if(element == document.forms['form']['permanent_address'] && element.value.length.trim()==0)
    {
        setSuccessBorder(element);
        inputFieldIds[10].setErrorMsg("");
        inputFieldIds[10].setIsValid(true);
        return;
    }
    if(element.value.length < 10 || element.value.length > 100)
    {
        setErrorBorder(element,"");
        if(element.id == "current_address"){
            inputFieldIds[9].setErrorMsg("Address must have length between 10 to 100");
            inputFieldIds[9].setIsValid(false);
        }
        else 
        {
            inputFieldIds[10].setErrorMsg("Address must have length between 10 to 100");
            inputFieldIds[10].setIsValid(false);
        }
    }
    else {
        setSuccessBorder(element);
        if(element.id == "current_address"){
            inputFieldIds[9].setErrorMsg("");
            inputFieldIds[9].setIsValid(true);
        }
        else 
        {
            inputFieldIds[10].setErrorMsg("");
            inputFieldIds[10].setIsValid(true);
        }
    }
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

    inputFieldIds[0] = new InputField(document.forms['form']['first_name'].id,"Enter your First Name", false);
    inputFieldIds[1] = new InputField(document.forms['form']['middle_name'].id,"Enter your Middle Name",false);
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