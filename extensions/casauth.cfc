<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	<cffunction name="onSiteLoginPromptRender">
		<cfset casPublic = pluginConfig.getSetting('casForPub') />
		<cfif casPublic EQ 'yes'>
			<cfparam name="url.returnURL" default="" />
			<cfparam name="url.ticket" default="" />
			<cfinclude template="casauthinc.cfm" />
		</cfif>
	</cffunction>

	<cffunction name="standardRequireLoginHandler">
		<!--- set a URL for the current page --->
		<cfset thisSiteDomain = $.siteConfig().get('domain') />
		<cfset siteSSL = $.siteConfig().get('usessl') />
		<cfset thisPage = CGI.PATH_INFO />
		<cfset pageURL = "http" />
		<cfif siteSSL EQ 1>
			<cfset pageURL = pageURL & "s" />
		</cfif>
		<cfset pageURL = pageURL & "://" & thisSiteDomain & thisPage />

		<cfparam name="url.returnURL" default="#pageURL#" />
		<cfparam name="url.ticket" default="" />
		<cfparam name="url.showadmin" default="false" />
		<cfinclude template="caslogininc.cfm" />
	</cffunction>

	<cffunction name="onAdminHTMLHeadRender">
		<cfparam name="url.returnURL" default="" />
		<cfparam name="url.ticket" default="" />
		<cfinclude template="casauthinc.cfm" />
	</cffunction>

	<cffunction name="onRenderStart">
		<cfparam name="url.returnURL" default="" />
		<cfparam name="url.ticket" default="" />
		<cfparam name="url.showadmin" default="false" />
		<cfinclude template="caslogininc.cfm" />
	</cffunction>

	<cffunction name="onAfterSiteLogout">
		<cfinclude template="caslogoutinc.cfm" />
	</cffunction>

	<cffunction name="onGlobalLogout">
		<cfinclude template="caslogoutinc.cfm" />
	</cffunction>
</cfcomponent>