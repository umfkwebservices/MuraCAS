<!---

This file is part of MuraCAS

Copyright 2016 University of Maine at Fort Kent
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfscript>
include 'settings.cfm';
</cfscript>
<cfoutput>
	<plugin>
		<name>#variables.settings.pluginName#</name>
		<package>#variables.settings.package#</package>
		<directoryFormat>packageOnly</directoryFormat>
		<loadPriority>#variables.settings.loadPriority#</loadPriority>
		<version>#variables.settings.version#</version>
		<provider>#variables.settings.provider#</provider>
		<providerURL>#variables.settings.providerURL#</providerURL>
		<category>#variables.settings.category#</category>
		<autoDeploy>false</autoDeploy>
		<settings>
			<setting>
				<name>casServer</name>
				<label>CAS Server</label>
				<hint>The URL for your CAS server used for authentication (include http or https)</hint>
				<type>text</type>
				<required>true</required>
				<validation>none</validation>
				<regex></regex>
				<message></message>
				<defaultvalue></defaultvalue>
			</setting>
			<setting>
				<name>emailDomain</name>
				<label>Mura User Email Domain</label>
				<hint>The domain of your users' email addresses (do not include the @ symbol)</hint>
				<type>text</type>
				<validation>none</validation>
				<regex></regex>
				<message></message>
				<defaultvalue></defaultvalue>
			</setting>
			<setting>
				<name>muraDatasource</name>
				<label>Mura Datasource</label>
				<hint>The datasource for your Mura installation</hint>
				<type>text</type>
				<required>true</required>
				<validation>none</validation>
				<regex></regex>
				<message></message>
				<defaultvalue></defaultvalue>
			</setting>
		</settings>

		<!-- Event Handlers -->
		<eventHandlers>
			<!-- only need to register the eventHandler.cfc via onApplicationLoad() -->
			<eventHandler event="onSiteLoginPromptRender" component="extensions.casauth" persist="false" />
			<eventHandler event="onAdminHTMLHeadRender" component="extensions.casauth" persist="false" />
			<eventHandler event="onPageBodyRender" component="extensions.casauth" persist="false" />
			<eventHandler event="onAfterSiteLogout" component="extensions.casauth" persist="false" />
			<eventHandler event="onGlobalLogout" component="extensions.casauth" persist="false" />
		</eventHandlers>

		<displayobjects location="global" />

	</plugin>
</cfoutput>