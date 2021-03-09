/**
*
* This file is part of MuraCAS
*
* Copyright 2021 University of Maine at Fort Kent
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true extends='mura.plugin.plugincfc' output=false {

	// pluginConfig is automatically available as variables.pluginConfig
	include 'settings.cfm';

	// make the Mura scope available for installation
	if ( !IsDefined('$') ) {
		siteid = session.keyExists('siteid') ? session.siteid : 'default';
		$ = application.serviceFactory.getBean('$').init(siteid);
	}

	public void function install() {
		// create the mcsesssions database table in the Mura instance's datasource if it doesn't already exist
		var dbAction = 'installPlugin';
		include 'installdb.cfm';

		// create the scheduled task to clear expired sessions from the mcsessions table
		var setClrSchedule = 'install';
		include 'clearsessions/index.cfm';
	}

	public void function update() {
		// create the mcsesssions database table in the Mura instance's datasource if it doesn't already exist
		var dbAction = 'installPlugin';
		include 'installdb.cfm';

		// update the scheduled task to clear expired sessions from the mcsessions table
		var setClrSchedule = 'update';
		include 'clearsessions/index.cfm';
	}

	public void function delete() {
		// remove the mcsesssions database table in the Mura instance's datasource
		var dbAction = 'uninstallPlugin';
		include 'installdb.cfm';

		// remove the scheduled task to clear expired sessions from the mcsessions table
		var setClrSchedule = 'delete';
		include 'clearsessions/index.cfm';
	}

	// public void function toBundle(pluginConfig, bundle, siteid) output=false {
		// Do custom toBundle stuff
	// }

	// public void function fromBundle(bundle, keyFactory, siteid) output=false {
		// Do custom fromBundle stuff
	// }

	// access to the pluginConfig should available via variables.pluginConfig
	public any function getPluginConfig() {
		return StructKeyExists(variables, 'pluginConfig') ? variables.pluginConfig : {};
	}

}