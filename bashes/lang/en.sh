#!/bin/bash

declare -A lang
lang=(
    [root_needed]="You must be the root user to run this project."
    [have]="available."
    [installed]="installed."
    [not_installed]="could not be installed."
    [installing]="installing..."
    [creating]="creating..."
    [not_created]="could not be created."
    [deleting]="deleting..."
    [deleted]="deleted."
    [not_deleted]="could not be deleted."
    [cloning]="copying..."
    [not_cloned]="could not be copied."
    [configured]="configured."
    [configuring]="configuring..."
    [not_configured]="could not be configured."
    [enabled]="enabled."
    [enabling]="enabling..."
    [not_enabled]="could not be enabled."
    [restarting]="restarting..."
    [restarted]="restarted."
    [not_restarted]="failed to restart."
    [set_mysql_password]="Set MySQL root password"
    [repeat_mysql_password]="Re-enter MySQL root password"
    [passwords_not_match]="Passwords do not match."
    [checking]="checking..."
    [php_extensions]="PHP extensions"
    [project_permissions]="Project permissions"
    [project_permissions_changing]="Changing project permissions..."
    [project_permissions_changed]="Project permissions changed."
    [project_permissions_not_changed]="Could not change project permissions."
    [composer_packages]="Composer packages"
    [project_settings]="Project settings"


)