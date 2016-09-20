var traceAPI=false;
var traceAPIdiagnostics=false;

var traceWIN=null;
var traceReady=false;
var traceString="";

var bIgnoreStatus=false;

function WriteTrace(str)
{
    if (traceAPI && traceWIN!=null && !traceWIN.closed)
    {
	    if (traceReady)
	    {
        	traceWIN.document.traceform.log.value=traceWIN.document.traceform.log.value+"> "+traceString+str+"\n";
        	traceString="";
    	}
        else
        	traceString=traceString+"> "+str+"\n";
	}
}

function getFlashMovieObject(movieName)
{
  if (window.document[movieName]) 
  {
      return window.document[movieName];
  }
  if (navigator.appName.indexOf("Microsoft Internet")==-1)
  {
    if (document.embeds && document.embeds[movieName])
      return document.embeds[movieName]; 
  }
  else // if (navigator.appName.indexOf("Microsoft Internet")!=-1)
  {
    return document.getElementById(movieName);
  }
}

var detect = navigator.userAgent.toLowerCase();
var OS,browser,total,thestring;
var version = 0;

if (checkIt('konqueror'))
{
	browser = "Konqueror";
	OS = "Linux";
}
else if (checkIt('safari')) browser = "Safari"
else if (checkIt('omniweb')) browser = "OmniWeb"
else if (checkIt('opera')) browser = "Opera"
else if (checkIt('webtv')) browser = "WebTV";
else if (checkIt('icab')) browser = "iCab"
else if (checkIt('msie')) browser = "Internet Explorer"
else if (checkIt('firefox')) browser = "Firefox"
else if (checkIt('netscape')) browser = "Netscape"
else if (!checkIt('compatible'))
{
	browser = "Netscape Navigator"
	version = detect.charAt(8);
}
else browser = "An unknown browser";

if (!version) version = detect.substring(place + thestring.length,place + thestring.length+3);

if (!OS)
{
	if (checkIt('linux')) OS = "Linux";
	else if (checkIt('x11')) OS = "Unix";
	else if (checkIt('mac')) OS = "Mac"
	else if (checkIt('win')) OS = "Windows"
	else OS = "an unknown operating system";
}

function checkIt(string)
{
	place = detect.indexOf(string) + 1;
	thestring = string;
	return place;
}

var NoteWnd=null;
var IDWnd = null;
var Holder = null;
function noteWindow()
{
    if (NoteWnd!=null)
    {
        NoteWnd.focus();
    }
    else
	{
    NoteWnd=window.open("Note.doc","note");
    NoteWnd.focus();
	}
}

function idWindow(pageid)
{
	if(IDWnd!=null || (IDWnd!=null && !IDWnd.closed))
	{
		IDWnd.close();
	}
	IDWnd=Window.open("id.html?pageid="+pageid, "ID","status=0, toolbar=0, location=0, menubar=0,directiories=0, resizeable=0, scrollbbars=0, width=350,height=150");
	IDWnd.focus();


}

function openURL(myurl,mywidth,myheight)
 {
  wid=window.open(myurl, "modellw","resizable=yes,scrollbars=yes, location=no, width="+mywidth+", height="+myheight)
  if(wid!=null) {
	  wid.focus();
  }
}

function closeWarn()
{
    	if (bReloadPage==false && startloc == "-1" && bighorn_exitmode=="close" && bLoadPage==true && window.top==window)
    	{
    		if (bighorn_onclose_warning==true)
    		{
        		if (event)
            		event.returnValue = "Closing this window may result in loss of progress data, use the 'Exit' button in the course to avoid this.\n\nAre you sure you want to close the window?";
        	}
            else
            {
				// we are being unloaded, save our progress now
				unloadPage();         
        	}
    	}
}

function closePage()
{
	if (startloc=="-1") 
	{ 
		unloadPage() 
	}
	/*
	if (window.opener!=null)
	{
		window.opener.focus()
		if (window.opener.showClosedInfo)
			window.opener.showClosedInfo();
	}
	*/
}

function adjustPos() 
{
	if (bighorn_resizemode=="scale")
	{
		if (!bFirstCall)
		{	
			var w=1024; var h=768;
			if (window.innerWidth) { w=window.innerWidth; h=window.innerHeight; }
			else if (document.body.clientWidth) { w=document.body.clientWidth; h=document.body.clientHeight; }
			
			var dx=(w/width)*100;
			var dy=(h/height)*100;
			if (dx>dy)
				dx=dy;
			else
				dy=dx;
				
			getFlashMovieObject("player").SetVariable("_root.skin_mc._xscale",""+dx);
			getFlashMovieObject("player").SetVariable("_root.skin_mc._yscale",""+dy);
		}
	}
	else
	{
		if ((browser=="Internet Explorer" && OS=="Windows") || browser=="Firefox")
		{
			var w=1024; var h=768;
			if (window.innerWidth) { w=window.innerWidth; h=window.innerHeight; }
			else if (document.body.clientWidth) { w=document.body.clientWidth; h=document.body.clientHeight; }
		
			var cbobj=document.getElementById("playerDiv");
			
			if (cbobj!=null)
			{
				if (w>(parseInt(width)+2)) 
				{
					cbobj.style.left=""+(((w-parseInt(width))/2)-1)+"px";
				}
				else
				{
					cbobj.style.left="0px";
				}
				if (h>(parseInt(height)+2)) 
				{
					cbobj.style.top=""+(((h-parseInt(height))/2)-1)+"px";
				}
				else
				{
					cbobj.style.top="0px";
				}
				
				if (w>(parseInt(width)+2) && h>(parseInt(height)+2))
				{
					cbobj.style.width=""+(parseInt(width)+(browser!="Firefox"?2:0))+"px";
					cbobj.style.height=""+(parseInt(height)+(browser!="Firefox"?2:0))+"px";
					cbobj.style.border="1px solid #000000";
				}
				else
				{
					cbobj.style.border="0px";
					cbobj.style.width=""+parseInt(width)+"px";
					cbobj.style.height=""+parseInt(height)+"px";
				}
			}
		}
	}
}

if (!String.prototype.endsWith) {
  String.prototype.endsWith = function(suffix) {
    var startPos = this.length - suffix.length;
    if (startPos < 0) {
      return false;
    }
    return (this.lastIndexOf(suffix, startPos) == startPos);
  };
}


// Find parameters
xmlid=getParameter("xmlid","")+".xml";
width=getParameter("width","990");
height=getParameter("height","560");
startloc=getParameter("startloc","-1");
flashver=getParameter("flashver","7");
usefs=getParameter("usefs","false");
lang=getParameter("lang",null);
langrec=getParameter("langrec",lang);
bReloadPage=getParameter("reload",null)!=null;

function getParameter(pname,defval)
{
	var ret="";
	var searchStr=unescape(location.search.toUpperCase());
	var idx=searchStr.indexOf("?"+pname.toUpperCase()+"=");
	if (idx==-1) idx=searchStr.indexOf("&"+pname.toUpperCase()+"=");
	if (idx!=-1)
	{
		var tmp=unescape(location.search).substr(idx+pname.length+2);
		idx=tmp.indexOf("&");
		if (idx!=-1)
			tmp=tmp.substr(0,idx);
		
		ret=unescape(tmp);
	}
        else
        {
	   ret=defval;
        }
	return ret;
}

// Hook for Internet Explorer 
if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && 
	  navigator.userAgent.indexOf("Windows") != -1 && navigator.userAgent.indexOf("Windows 3.1") == -1) {
	document.write('<SCRIPT LANGUAGE=VBScript\> \n');
	document.write('on error resume next \n');
	document.write('Sub player_FSCommand(ByVal command, ByVal args)\n');
	document.write('  call player_DoFSCommand(command, args)\n');
	document.write('end sub\n');
	document.write('</SCRIPT\> \n');
}

var cmiIdx=new Array();

function InteractionData()
{
	this.n=null;
	this.id=null;
	this.itype="";
	this.correct_responses="";
	this.student_response=""
	this.result=result="";
}

function getInteraction(iid)
{
	var ret=null;
	
	for (i=0;i<cmiIdx.length;i++)
	{
		if (cmiIdx[i].id==iid)
		{
			ret=cmiIdx[i];
			break;
		}
	}
	
	if (ret==null)
	{
		ret=new InteractionData()
		ret.n=parseInt(LMSGetValue("cmi.interactions._count"));
		ret.id=iid;
		cmiIdx[cmiIdx.length]=ret;
	}
	
	return ret;
}

function postInteraction()
{
	if (currentInteraction!=null)
	{
		LMSSetValue("cmi.interactions."+currentInteraction.n+".id",currentInteraction.id);
		LMSSetValue("cmi.interactions."+currentInteraction.n+".type",currentInteraction.itype);
		LMSSetValue("cmi.interactions."+currentInteraction.n+".correct_responses.0.pattern",currentInteraction.correct_responses);
		LMSSetValue("cmi.interactions."+currentInteraction.n+".student_response",currentInteraction.student_response);
		LMSSetValue("cmi.interactions."+currentInteraction.n+".result",currentInteraction.result);
		currentInteractionId=null;
		currentInteraction=null;
	}
}

var currentInteractionId=null;
var currentInteraction=null;
var currentScore=null;

function handleSetValue(skey,sval)
{
	// If we have already closed the API, return now...
	if (!bLoadPage) return;
	
	if (skey=="cmi.core.lesson_status" && sval=="failed" && !bighorn_use_failed_status)
	{
		WriteTrace("Ignoring lesson status 'failed', using 'incomplete'");
		sval="incomplete";	
	}
	
	if (skey=="cmi.core.lesson_status" && sval=="passed" && (bighorn_use_passed_status==false || bighorn_SAP_mode==true) )
	{
		WriteTrace("Ignoring lesson status 'passed', using 'completed'");
		sval="completed";	
	}
	
	if (skey.substring(0,17)=="cmi.interactions." && skey!="cmi.interactions._children")
	{
		//alert("skey="+skey);
		if (skey.endsWith(".id"))
		{
			currentInteractionId=sval;
		}
		else if (currentInteractionId!=null)
		{
			if (currentInteraction==null)
				currentInteraction=getInteraction(currentInteractionId);

			if (currentInteraction!=null)
			{
				if (skey.endsWith(".type"))
					currentInteraction.itype=sval;
				else if (skey.endsWith(".pattern"))
					currentInteraction.correct_responses=sval;
				else if (skey.endsWith(".student_response"))
					currentInteraction.student_response=sval;
				else if (skey.endsWith(".result"))
					currentInteraction.result=sval;
			}
		}
	}
	else 
	{
		if (skey=="cmi.core.score.raw")
		{
			var currentScore=0;
			var temp=LMSGetValue("cmi.core.score.raw");
			if (temp!="" && temp!="raw") currentScore=parseInt(temp);
				
			if (parseInt(sval)>currentScore)
			{
				// score is higher, set it
				LMSSetValue("cmi.core.score.raw",sval);
			}
		}
		else if (!bIgnoreStatus)
		{
			LMSSetValue(skey,sval);
		}
			
		// do special handling after lesson status has been set
		if (skey=="cmi.core.lesson_status")
		{
			postInteraction();
			
			if (!bIgnoreStatus && (sval=="completed" || sval=="passed"))
			{
				// force commit on status change
				bIgnoreStatus=true;
			}
		}
	}
}

var bFirstCall=true;
var InternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
// Handle all the the FSCommand messages in a Flash movie
function player_DoFSCommand(command, args) 
{
	if (bFirstCall)
	{	
		bFirstCall=false;
		adjustPos();
	}
	
	WriteTrace("FSCommand('"+command+"','"+args+"') received.");
	
  	var playerObj = InternetExplorer ? player : document.player;
	
	args 				= String(args);
	command 			= String(command);	
	var F_intData 	= args.split(",");
	var tmp = ""
	for (i=0;i<args.length;i++)
    {
        achar=args.substring(i,i+1)
        if (achar=='\n')
          tmp=tmp+"\\n"
        else if (achar=='\r')
       	  tmp=tmp+"\\n"
        else
          tmp=tmp+achar
    }
	
	switch (command)
	{
		case "currentpageid" :
			if (top && top.setCurrentPage)
			{
				top.setCurrentPage(F_intData[0],F_intData[1]);
			}
			break;
		case "messagebox" :
           	alert(args);
			break;
		case "CHANGELANG" :
			langrec=args;
			bReloadPage=true;
			location.href="PlayerX.html?xmlid="+xmlid.substring(0,xmlid.length-4)+"&width="+width+"&height="+height+(startloc!="-1"?"&startloc="+startloc:"")+"&flashver="+flashver+"&useFS="+usefs+"&langrec="+langrec+(lang!=null?"&lang="+lang:"")+"&reload=true&"+(new Date().getTime());
			break;	
		case "SETDATA" :
			tidx=args.indexOf("|");
			name=args.substring(0,tidx);
			value=args.substring(tidx+1);
			handleSetValue(name,value);
			window.document.player.SetVariable('_level0.SetOK', 1);
			break;
		case "COMMIT" :
			LMSCommit("");
			window.document.player.SetVariable('_level0.SetOK', 1);
			break;
		case "GETDATA" :
			tidx=args.indexOf("|"); 	
			varname=args.substring(0,tidx);
			name=args.substring(tidx+1);

			var tmp=LMSGetValue(name);
			window.document.player.SetVariable(varname,tmp);			
			break;			
		case "NOTE" :			
			noteWindow();
			break;
		case "SHOWID":
			idWindow(F_intData[0]);
			break;
		case "report" :			
			top.leftFrame.drawReportLauncher();
			break;
		case "SetHolder":
			Holder = args;
			//alert(args);
			break;
		case "openwin":
			eval("WinOpen=window.open("+args+");");
			WinOpen.focus();
			break;
		case "launch":
			location.href="cbexec:"+args;
			break;
		case "EXIT" :		
			if(startloc == "-1")
			{
				if (bighorn_exitmode=="logout")
				{
					LMSSetValue("cmi.core.exit","logout");
					unloadPage();	
				}
				else if (bighorn_exitmode=="close")
				{
					unloadPage();
					if (!top.bighorn_standalone_player_version)
					{
						window.open("javascript:window.close();","_top","");
					}
					else
					{
						top.exitCourse();
					}
				}
				else if (bighorn_exitmode=="return")
				{
					unloadPage();
					parent.returnToMainMenu();
				}
			}
			else
			{
				window.open("javascript:window.close();","_top","");
			}
			break;
	}
}

function LaunchContent()
{
	var protocol="http";
	if (location.href.indexOf(":")!=-1) protocol=location.href.substring(0,location.href.indexOf(":"));
	
	WriteTrace("PROTOCOL is '"+protocol+"'");
	WriteTrace("URL is '"+location.href+"'");
	WriteTrace("XMLID is '"+xmlid+"'");
	WriteTrace("Size is "+width+" x "+height);
	WriteTrace("Flash version is "+flashver);
	WriteTrace("CourseBuilder version is "+bighorn_version+" (build "+bighorn_buildnr+")");
		
	if (startloc=="-1") 
	{
		WriteTrace("Mode is 'normal' (LMS tracking active).");
		WriteTrace("JavaScript Comm. uses '"+(usefs=="true"?"fscommand":"getURL")+"'");
	    loadPage();
	    
	    // ignore setvalue from module if module is already passed/completed
	    austat = LMSGetValue("cmi.core.lesson_status");
	    if (austat.indexOf("completed") == 0 || austat.indexOf("passed")==0) 
	    {
	    	bIgnoreStatus=true;
	    	WriteTrace("Course is passed, setting 'IgnoreStatus' mode!");
	    }
	    else if (austat.indexOf("not attempted") == 0 || austat.indexOf("unknown")==0) 
   		{
       		austat="incomplete";
       		LMSSetValue("cmi.suspend_data","");
   		}
   		// refresh value (required by some LMS systems)
   		LMSSetValue("cmi.core.lesson_status",austat);
	}
	else
	{
		WriteTrace("Mode is 'preview' (no LMS tracking).");
	}
	
	if (startloc=="-1" && traceAPIdiagnostics)
	{
		WriteTrace("");
		WriteTrace("****************************************");
		WriteTrace("****  RUNNING SCORM API DIAGONSTICS  ***");
		WriteTrace("****************************************");
		WriteTrace("");
		var api = getAPIHandle();
		if (api!=null)
		{
			WriteTrace("");
			WriteTrace("CHECKING MANDATORY DATAMODEL ELEMENTS:");
			WriteTrace("");
			LMSGetValue("cmi.core._children");
			LMSGetValue("cmi.core.student_id");
			LMSGetValue("cmi.core.student_name");
			LMSGetValue("cmi.core.lesson_location");
			LMSGetValue("cmi.core.credit");
			LMSGetValue("cmi.core.lesson_status");
			LMSGetValue("cmi.core.entry");
			LMSGetValue("cmi.core.score._children");
			LMSGetValue("cmi.core.score.raw");
			LMSGetValue("cmi.core.total_time");
			LMSGetValue("cmi.suspend_data");
			LMSGetValue("cmi.launch_data");
			WriteTrace("");
			WriteTrace("CHECKING OPTIONAL DATAMODEL ELEMENTS:");
			WriteTrace("");
			LMSGetValue("cmi.core.lesson_mode");
			LMSGetValue("cmi.comments");
			LMSGetValue("cmi.objectives._count");
			LMSGetValue("cmi.student_data._children");
			LMSGetValue("cmi.student_preference._children");
			LMSGetValue("cmi.comments_from_lms");
			LMSGetValue("cmi.interactions._children");
			LMSGetValue("cmi.interactions._count");
		}
		else
		{
			WriteTrace("SCORM API NOT FOUND!!!");		
		}
		
		WriteTrace("");
		WriteTrace("****************************************");
		WriteTrace("****  END OF SCORM API DIAGONSTICS   ***");
		WriteTrace("****************************************");
		WriteTrace("");
	}
	
	//alert("bfscommand="+usefs);
	document.write("<BODY onresize=\"adjustPos()\" onbeforeunload=\"closeWarn()\" onUnload=\"closePage()\" style=\"margin: 0px; padding: 0px; background-color: #FFFFFF;\" SCROLL=\"NO\">");
	if (bighorn_resizemode=="scale")
		document.write("<div style=\"position: absolute; width: 100%; height:100%; background-color:#FFFFFF;\">");
	else
		document.write("<div id=\"playerDiv\" style=\"position: absolute; left:0px; top: 0px; overflow: hidden; width: "+width+"px; height: "+height+"px;\">");
	if (flashver>=7)
	{
		var swfver=flashver;
		if (swfver>9) swfver=9;
		
		WriteTrace("Using CourseBuilder Player for Flash "+swfver+" or later");
		document.write("<OBJECT classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\""+protocol+"://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0\" width=\""+(bighorn_resizemode=="scale"?"100%":width)+"\" height=\""+(bighorn_resizemode=="scale"?"100%":height)+"\" id=\"player\" align=\"\">");
		document.write("<PARAM name=\"allowScriptAccess\" VALUE=\"sameDomain\">");
		document.write("<PARAM name=\"movie\" value=\"player"+swfver+".swf?buildnr="+bighorn_buildnr+"&xmlid="+xmlid+(langrec!=null?("&langrec="+langrec):"")+(lang!=null?("&courselang="+lang):"")+"&startloc="+startloc+"&usefs="+usefs+"&skinsize="+width+"x"+height+"\">");
		document.write("<PARAM name=\"menu\" value=\"false\">");
		document.write("<PARAM name=\"quality\" value=\"high\">");
		document.write("<PARAM name=\"salign\" value=\"LT\">");
		document.write("<PARAM name=\"scale\" value=\"noscale\">");
		document.write("<PARAM name=\"bgcolor\" VALUE=\"#FFFFFF\">");
		if (browser=="Firefox")
		{
			document.write("<PARAM name=\"wmode\" value=\"transparent\">");
		}
		document.write("<EMBED src=\"player"+swfver+".swf?buildnr="+bighorn_buildnr+"&xmlid="+xmlid+(lang!=null?("&courselang="+lang):"")+"&startloc="+startloc+"&usefs="+usefs+"&skinsize="+width+"x"+height+"\" menu=false quality=high bgcolor=\"#FFFFFF\"  width=\""+(bighorn_resizemode=="scale"?"100%":1400)+"\" height=\""+(bighorn_resizemode=="scale"?"100%":900)+"\" name=\"player\" id=\"player\" wmode=\"transparent\" SWLIVECONNECT=true type=\"application/x-shockwave-flash\" pluginspage=\""+protocol+"://www.macromedia.com/go/getflashplayer\"></EMBED>");
		document.write("</OBJECT>");
	}
	else
	{
		document.write("<H2>This course requires Abobe Flash Player 7 or later.</H2>");
	}		
	document.write("</div>");
	document.write("</BODY>");
	
	adjustPos();
}

if (traceAPI)
{
	traceWIN=window.open("tracewin.html","_new","resizable=yes,scrollbars=no,location=no, width=740, height=480");
	if (traceWIN==null)
		traceAPI=false;	
	window.focus();
}

LaunchContent();


