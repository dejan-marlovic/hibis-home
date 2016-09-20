function gFld(description, hreference)
{
	// empty
}

var launched=false;
function gLnk(linkTitle, linkData, description, linkKeywords) 
{ 
	// handle launch of first module, other modules will be ignored. No local tracking will be performed
	if (!launched)
	{
		launched=true;
		if (newWindow>0)
			document.location.href=linkData.substring(3).replace("/Player.html?","/PlayerWin.html?")+"&startloc=0:0:0:-1";
		else
			document.location.href=linkData.substring(3)+"&startloc=0:0:0:-1";
	}
}

function insFld(parentFolder, childFolder)
{
	// empty
}

function insDoc(parentFolder, childItem)
{
	// empty
}




