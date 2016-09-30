<!---

This file is part of MuraCAS

Copyright 2016 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to log out of CAS --->

<!--- get all sessions for this IP address and invalidate them --->
<cfquery name="getsessioninfo" datasource="#pluginConfig.getSetting('muraDatasource')#">
DELETE FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#">
</cfquery>

<!--- clear the session values, then send to CAS to log out of there --->
<cfscript>
StructClear(session);
cas_path = pluginConfig.getSetting("casServer");
cas_url = cas_path & "logout";
</cfscript>
<cflocation url="#cas_url#" addtoken="false">