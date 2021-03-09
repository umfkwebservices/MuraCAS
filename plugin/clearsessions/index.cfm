<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<!---
parameter used to indicate the action to take
possible values:
	install
	update
	delete
--->
<cfparam name="setClrSchedule" default="" />

<cfif setClrSchedule EQ "install" OR setClrSchedule EQ "update">
	<!--- get the information of the current site set up in Mura --->
	<cfset siteDomain = $.siteConfig().get('domain') />
	<cfset siteSSL = $.siteConfig().get('usessl') />
	<!--- set the plugin directory --->
	<cfset pluginsLocation = Replace($.GlobalConfig().get('plugindir'),'\','/','all') />
	<cfset pluginDir = ListLast(pluginsLocation,'/') />
	<!--- if the plugin directory value is empty, use the default value --->
	<cfif pluginDir EQ "">
		<cfset pluginDir = 'plugins' />
	</cfif>
	<!--- get the folder for this plugin --->
	<cfset thisPluginDir = pluginConfig.getPackage() />
	<!--- construct the URL for the scheduled task --->
	<cfset clearSessionsURL = "http" />
	<cfif siteSSL EQ 1>
		<cfset clearSessionsURL = clearSessionsURL & "s" />
	</cfif>
	<!--- set the start date and time --->
	<cfset timeoutVal = pluginConfig.getSetting('casDuration') />
	<cfif timeoutVal EQ "">
		<cfset timeoutVal = 90 />
	</cfif>
	<cfset timeoutSec = timeoutVal * 60 />
	<cfset startDT = DateAdd('n',timeoutVal,Now()) />
	<cfset clearSessionsURL = clearSessionsURL & "://" & siteDomain & "/" & pluginDir & "/" & thisPluginDir & "/plugin/clearsessions/" />
	<cfschedule action="update" task="Mura Clear CAS Sessions" operation="HTTPRequest" url="#clearSessionsURL#" port="443" startdate="#DateFormat(startDT,'mm/dd/yyyy')#" starttime="#TimeFormat(startDT,'short')#" interval="#timeoutSec#" resolveurl="true" requesttimeout="1000" />
<cfelseif setClrSchedule EQ "delete">
	<cfschedule action="delete" task="Mura Clear CAS Sessions" />
	<cfelse>
		<!--- clear expired sessions --->
		<cfset qType = "clearExpSessions" />
		<cfinclude template="../../extensions/authqueries.cfm" />
</cfif>