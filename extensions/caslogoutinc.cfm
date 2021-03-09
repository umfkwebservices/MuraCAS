<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!--- include file to log out of CAS --->

<!--- get all sessions for this IP address and invalidate them --->
<cfquery name="getsessioninfo" datasource="#$.GlobalConfig().get('datasource')#">
DELETE FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#" />
</cfquery>

<!--- clear the session values, then send to CAS to log out of there --->
<cfscript>
StructClear(session);
getPageContext().getSession().invalidate();
cas_path = pluginConfig.getSetting("casServer");
cas_url = cas_path & "logout";
</cfscript>
<cfloop item="name" collection="#cookie#">
	<!--- expire cookies --->
    <cfcookie name="#name#" value="" expires="now" />
</cfloop>
<cflocation url="#cas_url#" addtoken="false" />