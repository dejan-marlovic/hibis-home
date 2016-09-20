var startDate=0;
var bLoadPage=false;
var bReloadPage=false;

function loadPage()
{
   if (!bReloadPage)
   {
   		LMSInitialize();
   }
   else
   {
	   bReloadPage=false
   }
   
   startTimer();
   bLoadPage=true;
}

function startTimer()
{
   startDate = new Date().getTime();
}

function convertTotalSeconds(ts)
{
var Sec = (ts % 60);
ts -= Sec;
var tmp = (ts % 3600);  //# of seconds in the total # of minutes
ts -= tmp;              //# of seconds in the total # of hours
if ( (ts % 3600) != 0 ) var Hour = "00" ;
else var Hour = ""+ (ts / 3600);
if ( (tmp % 60) != 0 ) var Min = "00";
else var Min = ""+(tmp / 60);
Sec=""+Sec;
if (Sec.indexOf(".")!=-1) Sec=Sec.substring(0,Sec.indexOf("."));
if (Hour.length < 2)Hour = "0"+Hour;
if (Min.length < 2)Min = "0"+Min;
if (Sec.length <2)Sec = "0"+Sec;

var rtnVal = "";
if (apiVersion==12)
	rtnVal=Hour+":"+Min+":"+Sec;
else if (apiVersion==13)
	rtnVal="PT"+Hour+"H"+Min+"M"+Sec+"S";
	
return rtnVal;
}

function computeTime()
{
var formattedTime = "00:00:00.0";
if ( startDate != 0 )
	{
	var currentDate = new Date().getTime();
	var elapsedSeconds = ( (currentDate - startDate) / 1000 );
	formattedTime = convertTotalSeconds( elapsedSeconds );
	}

	LMSSetValue( "cmi.core.session_time", formattedTime );
}


function unloadPage()
{
	if(bLoadPage)
	{
		bLoadPage=false;
		if (!bReloadPage)
		{
			if (bighorn_SAP_mode==true) LMSSetValue("cmi.core.exit","suspend");
			computeTime();
			LMSCommit();
			LMSFinish();
		}
	}
}