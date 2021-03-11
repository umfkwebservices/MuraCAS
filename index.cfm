<cfscript>
/**
*
* This file is part of MuraCAS
*
* Copyright 2021 University of Maine at Fort Kent
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<style type="text/css">
	#bodyWrap h2, #bodyWrap p, #bodyWrap div{padding-top:1em;margin-bottom: 0;}
	#bodyWrap ul{padding:1em 0 0 .75em;margin:0 0 0 .75em;}
</style>

<cfsavecontent variable="pluginBody">
<cfoutput>
<div id="bodyWrap">
	<h1><strong>#esapiEncode('html', pluginConfig.getName())# #pluginConfig.getVersion()#</strong></h1>
	<p>This is a plugin to allow CAS authentication for Mura. It overrides Mura's built-in login in favor of your selected CAS server.</p>

	<h2>Updates in this version:</h2>
	<ul>
		<li>Fixed a bug in the authqueries.cfm extension where the empty parameter referencing a query value (gettempinfo.session_id) caused an error. Now, rather than an invalid parameter, IsDefined is used to check if the value exists.</li>
	</ul>

	<h2>Updates in version 2.0:</h2>
	<ul>
		<li>Added a setting to select whether public users login through CAS or through Mura's native authentication</li>
		<li>Added a setting for the duration of a CAS session before it times out</li>
		<li>Moved database table creation and deletion to the plugin.cfc under install and delete functions, respectively (as it should have been)</li>
		<li>Removed the Mura datasource setting, instead using the datasource setting the in the Mura instance's global configuration</li>
		<li>Added the creation of a scheduled task called "Mura Clear CAS Sessions" to clean out any expired sessions from the mcsessions database table (interval is determined by the session duration setting)</li>
		<li>Cleaned up code and placed duplicate functionality into include files</li>
	</ul>
	<h2>To Do:</h2>
	<ul>
		<li>Create a default user group for CAS users</li>
		<li>Create user accounts for CAS users that don't currently exist in Mura</li>
		<li>Option to override the public user CAS authentication setting on a per-site basis</li>
	</ul>
	<p>
	<strong>Note:</strong> In order for the override of the admin login to work properly, the user is redirected to their site's homepage once login is complete. The user may then access the full administrative interface by clicking the "Dashboard" or "Tree View" buttons on the Mura toolbar.
	</p>

	<h2>Requirements</h2>
	<p>This plugin has been built to create a custom table within your Mura datasource for the purpose of temporarily storing session data. The code to create this table is written in MySQL syntax. As such, there's no guarantee that it will work with database types other than MySQL.</p>
	<p>In addition, each user who authenticates against the CAS server will need a user account in Mura with an identical username as used for CAS authentication. Mura user rights will still be managed in Mura for all authenticated users.</p>

	<h2>Tested With</h2>
	<ul>
		<li>Mura CMS Core Version 7.1+</li>
		<li>Lucee 5.3.7.48</li>
		<li>MySQL 5.7.22</li>
	</ul>

</div>
</cfoutput>
</cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(pluginBody)#
</cfoutput>