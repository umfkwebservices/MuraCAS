<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to check for valid CAS authentication --->
<cfparam name="url.muraAction" default="" />
<cfset casPublic = pluginConfig.getSetting('casForPub') />
<cfset ticketVal = "" />
<cfif url.returnURL NEQ "">
	<cfset pageURL = url.returnURL />
	<!--- check to see if there is a ticket in the return URL --->
	<cfset decodedUrl = URLDecode(url.returnURL) />
	<cfset startpos = findNoCase("?ticket=",decodedUrl) + 7 />
	<cfset remStr = Left(decodedUrl,startpos) />
	<cfset ticketVal = replaceNoCase(decodedUrl,remStr,"","all") />
	<cfelse>
		<cfset pageURL = "https://"&CGI.SERVER_NAME&"/" />
</cfif>
<!--- remove standard ports from the pageURL --->
<cfset pageURL = ReplaceNoCase(pageURL,":80","","all") />
<cfset pageURL = ReplaceNoCase(pageURL,":443","","all") />
<cfset chkFile = GetFileFromPath(pageURL) />
<cfif Len(chkFile) GT 0>
	<cfset app_path = ReplaceNoCase(pageURL,chkFile,"","all") />
	<cfelse>
		<cfset app_path = pageURL />
</cfif>
<cfset redirect = pageURL />
<cfset cas_path = pluginConfig.getSetting("casServer") />
<cfset cas_url = cas_path & "login?" & "service=" & app_path />
<cfset appcode = "" />

<!--- auth check --->
<!--- check to see if there is a ticket as a URL parameter--->
<cfif url.ticket NEQ "">
	<cfset ticketVal = url.ticket />
</cfif>
<!--- check if a session matches this ticket and is not expired; if not, check for a non-expired session based on IP --->
<cfif ticketVal NEQ "">
	<cfset qType = "validateAuth" />
	<cfelse>
		<cfset qType = "validateAuthIP" />
</cfif>
<cfinclude template="authqueries.cfm" />

<cfif validateAuth.recordCount EQ 0>
	<cfset qType = "storeTmpRedirect" />
	<cfinclude template="authqueries.cfm" />
	<cflocation url="#cas_url#" addtoken="no" />
</cfif>