<!---an include containing the head component--->
<head>
    <title>FindOnlineTutor</title>
    
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <cfif  structKeyExists(attributes, "scriptPath")>
        <script src="<cfoutput>#attributes.scriptPath#</cfoutput>"></script>
    </cfif>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css">
    <link href="https://fonts.googleapis.com/css?family=Lora|Sen&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<cfoutput>#attributes.stylePath#</cfoutput>">

</head>
