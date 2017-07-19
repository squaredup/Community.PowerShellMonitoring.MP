# Community.PowerShellMonitoring.MP

## What is the PowerShell Monitoring MP

The PowerShell Monitoring Management pack extends Microsoft Systems Center Operations Manager (SCOM) to allow creation of PowerShell based monitors, rules, tasks, diagnostics and recoveries directly from the SCOM console using the Authoring tab.  No MP authoring knowledge is required to create these - authors can leverage their existing scripts and the UI contains the samples they need to modify them to work with SCOM.

To make use of these Management packs, you will need SCOM installed and configured, monitoring your environment.  From that point all you need is enough knowledge of PowerShell scripting to accomplish whatever monitoring tasks are required.

## Getting started

This GitHub repository contains the source files. The sealed downloadable management packs can be found here:

[https://download.squaredup.com/#managementpacks](https://download.squaredup.com/#managementpacks)

To install the PowerShell Monitoring mp you will need:

* SCOM 2012 R2 (earlier versions may be supported but are untested)
* SCOM Admin rights (only administrators can import management packs)
* SCOM authoring rights provided to all users who need to create PowerShell-based workflows

### Install the SCOM Management Pack

Import the management pack into SCOM using the standard process.

The MP will show up as `PowerShell Monitoring - Community Management Pack`.

### Using the MP

The MPs add various templates to the appropriate _Create..._ wizards in the _Authoring_ tab of the SCOM console.  For example, right clicking on _Monitors_ and selecting _Create a Monitor_ -> _Unit Monitor_ will now include a _PowerShell Based_ folder under _Scripting_.

The following table displays all templates added by this management pack:

| Name | Type | Description |
|------|------|-------------|
| Run a PowerShell Script                       | Diagnostic | Runs a script as a diagnostic, returning text |
| PowerShell Script Three State Monitor         | Monitor    | Runs a script and reports Healthy, Warning, or Critical based on the script output |
| PowerShell Script Two State Monitor           | Monitor    | Runs a script and reports Healthy or Warning/Critical based on the script output |
| Run a PowerShell Script                       | Recovery   | Runs a script as a recovery, returning text |
| PowerShell Script Alert Generating Rule       | Rule       | Raises Alerts if the output of a PowerShell script matches a specified criteria |
| PowerShell Script Event Collection Rule       | Rule       | Collects events created and submitted by a PowerShell script |
| Run a PowerShell Script on an event           | Rule       | Runs a PowerShell script if a specified event is detected |
| PowerShell Script Performance Collection Rule | Rule       | Collects performance metrics created and submitted by a PowerShell script |
| Run a PowerShell Script                       | Rule       | Runs a PowerShell script on a routine interval |
| Run a PowerShell script                       | Task       | Runs a simple script as an agent task, returning text|

Each template allows you to specify a script, and dynamically insert arguments based on the workflow target.  Each template includes a sample script that already has the necessary boilerplate to work with the SCOM API, so no prior knowledge is necessary.  Scripts will not be checked for correctness by the template however, so ensure you have thoroughly tested them prior to using the templates.

Arguments are passed to the script as a _single string_, so if you need to pass multiple arguments you should use the `String` `.Split` method with an appropriate separator to convert `$Arguments` into an array.  Remember that you can also insert values from the Targeted class anywhere into the script (i.e. into unique variables in the script body) so the main purpose of injecting values via arguments is for overrides (since the Arguments value is overridable in all templates).

## Samples

The `Samples` folder contains example scripts you could use in your own SCOM workflows.  These are not included in the management pack, and dependencies may vary from script to script.

## Releases

While anyone is free to download and import these management pack projects, sealed and signed releases of these management packs will only be available via [https://download.squaredup.com/#managementpacks](https://download.squaredup.com/#managementpacks).

Releases of these management packs will use semantic versioning, and will occur as and when warranted.

## Help and Assistance

These management packs are community packs originally developed by Squared Up ([https://www.squaredup.com](https://www.squaredup.com)) and inspired by [Wei Lim](https://blogs.msdn.microsoft.com/wei_out_there_with_system_center/).

For help and advice, post questions on [http://community.squaredup.com/answers](http://community.squaredup.com/answers).

If you have found a specific bug or issue with the templates in this management pack, please raise an [issue](https://github.com/squaredup/Community.PowerShellMonitoring.MP/issues) on GitHub.

## Contributions

If you want to suggest some fixes or improvements to the management pack, raise an issue on [the GitHub issues page](https://github.com/squaredup/Community.DataOnDemand.MP/issues), or better, submit the suggested change as a [Pull Request](https://github.com/squaredup/Community.PowerShellMonitoring.MP/pulls).

If you have an awesome script that you would like to share with people, feel free to submit a pull request and add the script to the `samples` folder (making sure to include some context in the script help for what/how it can be used).

### Guidelines

* Please target pull requests at the develop branch.
* If your change would bring in a non-standard MP reference (i.e a management pack not imported into SCOM by default) then please create a new management pack in the solution.
* Target the minimum version of a management pack reference that you can, and avoid versions that were introduced in particular cumulative updates.
* Ensure that there are no outstanding Management Pack Best Practices Analyser issues reported by your change.
* If you introduce a custom Probe or Write Action module, please use appropriate types for your configuration elements (i.e do not use string for values that clearly are boolean).
* Do not update the version numbers of the MP in your pull request.
* Template DisplayStrings should be suffixed with (Community).