// default config values, these will be overridden in config.js
var bighorn_exitmode="close";
var bighorn_resizemode="center";
var bighorn_ignore_cmi_interactions=false;
var bighorn_use_scormversion="1.2";

// If set to true the module will set "failed" status when user fails the exam otherwise sets "incomplete"
var bighorn_use_failed_status=false;

// If set to true the module will set "passed" status when user fails the exam otherwise sets "complete"
var bighorn_use_passed_status=true;

// Allows the player to log successfully to SAP, this will override the "bighorn_use_passed_status" option and set it to false and also set "cmi.core.exit=suspend" on course exit.
var bighorn_SAP_mode=false;

// Enables or disabled the warning message shown when users tries to close the course with the window close button.
var bighorn_onclose_warning=true;

// Load the rest of the player
include("config.js",bighorn_buildnr);
include("APIWrapper.js",bighorn_buildnr);
include("LessonLib.js",bighorn_buildnr);
include("launch.js",bighorn_buildnr);

