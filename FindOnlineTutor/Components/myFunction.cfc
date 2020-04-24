<!---
Project Name: FindOnlineTutor.
File Name: myFunction.cfc.
Created In: 24th Apr 2020
Created By: Rajendra Mishra.
Functionality: This file contain some function created by me for conveniance.
--->

<cfcomponent output="false">
    <!---function to remove the stopwords from sentence and return the words containing no stopwords--->
    <cffunction name="removeStopWords" access="remote" output="false" returntype="array">
        <cfargument name="input" required="true">
        <cfset words = []/>
        <cfset stopWords = "a,able,about,across,after,all,almost,also,am,among,an,and,any,are,as,at,be,because,been,but,
                            by,can,cannot,could,dear,did,do,does,either,else,ever,every,for,from,get,got,had,has,have,he,
                            her,hers,him,his,how,however,i,if,in,into,is,it,its,just,least,let,like,likely,may,me,might,
                            most,must,my,neither,no,nor,not,of,off,often,on,only,or,other,our,own,rather,said,say,says,she,
                            should,since,so,some,than,that,the,their,them,then,there,these,they,this,tis,to,too,twas,us,
                            wants,was,we,were,what,when,where,which,while,who,whom,why,will,with,would,yet,you,your">


        <cfloop list="#input#" index="word" delimiters=" ">
            <cfif NOT ListFind(stopWords, word)>
                <cfset arrayAppend(words, word)/>
            </cfif>
        </cfloop>
            <cfreturn words>
    </cffunction>
</cfcomponent>