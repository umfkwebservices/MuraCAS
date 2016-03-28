<!---

This file is part of MuraCAS

Copyright 2016 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to log into of CAS --->

<cfparam name="url.ticket" default="">
<!--- auth check --->
<!--- check to see if there is a valid session already in place --->
<cfif url.ticket NEQ "">
	<cfset ticketVal = url.ticket>
	<cfelse>
<cfset ticketVal = "">
</cfif>
<cfquery name="validateAuth" datasource="#pluginConfig.getSetting('muraDatasource')#">
SELECT * FROM `mcsessions` WHERE `ticket` = <cfqueryparam value="#ticketVal#">
</cfquery>

<cfif validateAuth.recordCount EQ 0>

	<cfif Len(Trim(url.ticket))>
		<!--- get the temporarily stored information from the initial login --->
		<cfquery name="gettempinfo" datasource="#pluginConfig.getSetting('muraDatasource')#">
		SELECT * FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#"> ORDER BY `logindt` DESC LIMIT 1
		</cfquery>
		<cfscript>
		chkFile = GetFileFromPath(gettempinfo.loginlocation);
		if (Len(chkFile) GT 0) {
			app_path = ReplaceNoCase(gettempinfo.loginlocation,chkFile,"","all");
		} else {
			app_path = gettempinfo.loginlocation;
		};
		loginlocation = gettempinfo.loginlocation;
		</cfscript>
		
		<!--- get the ticket authorizing this app's login --->
		<cfset cas_path = pluginConfig.getSetting("casServer")>
		<cfset cas_url = cas_path & "serviceValidate?ticket=" & ticketVal & "&service=" & app_path>
		<cfhttp url="#cas_url#" method="get" throwonerror="yes" resolveurl="yes">
			<cfhttpparam type="header" name="Accept-Encoding" value="*" />
			<cfhttpparam type="header" name="TE" value="deflate;q=0" />
		</cfhttp>
		<!--- read the response and store the information --->
		<cfset objXML = xmlParse(cfhttp.filecontent)>
		<cfset SearchResults = XmlSearch(objXML,"cas:serviceResponse/cas:authenticationSuccess/cas:user")>
		<cfif arraylen(SearchResults)>
			<cfset uid = SearchResults[1].XmlText>
			<!--- variable for the user's email address domain --->
			<cfif Len(Trim(pluginConfig.getSetting("emailDomain")))>
				<cfset emailDomain = pluginConfig.getSetting("emailDomain")>
				<cfset emailAddress = uid&"@"&emailDomain>
				<cfelse>
					<cfset emailAddress = "">
			</cfif>
			<cfset isAuthorized = "1">
			<!--- store the session info on the server --->
			<cfquery name="storeAuth" datasource="#pluginConfig.getSetting('muraDatasource')#">
			UPDATE `mcsessions` SET `username`=<cfqueryparam value="#uid#">, `email`=<cfqueryparam value="#emailAddress#">, `authorized`=<cfqueryparam value="#isAuthorized#">, `ticket`=<cfqueryparam value="#ticketVal#"> WHERE `session_id` = <cfqueryparam value="#gettempinfo.session_id#">
			</cfquery>
			<cfelse>
				<cflocation url="#cas_url#" addtoken="no">
		</cfif>
		<!---Look for an account with the user identifier returned by CAS--->
		<cfquery name="userdata" datasource="#pluginConfig.getSetting('muraDatasource')#">
		SELECT `userid`,`type` FROM `tusers` WHERE `username` = <cfqueryparam value="#uid#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfscript>
			if (Len(Trim(loginlocation))) {
				pageURL = loginlocation;
			} else {
				pageURL = "https://"&CGI.SERVER_NAME&"/";
			};
			pageURL = ReplaceNoCase(pageURL,":80","","all");
			pageURL = ReplaceNoCase(pageURL,":443","","all");
			if (pageURL CONTAINS "siteid") {
				qinfoLength = Len(pageURL);
				siteidStart = FindNoCase("siteid=",pageURL);
				siteIdVal = Right(pageURL,qinfoLength-siteidStart+1)
				siteIdEnd = FindNoCase("&",siteIdVal);
				if (siteIdEnd NEQ 0) {
					siteIdVal = Left(siteIdVal,siteIdEnd-1);
				}
				siteIdVal = ReplaceNoCase(siteIdVal,"siteid=","","all");
			} else {
				siteIdVal = "default";
			};
			
			loginData= StructNew();
			loginData.returnUrl = pageURL;
			loginData.userid = userdata.userid;
			loginData.siteid = siteIdVal;
			if (userdata.type EQ "2") {
				loginData.isAdminLogin= true;
			} else {
				loginData.isAdminLogin= false;
			};
		</cfscript>
		<cfset doUserLogin = application.loginManager.loginByUserID(loginData,"")>
	</cfif>

</cfif>