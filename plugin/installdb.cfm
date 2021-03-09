<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!---
variable defining which action to take
possible values:
	installPlugin
	uninstallPlugin
--->
<cfparam name="dbAction" default="installPlugin" />

<!--- do the following when installing or updating the plugin --->
<cfif dbAction EQ "installPlugin">
	<!--- make the sessions db table if it doesn't exist --->
	<cfquery name="chkDBTable" datasource="#$.GlobalConfig().get('datasource')#">
	CREATE TABLE IF NOT EXISTS `mcsessions`(`session_id` int(10) NOT NULL AUTO_INCREMENT, `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `authorized` tinyint(1) DEFAULT '0', `ticket` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `loginlocation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `useripaddress` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, `logindt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`session_id`)) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
	</cfquery>

<!--- do the following when uninstalling the plugin --->
<cfelseif dbAction EQ "uninstallPlugin">
	<!--- delete the sessions table from the database --->
	<cfquery name="delDBTable" datasource="#$.GlobalConfig().get('datasource')#">
	DROP TABLE IF EXISTS `mcsessions`
	</cfquery>
</cfif>