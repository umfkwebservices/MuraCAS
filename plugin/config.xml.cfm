<!---

This file is part of MuraCAS

Copyright 2021 University of Maine at Fort Kent
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
				<name>casForPub</name>
				<label>Use CAS Authentication for Public Users?</label>
				<hint>If set to No, CAS will only be used for admin login</hint>
				<type>select</type>
				<required>true</required>
				<validation>none</validation>
				<optionlist>yes^no</optionlist>
				<optionlabellist>Yes^No</optionlabellist>
				<regex></regex>
				<message></message>
				<defaultvalue>yes</defaultvalue>
			</setting>
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
				<name>casDuration</name>
				<label>Session Duration</label>
				<hint>The duration of a valid session (in minutes)</hint>
				<type>text</type>
				<required>true</required>
				<validation>numeric</validation>
				<regex></regex>
				<message>The entered value must be a valid number of minutes (as an integer)</message>
				<defaultvalue>90</defaultvalue>
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
		</settings>

		<!-- Event Handlers -->
		<eventHandlers>
			<!-- only need to register the eventHandler.cfc via onApplicationLoad() -->
			<eventHandler event="onSiteLoginPromptRender" component="extensions.casauth" persist="false" />
			<eventhandler event="standardRequireLoginHandler" component="extensions.casauth" persist="false" />
			<eventHandler event="onAdminHTMLHeadRender" component="extensions.casauth" persist="false" />
			<eventHandler event="onRenderStart" component="extensions.casauth" persist="false" />
			<eventHandler event="onAfterSiteLogout" component="extensions.casauth" persist="false" />
			<eventHandler event="onGlobalLogout" component="extensions.casauth" persist="false" />
		</eventHandlers>

		<displayobjects location="global" />

	</plugin>
</cfoutput>