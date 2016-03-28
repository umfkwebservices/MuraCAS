<!---

This file is part of MuraCAS

Copyright 2016 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to log out of CAS --->

<!--- delete any sessions with no tickets in them for this IP --->
<cfquery name="clearEmptySessions" datasource="#pluginConfig.getSetting('muraDatasource')#">
DELETE FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#"> AND (`ticket` = "" OR `ticket` = NULL)
</cfquery>

<!--- get all sessions for this IP address with tickets, and invalidate them --->
<cfquery name="getsessioninfo" datasource="#pluginConfig.getSetting('muraDatasource')#">
SELECT * FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#"> ORDER BY `logindt`
</cfquery>

<cfif Len(Trim(getsessioninfo.ticket))>
	<cfloop query="getsessioninfo">
		<cfset logoutTicket = getsessioninfo.ticket>
		<cfquery name="invalidateAuth" datasource="#pluginConfig.getSetting('muraDatasource')#">
		DELETE FROM `mcsessions` WHERE `ticket` = <cfqueryparam value="#logoutTicket#">
		</cfquery>
	</cfloop>
</cfif>

<!--- clear the session values, then send to CAS to log out of there --->
<cfscript>
StructClear(session);
cas_path = pluginConfig.getSetting("casServer");
cas_url = cas_path & "logout";
</cfscript>
<cflocation url="#cas_url#" addtoken="false">