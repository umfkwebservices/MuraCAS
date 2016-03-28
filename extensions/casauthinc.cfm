<!---

This file is part of MuraCAS

Copyright 2016 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to check for valid CAS authentication --->

<cfparam name="url.returnURL" default="">
<cfparam name="url.ticket" default="">
<cfparam name="url.muraAction" default="">

<cfquery name="chkDBTable" datasource="#pluginConfig.getSetting('muraDatasource')#">
CREATE TABLE IF NOT EXISTS `mcsessions`(`session_id` int(10) NOT NULL AUTO_INCREMENT, `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `authorized` tinyint(1) DEFAULT '0', `ticket` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `loginlocation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `useripaddress` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `logindt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`session_id`)) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
</cfquery>

<cfscript>
	if (url.returnURL NEQ "" AND url.muraAction NEQ "clogin.main") {
		pageURL = url.returnURL;
	} else {
		pageURL = "https://"&CGI.SERVER_NAME&"/";
	};
	pageURL = ReplaceNoCase(pageURL,":80","","all");
	pageURL = ReplaceNoCase(pageURL,":443","","all");
	
	if (pageURL NEQ "") {
		chkFile = GetFileFromPath(pageURL);
		if (Len(chkFile) GT 0) {
			app_path = ReplaceNoCase(pageURL,chkFile,"","all");
		} else {
			app_path = pageURL;
		};
		redirect = pageURL;
	} else {
		redirect = "https://"&CGI.SERVER_NAME&"/";
		app_path = "https://"&CGI.SERVER_NAME&"/";
	}
	cas_path = pluginConfig.getSetting("casServer");
	cas_url = cas_path & "login?" & "service=" & app_path;
	appcode = "";
</cfscript>

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
	<cfif not len(trim(ticketVal))>
		<!--- temporarily store the redirect value to pull the information back into the script after CAS authentication --->
		<cfquery name="storetmpredirect" datasource="#pluginConfig.getSetting('muraDatasource')#">
		INSERT INTO `mcsessions` (`loginlocation`,`useripaddress`) VALUES (<cfqueryparam value="#redirect#">,<cfqueryparam value="#CGI.REMOTE_ADDR#">)
		</cfquery>
		<cflocation url="#cas_url#" addtoken="no">
	</cfif>
</cfif>
