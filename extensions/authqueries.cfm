<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!---
set a parameter for the default value of qType
possible values:
	validateAuth
	validateAuthIP
	storeTmpRedirect
	updateAuth
	clearExpSessions
--->
<cfparam name="qType" default="" />

<!--- default values for required variables --->
<cfparam name="ticketVal" default="" />
<cfparam name="redirect" default="" />
<cfparam name="uid" default="" />
<cfparam name="emailAddress" default="" />
<cfparam name="isAuthorized" default="" />
<cfparam name="gettempinfo.session_id" default="" />

<!--- set the expiration date/time to compare against --->
<cfset timeoutVal = pluginConfig.getSetting('casDuration') />
<cfif timeoutVal EQ "">
	<cfset timeoutVal = 90 />
</cfif>
<cfset chkExpDT = DateAdd('n',-timeoutVal,Now()) />

<cfswitch expression="#qType#">
	<cfcase value="validateAuth">
		<!--- check for a session that matches the ticket --->
		<cfquery name="validateAuth" datasource="#$.GlobalConfig().get('datasource')#">
		SELECT * FROM `mcsessions` WHERE `ticket` = <cfqueryparam value="#ticketVal#" /> AND `logindt` >= <cfqueryparam value="#chkExpDT#" CFSQLType="CF_SQL_TIMESTAMP" /> AND `authorized` = 1
		</cfquery>
	</cfcase>
	<cfcase value="validateAuthIP">
		<!--- try to match a session by the user's IP address --->
		<cfquery name="validateAuth" datasource="#$.GlobalConfig().get('datasource')#">
		SELECT * FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#" /> AND `logindt` >= <cfqueryparam value="#chkExpDT#" CFSQLType="CF_SQL_TIMESTAMP" /> AND `authorized` = 1
		</cfquery>
	</cfcase>
	<cfcase value="storeTmpRedirect">
		<!--- temporarily store the redirect value to pull the information back into the script after CAS authentication --->
		<cfquery name="storeTmpRedirect" datasource="#$.GlobalConfig().get('datasource')#">
		INSERT INTO `mcsessions` (`loginlocation`,`useripaddress`) VALUES (<cfqueryparam value="#redirect#" />,<cfqueryparam value="#CGI.REMOTE_ADDR#" />)
		</cfquery>
	</cfcase>
	<cfcase value="getTempInfo">
		<!--- get the temporarily stored information from the initial login --->
		<cfquery name="gettempinfo" datasource="#$.GlobalConfig().get('datasource')#">
		SELECT * FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#" /> AND `logindt` >= <cfqueryparam value="#chkExpDT#" CFSQLType="CF_SQL_TIMESTAMP" /> ORDER BY `logindt` DESC LIMIT 1
		</cfquery>
	</cfcase>
	<cfcase value="updateAuth">
		<!--- if authorized, update the temp user info to include additional data needed to indicate a valid session --->
		<cfquery name="updateAuth" datasource="#$.GlobalConfig().get('datasource')#">
		UPDATE `mcsessions` SET `username`=<cfqueryparam value="#uid#" />, `email`=<cfqueryparam value="#emailAddress#" />, `authorized`=<cfqueryparam value="#isAuthorized#" />, `ticket`=<cfqueryparam value="#ticketVal#" /> WHERE `session_id` = <cfqueryparam value="#gettempinfo.session_id#" />
		</cfquery>
	</cfcase>
	<cfcase value="getUserData">
		<!---Look for an account with the user identifier returned by CAS--->
		<cfquery name="userdata" datasource="#$.GlobalConfig().get('datasource')#">
		SELECT `userid`,`type` FROM `tusers` WHERE `username` = <cfqueryparam value="#uid#" cfsqltype="cf_sql_varchar" />
		</cfquery>
	</cfcase>
	<cfcase value="clearExpSessions">
		<!--- clear expired sessions --->
		<cfquery name="clearExpSessions" datasource="#$.GlobalConfig().get('datasource')#">
		DELETE FROM `mcsessions` WHERE `logindt` < <cfqueryparam value="#chkExpDT#" CFSQLType="CF_SQL_TIMESTAMP" />
		</cfquery>
	</cfcase>
	<cfdefaultcase>
		<cfset validateAuth.RecordCount = 0 />
		<cfset gettempinfo.RecordCount = 0 />
		<cfset userdata.RecordCount = 0 />
	</cfdefaultcase>
</cfswitch>
