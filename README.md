#MuraCAS

This plugin allows CAS authentication for the Mura admin console, and optionally, site users.


##Updates to this version:
* Added a setting to select whether public users login through CAS or through Mura's native authentication
* Added a setting for the duration of a CAS session before it times out
* Moved database table creation and deletion to the plugin.cfc under install and delete functions, respectively (as it should have been)
* Removed the Mura datasource setting, instead using the datasource setting the in the Mura instance's global configuration
* Added the creation of a scheduled task called "Mura Clear CAS Sessions" to clean out any expired sessions from the mcsessions database table (interval is determined by the session duration setting)
* Cleaned up code and placed duplicate functionality into include files


##To Do:
* Create a default user group for CAS users
* Create user accounts for CAS users that don't currently exist in Mura
* Option to override the public user CAS authentication setting on a per-site basis


##Tested With
* Mura CMS Core Version 7.1+
* Lucee 5.3.7.48
* MySQL 5.7.22


##License
Copyright 2021 University of Maine at Fort Kent

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.