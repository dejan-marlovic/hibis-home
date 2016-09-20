// Define exception/error codes
var _NoError = 0;
var _GeneralException = 101;
var _ServerBusy = 102;
var _InvalidArgumentError = 201;
var _ElementCannotHaveChildren = 202;
var _ElementIsNotAnArray = 203;
var _NotInitialized = 301;
var _NotImplementedError = 401;
var _InvalidSetValue = 402;
var _ElementIsReadOnly = 403;
var _ElementIsWriteOnly = 404;
var _IncorrectDataType = 405;

// local variable definitions
var apiVersion=0;
var apiHandle = null;

var dataModelMap=		[["cmi.core.lesson_status","cmi.core.lesson_status","cmi.completion_status"],
						["cmi.core.score","cmi.core.score","cmi.score"],
						["cmi.core.lesson_location","cmi.core.lesson_location","cmi.location"],
						["cmi.progress_measure","_not_supported_","cmi.progress_measure"],
						["cmi.core.session_time","cmi.core.session_time","cmi.session_time"],
						["cmi.suspend_data","cmi.suspend_data","cmi.suspend_data"],
						["cmi.launch_data","cmi.launch_data","cmi.launch_data"],
						["cmi.core.student_id","cmi.core.student_id","cmi.learner_id"],
						["cmi.core.student_name","cmi.core.student_name","cmi.learner_name"],
						["cmi.student_preference.audio","cmi.student_preference.audio","cmi.learner_preference.audio_level"],
						["cmi.student_preference.language","cmi.student_preference.language","cmi.learner_preference.language"],
						["cmi.student_preference.text","cmi.student_preference.text","cmi.learner_preference.audio_captioning"],
						["cmi.interactions.#.student_response","cmi.interactions.#.student_response","cmi.interactions.#.learner_response"],
						["cmi.interactions","cmi.interactions","cmi.interactions"]];

						
function mapModelName(query)
{
	var result=query;
	
	for (i=0;i<dataModelMap.length;i++)
	{
		tmArray=dataModelMap[i][0].split("#");
		tm=tmArray[0];
					
		tcArray=dataModelMap[i][apiVersion==12?1:2].split("#");
		tc=tcArray[0];
		
		tq=query.substring(0,query.length>=tm.length?tm.length:query.length);
		if (tmArray.length>1)
		{
			tq=query.substring(query.length>=tm.length?tm.length:query.length);
			for (j=1;j<tmArray.length;j++)
			{
				tm=tm+tq.substring(0,tq.indexOf("."))+tmArray[j];
				tc=tc+tq.substring(0,tq.indexOf("."))+tcArray[j];
				tq=tq.substring(tq.indexOf("."));
			}
			tq=query.substring(0,query.length>=tm.length?tm.length:query.length);
		}

		if (tq==tm)
		{
			if (tc=="_not_supported_")
			    result=null;
			else
			    result=tc+query.substring(tm.length);
			break;
		}
	}
	return result;
}


function mapModelValue(name,value)
{
	var result=value;
	
	if (name=="cmi.learner_preference.audio_level")
	{
		if (value=="-1")
			result="0";
		else
			result="1";
	}
	else if (apiVersion==13 && name.indexOf("cmi.interactions.")!=-1 && name.indexOf(".result")!=-1)
	{
		if (value=="wrong")
			result="incorrect";
	}
	else if (apiVersion==13 && name=="cmi.completion_status")
	{
		if (value=="passed")
			result="completed";
	}
	else if (apiVersion==13 && name.indexOf("cmi.interactions.")!=-1 && name.indexOf(".type")!=-1)
	{
		if (value=="performance")
			result="other";
	}
	else if (apiVersion==13 && name.indexOf("cmi.interactions.")!=-1 && 
			  (name.indexOf(".pattern")!=-1 || name.indexOf(".learner_response")!=-1 ))
	{
		if (currentInteraction!=null)
		{
			if (currentInteraction.itype=="fill-in" ||
				currentInteraction.itype=="long-fill-in")
			{
				result=value;
			}
			else if (currentInteraction.itype=="choice" ||
				currentInteraction.itype=="likert" ||
				currentInteraction.itype=="matching" ||
				currentInteraction.itype=="sequencing")
			{
				var tmp=value.split(",");
				result="";
				for (i=0;i<tmp.length;i++)
				{
					if (tmp[i]=="1" || tmp[i]=="0")
					{		
						if (tmp[i]=="1")
							result=result+(result.length>0?"[,]":"")+"ID"+(i+1);
					}
					else
					{
						var smp=tmp[i];
						if (currentInteraction.itype=="matching")
						{
							t=smp.split(".");
							smp="s"+t[0]+"[.]"+"t"+t[1];
						}
						result=result+(result.length>0?"[,]":"")+smp;
					}
				}
			}
		}
	}	

	return result;
}

function LMSInitialize()
{
 
   var result="false";
   var api = getAPIHandle();
   if (api == null)
   {
      if (traceAPI) 
      	WriteTrace("Unable to locate the LMS's API Implementation. LMSInitialize was not successful.");
      else
      	alert("Unable to locate the LMS's API Implementation.\nLMSInitialize was not successful.");
   }
   else
   {   
	   if (apiVersion==12)
	   {
		   if (traceAPI) WriteTrace("Calling LMSInitialize('')");
		   result = api.LMSInitialize("");
		   if (traceAPI) WriteTrace("...return value : "+result);
	   }
	   else if (apiVersion==13)
	   {
		   if (traceAPI) WriteTrace("Calling Initialize('')");
		   result = api.Initialize("");
		   if (traceAPI) WriteTrace("...return value : "+result);
	   }
	
	   if (result != "true")
	   {
	      ErrorHandler(true);
	   }
   }

   return result;
}

/*******************************************************************************
**
** Function doLMSFinish()
** Inputs:  None
** Return:  CMIBoolean true if successful
**          CMIBoolean false if failed.
**
** Description:
** Close communication with LMS by calling the LMSFinish
** function which will be implemented by the LMS
**
*******************************************************************************/
function LMSFinish()
{
   var result ="false";
   var api = getAPIHandle();
   if (api == null)
   {
	  if (traceAPI) 
      	WriteTrace("Unable to locate the LMS's API Implementation. LMSFinish was not successful.");
      else
      	alert("Unable to locate the LMS's API Implementation.\nLMSFinish was not successful.");
   }
   else
   {
	  if (apiVersion==12)
	  {
		if (traceAPI) WriteTrace("Calling LMSFinish('')");
      	result = api.LMSFinish("");
      	if (traceAPI) WriteTrace("...return value : "+result);
  	  }
  	  else if (apiVersion==13)
	  {
		if (traceAPI) WriteTrace("Calling Terminate('')");
      	result = api.Terminate("");
      	if (traceAPI) WriteTrace("...return value : "+result);
  	  }
      	
      if (result != "true")
      {
      	ErrorHandler(true);
      }

   }

   return result;
}

function LMSGetValue(name)
{
   var orgname=name;
   name=mapModelName(name);
   var value="";
   
   if (name==null)
   {
	if (traceAPI) WriteTrace("Ignoring call to LMSGetValue('"+orgname+"'), datamodel not supported by the active SCORM API!");
   	return "";
   }
   	
   var api = getAPIHandle();
   if (api == null)
   {
      if (traceAPI) 
      	WriteTrace("Unable to locate the LMS's API Implementation. LMSGetValue was not successful.");
      else
   	alert("Unable to locate the LMS's API Implementation.\nLMSGetValue was not successful.");
   }
   else if (!bighorn_ignore_cmi_interactions || name!="cmi.interactions._children")
   {
      if (apiVersion==12)
      {
	   if (traceAPI) WriteTrace("Calling LMSGetValue('"+name+"')");
      	   value = api.LMSGetValue(name);
      	   if (traceAPI) WriteTrace("...return value : "+value);
      }
      else if (apiVersion==13)
      {
	  if (traceAPI) WriteTrace("Calling GetValue('"+name+"')");
      	  value = api.GetValue(name);
      	  if (traceAPI) WriteTrace("...return value : "+value);
      }
      
      var errCode = LMSGetLastError();
      if (traceAPI) WriteTrace("...error code   : "+errCode);
      
      if (errCode == _NoError)
	  {      
         if (value!=null)
         {
	     	if (value.toString)
         		value=value.toString();
     	 }
      }
   }
   
   return value;
}

function LMSSetValue(name, value)
{	
   var orgname=name;
   name=mapModelName(name);
   if (name==null)  
   {
	if (traceAPI) WriteTrace("Ignoring call to LMSSetValue('"+orgname+"','"+value+"'), datamodel not supported by the active SCORM API!");
	return "true";
   }
   
   value=mapModelValue(name,value);
	 
   var result="";
   var api = getAPIHandle();
   if (api == null)
   {
      if (traceAPI) 
      	WriteTrace("Unable to locate the LMS's API Implementation. LMSSetValue was not successful.");
      else
      	alert("Unable to locate the LMS's API Implementation.\nLMSSetValue was not successful.");
   }
   else
   {
	   	if (apiVersion==12)
	   	{
      		if (traceAPI) WriteTrace("Calling LMSSetValue('"+name+"','"+value+"')");
      		result = api.LMSSetValue(name, value);
      		if (traceAPI) WriteTrace("...return value : "+result);
   		}
   		else if (apiVersion==13)
	   	{
      		if (traceAPI) WriteTrace("Calling SetValue('"+name+"','"+value+"')");
      		result = api.SetValue(name, value);
      		if (traceAPI) WriteTrace("...return value : "+result);
   		}
      	
   		if (result != "true")
      	{
        	 ErrorHandler(true);
      	}
   }

   return result;
}


function LMSCommit()
{
   var result="false";
   var api = getAPIHandle();
   if (api == null)
   {
      if (traceAPI) 
      	WriteTrace("Unable to locate the LMS's API Implementation. LMSCommit was not successful.");
      else
      	alert("Unable to locate the LMS's API Implementation.\nLMSCommit was not successful.");
   }
   else
   {
	   	if (apiVersion==12)
	   	{
	  		if (traceAPI) WriteTrace("Calling LMSCommit('')");
      		result = api.LMSCommit("");
      		if (traceAPI) WriteTrace("...return value : "+result);
  		}
  		else if (apiVersion==13)
  		{
	  		if (traceAPI) WriteTrace("Calling Commit('')");
      		result = api.Commit("");
      		if (traceAPI) WriteTrace("...return value : "+result);
  		}
	}
      		
	if (result != "true")
	{
		var err=ErrorHandler(false);
		if (err != _NoError)
   		{
			showAlert(err,LMSGetErrorString(err),LMSGetDiagnostic(err));
		}
	}
   
    return result;
}

function showAlert(err,errStr,errDesc)
{
	if (err==_NoError || err=="401")
	{
		return;
	}
	else
	{
		alert("The Learning Management System reported an error when saving your progress.\n\nError: ("+err+") "+errStr+"\n"+errDesc+"\n\nYou can exit the course and start it again to re-initate the communication. You may also continue running the course but your progress may not be saved!");
	}
}

function LMSGetLastError()
{
   var api = getAPIHandle();
   if (api == null)
   {
      if (!traceAPI) alert("Unable to locate the LMS's API Implementation.\nLMSGetLastError was not successful.");
      //since we can't get the error code from the LMS, return a general error
      return _GeneralError;
   }

   if (apiVersion==12)
   		return api.LMSGetLastError().toString();
   else
   		return api.GetLastError().toString();  
}


function LMSGetErrorString(errorCode)
{
   var api = getAPIHandle();
   if (api == null)
   {
      if (!traceAPI) alert("Unable to locate the LMS's API Implementation.\nLMSGetErrorString was not successful.");
   }

   if (apiVersion==12)
   		return api.LMSGetErrorString(errorCode).toString();
   else
   	   	return api.GetErrorString(errorCode).toString();
}


function LMSGetDiagnostic(errorCode)
{
   	var api = getAPIHandle();
   	if (api == null)
   	{
      	if (!traceAPI) alert("Unable to locate the LMS's API Implementation.\nLMSGetDiagnostic was not successful.");
   	}
	
   	var ret="";
   
   	try {
   		if (apiVersion==12 && api.LMSGetDiagnostic)
     		ret=api.LMSGetDiagnostic(errorCode).toString();
   		else if (api.GetDiagnostic)
   			ret=api.GetDiagnostic(errorCode).toString();   
 	}
 	catch (error)
 	{
	}
   	return ret;
}


function ErrorHandler(showError)
{
   var api = getAPIHandle();
   if (api == null)
   {
      if (!traceAPI) alert("Unable to locate the LMS's API Implementation.\nCannot determine LMS error code.");
      return;
   }

   // check for errors caused by or from the LMS
   var errCode = LMSGetLastError().toString();
   if (errCode != _NoError)
   {
	  if (traceAPI) WriteTrace("...error code     :"+errCode);
      if (showError)
      {
		   var errStr=LMSGetErrorString(errCode);
		   var errDesc=LMSGetDiagnostic(errCode);
		   if (traceAPI) WriteTrace("...error string     :"+errStr);
		   if (traceAPI) WriteTrace("...error diagnostic :"+errDesc);
		   
		   showAlert(errCode,errStr,errDesc);
       } 
   }

   return errCode;
}

/******************************************************************************
**
** Function getAPIHandle()
** Inputs:  None
** Return:  value contained by APIHandle
**
** Description:
** Returns the handle to API object if it was previously set,
** otherwise it returns null
**
*******************************************************************************/
function getAPIHandle()
{
   if (apiHandle == null)
   {
      apiHandle = GetAPI(this);
      if (traceAPI) 
      	if (apiHandle==null)
      		WriteTrace("FATAL! No SCORM API found!");
      	else
      		WriteTrace("Found a SCORM API! Version detected: "+(apiVersion==12?"SCORM 1.2":"SCORM 2004"));
   }
   else
   {
	   // check that the API is alive
		try
		{
		    if (apiVersion==12)
   				apiHandle.LMSGetLastError();
   			else
   				apiHandle.GetLastError();
		}
		catch (err)
		{
		    alert("Unable to save your progress!\n\nCommunication with the Learning Managment System has been lost! You will need to start the course again to re-initiate communication.");
		}
   }

   return apiHandle;
}


var nFindAPITries = 0;
var maxTries = 500;

function containsAPI(win)
{
	if ( (bighorn_use_scormversion=="auto" || bighorn_use_scormversion=="1.2") && win.API != null)
		return true;
	else if ( (bighorn_use_scormversion=="auto" || bighorn_use_scormversion=="1.3") && win.API_1484_11 != null)
		return true;
	else
		return false;
}

function ScanForAPI(win)
{
	while (!containsAPI(win))
	{
		nFindAPITries++;
		if (nFindAPITries > maxTries)
		{
			return null;
		}
		win = win.parent;
	}
	
	if ((bighorn_use_scormversion=="auto" || bighorn_use_scormversion=="1.3") && win.API_1484_11!=null)
	{
		apiVersion=13;
		return win.API_1484_11;
	}
	else if ((bighorn_use_scormversion=="auto" || bighorn_use_scormversion=="1.2") && win.API!=null)
	{
		apiVersion=12;
		return win.API;
	}
	else
	{
		return null;
	}
}
function GetAPI(win)
{
	var scormAPI=null;
	if (win.parent && (win.parent != null) && (win.parent != win))
	{
		scormAPI = ScanForAPI(win.parent);
	}
	if (win.opener && (scormAPI == null) && (win.opener != null))
	{
		scormAPI = ScanForAPI(win.opener);
	}
	return scormAPI;
}
