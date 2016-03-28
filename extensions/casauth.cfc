<!---

This file is part of MuraCAS

Copyright 2016 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cffunction name="onSiteLoginPromptRender">
		<cfinclude template="casauthinc.cfm" />
	</cffunction>
	
	<cffunction name="onAdminHTMLHeadRender">
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
			<!--- in case a stray session from this user previously, and would result in displaying the Mura admin login screen, we will clear these out when the login screen loads, then redirect accordingly --->
			<cfparam name="url.muraAction" default="">
			<cfif url.muraAction EQ "clogin.main">
				<!--- delete any sessions with no tickets in them for this IP --->
				<cfquery name="clearEmptySessions" datasource="#pluginConfig.getSetting('muraDatasource')#">
				DELETE FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#">
				</cfquery>
			</cfif>
			<!--- if there's no validation by the URL ticket, check to see if there has been a recent login on this computer that hasn't been logged out in the past 90 minutes --->
			<cfif hour(now())-2 LT 0>
				<cfset chkHour = 23 + (hour(now())-2)>
				<cfset chkDay = day(now())-1>
				<cfelse>
					<cfset chkHour = hour(now())-2>
					<cfset chkDay = day(now())>
			</cfif>
			<cfif chkDay EQ 0>
				<cfset chkMonth = month(now())-1>
				<cfif chkMonth EQ 0>
					<cfset chkMonth = 12>
				</cfif>
				<cfset chkDay = DaysInMonth(chkMonth)>
				<cfelse>
					<cfset chkMonth = month(now())>
			</cfif>
			<cfif chkMonth EQ 12>
				<cfset chkYear = year(now())-1>
				<cfelse>
					<cfset chkYear = year(now())>
			</cfif>
			<cfset chkTime = CreateDateTime(chkYear,chkMonth,chkDay,chkHour,minute(now()),00)>
			<cfset chkTime = DateTimeFormat(chkTime,"yyyy-mm-dd HH:nn:ss")>
			<cfquery name="validateAuth" datasource="#pluginConfig.getSetting('muraDatasource')#">
			SELECT * FROM `mcsessions` WHERE `useripaddress` = <cfqueryparam value="#CGI.REMOTE_ADDR#"> AND `logindt` >= <cfqueryparam value="#chkTime#">
			</cfquery>
			<cfif validateAuth.recordCount NEQ 0>
				<cfinclude template="caslogininc.cfm" />
				<cfelse>
					<cfinclude template="casauthinc.cfm" />
			</cfif>
		</cfif>
		
	</cffunction>
	
	<cffunction name="onPageBodyRender">
		<cfinclude template="caslogininc.cfm" />
	</cffunction>
	
	<cffunction name="onAfterSiteLogout">
		<cfinclude template="caslogoutinc.cfm" />
	</cffunction>
	
	<cffunction name="onGlobalLogout">
		<cfinclude template="caslogoutinc.cfm" />
	</cffunction>
</cfcomponent>