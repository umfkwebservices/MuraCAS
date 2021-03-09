<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to log into CMS with CAS credentials --->

<cfif url.showadmin EQ "true">
	<cfset thisSiteDomain = $.siteConfig().get('domain') />
	<cfset siteSSL = $.siteConfig().get('usessl') />
	<cfset redirectVal = "http" />
	<cfif siteSSL EQ 1>
		<cfset redirectVal = redirectVal & "s" />
	</cfif>
	<cfset redirectVal = redirectVal & "://" & thisSiteDomain & '/admin/' />
	<cflocation url="#redirectVal#" addToken="no" />
</cfif>

<!--- auth check --->
<!--- check to see if there is a valid session already in place --->
<cfif IsDefined("ticketVal") AND ticketVal NEQ "">
	<cfset ticketVal = ticketVal />
<cfelseif url.ticket NEQ "">
	<cfset ticketVal = url.ticket />
	<cfelse>
		<cfset ticketVal = "" />
</cfif>

<!--- check if one of the remaining sessions matches this ticket and is not expired --->
<cfif ticketVal NEQ "">
	<cfset qType = "validateAuth" />
	<cfelse>
		<cfset qType = "validateAuthIP" />
</cfif>
<cfinclude template="authqueries.cfm" />

<cfif validateAuth.recordCount EQ 0 AND Len(Trim(ticketVal)) GT 0>
	<!--- get the temp info stored for this user --->
	<cfset qType = "getTempInfo" />
	<cfinclude template="authqueries.cfm" />

	<!--- if there is temp info stored, handle the login of the user --->
	<cfif gettempinfo.RecordCount NEQ 0>
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
		<cfset cas_path = pluginConfig.getSetting("casServer") />
		<cfset cas_url = cas_path & "serviceValidate?ticket=" & ticketVal & "&service=" & app_path />
		<cfhttp url="#cas_url#" method="get" throwonerror="yes" resolveurl="yes">
			<cfhttpparam type="header" name="Accept-Encoding" value="*" />
			<cfhttpparam type="header" name="TE" value="deflate;q=0" />
		</cfhttp>

		<!--- read the response and store the information --->
		<cfset objXML = xmlParse(cfhttp.filecontent) />
		<cfset SearchResults = XmlSearch(objXML,"cas:serviceResponse/cas:authenticationSuccess/cas:user") />
		<cfif arraylen(SearchResults)>
			<cfset uid = SearchResults[1].XmlText />

			<!--- variable for the user's email address domain --->
			<cfif Len(Trim(pluginConfig.getSetting("emailDomain")))>
				<cfset emailDomain = pluginConfig.getSetting("emailDomain") />
				<cfset emailAddress = uid&"@"&emailDomain />
				<cfelse>
					<cfset emailAddress = "" />
			</cfif>
			<cfset isAuthorized = "1" />

			<!--- store the session info on the server --->
			<cfset qType = "updateAuth" />
			<cfinclude template="authqueries.cfm" />
			<cfelse>
				<cfinclude template="casauthinc.cfm" />
		</cfif>
		<!---Look for an account with the user identifier returned by CAS--->
		<cfset qType = "getUserData" />
		<cfinclude template="authqueries.cfm" />

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
		<cfset doUserLogin = application.loginManager.loginByUserID(loginData,"") />
	</cfif>
</cfif>
