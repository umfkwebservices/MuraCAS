<cfscript>
/**
* 
* This file is part of MuraCAS
*
* Copyright 2016 University of Maine at Fort Kent
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<style type="text/css">
	#bodyWrap h3{padding-top:1em;}
	#bodyWrap ul{padding:0 0.75em;margin:0 0.75em;}
</style>
<cfsavecontent variable="body"><cfoutput>
<div id="bodyWrap">
	<h1>#HTMLEditFormat(pluginConfig.getName())#</h1>
	<p>This is a plugin to allow CAS authentication for Mura. It overrides Mura's built-in login in favor of your selected CAS server.</p>
	<p>Updates to this version:</p>
	<ul>
		<li>Updated to override the Admin login page in addition to the 'ESC + L' login prompt</li>
		<li>Made the email domain setting an optional field</li>
		<li>Cleaned up code and placed duplicate functionality into include files</li>
	</ul>
	<p>
	<strong>Note:</strong> In order for the override of the admin login to work properly, the user is redirected to their site's homepage once login is complete. The user may then access the full administrative interface by clicking the "Site Manager" button on the Mura toolbar.
	</p>
	
	<h3>Requirements</h3>
	<p>This plugin has been built to create a custom table within your Mura datasource for the purpose of temporarily storing session data. The code to create this table is written in MySQL syntax. As such, there's no guarantee that it will work with database types other than MySQL.</p>
	<p>In addition, each user who authenticates against the CAS server will need a user account in Mura with an identical username as used for CAS authentication. Mura user rights will still be managed in Mura for all authenticated users.</p>

	<h3>Tested With</h3>
	<ul>
		<li>Mura CMS Core Version <strong>6.2+</strong></li>
		<li>Railo 4.2.1.008</strong></li>
		<li>MySQL 5.6.21</strong></li>
	</ul>

</div>
</cfoutput></cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
		body = body
		, pageTitle = pluginConfig.getName()
		, jsLib = 'jquery'
		, jsLibLoaded = false
	)#
</cfoutput>