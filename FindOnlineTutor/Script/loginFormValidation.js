$(document).ready(function(){
    generateCaptcha();
});


//generate captcha
function generateCaptcha()
{
    canvas.width = canvas.width;
    var captcha = $("#canvas");
    var context = captcha[0].getContext("2d");
    var aChars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'n', 'o', 'p', 'q', 'r', 's', 't',
                    'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var maxNum = 35;
    toReturn = '';

    for(let i=1; i<=5; i++)
    {
        var randNum = Math.floor(Math.random() * 35); 
        var letter = aChars[randNum];
        toReturn = toReturn+letter;
    }
    context.font = "60px Arial";
    context.fillText(toReturn,40,100);
}