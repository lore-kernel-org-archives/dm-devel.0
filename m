From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clean up and organize
	multipathd/multipathd.8
Date: Fri, 28 Oct 2016 15:48:46 +0200
Message-ID: <20161028134846.4127-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathd.8 | 271 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 180 insertions(+), 91 deletions(-)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 96a8fdb..4c765af 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -1,218 +1,307 @@
-.TH MULTIPATHD 8 "November 2009" "Linux Administrator's Manual"
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t multipathd/multipathd.8
+.\"
+.\" ----------------------------------------------------------------------------
+.
+.TH MULTIPATHD 8 2016-10-27 Linux
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH NAME
-multipathd \- multipath daemon
-
+.\" ----------------------------------------------------------------------------
+.
+multipathd \- Multipath daemon.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH SYNOPSIS
+.\" ----------------------------------------------------------------------------
+.
 .B multipathd
-.RB [\| options \|]
-
+.RB [\| \-d | \-k \|]
+.RB [\| \-s \|]
+.RB [\| \-v\ \c
+.IR verbosity \|]
+.RB [\| \-B \|]
+.RB [\| \-n \|]
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
-The
-.B multipathd
-daemon is in charge of checking for failed paths. When this happens,
-it will reconfigure the multipath map the path belongs to, so that this map
-regains its maximum performance and redundancy.
+.\" ----------------------------------------------------------------------------
+.
+The \fBmultipathd\fR daemon is in charge of checking for failed paths. When this
+happens, it will reconfigure the multipath map the path belongs to, so that this
+map regains its maximum performance and redundancy.
 
-This daemon executes the external multipath config tool when events occur.
+This daemon executes the external \fBmultipath\fR tool when events occur.
 In turn, the multipath tool signals the multipathd daemon when it is done with
 devmap reconfiguration, so that it can refresh its failed path list.
-
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH OPTIONS
+.\" ----------------------------------------------------------------------------
+.
 .TP
 .B \-d
 Foreground Mode. Don't daemonize, and print all messages to stdout and stderr.
+.
 .TP
 .B \-s
 Suppress timestamps. Do not prefix logging messages with a timestamp.
+.
 .TP
-.B -v "level"
-Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well.
+.BI \-v " level"
+Verbosity level. Print additional information while running multipathd. A  level
+of 0 means only print errors. A level of 3 or greater prints debugging information
+as well.
+.
 .TP
-.B -B
-Read-only bindings file. Multipathd will not write to the user_friendly_names
-bindings file. If a user_friendly_name doesn't already exist for a device, it
+.B \-B
+Read-only bindings file. multipathd will not write to the \fIuser_friendly_names\fR
+bindings file. If a \fIuser_friendly_name\fR doesn't already exist for a device, it
 will use its WWID as its alias.
-.TP
-.B -k
-multipathd will enter interactive mode. From this mode, the available commands can be viewed by entering "help". When you are finished entering commands, press CTRL-D to quit.
-.TP
-.B -n
-ignore new devices. Multipathd will not create a multipath device unless the
-wwid for the device is already listed in the wwids file.
-
+.
+.TP
+.B \-k
+multipathd will enter interactive mode. From this mode, the available commands can
+be viewed by entering '\fIhelp\fR'. When you are finished entering commands, press
+\fBCTRL-D\fR to quit.
+.
+.TP
+.B \-n
+Ignore new devices. multipathd will not create a multipath device unless the
+WWID for the device is already listed in the WWIDs file.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH COMMANDS
+.\" ----------------------------------------------------------------------------
+.
 .TP
 The following commands can be used in interactive mode:
+.
 .TP
 .B list|show paths
 Show the paths that multipathd is monitoring, and their state.
+.
 .TP
 .B list|show paths format $format
 Show the paths that multipathd is monitoring, using a format string with path
 format wildcards.
+.
 .TP
 .B list|show maps|multipaths
 Show the multipath devices that the multipathd is monitoring.
+.
 .TP
 .B list|show maps|multipaths format $format
 Show the status of all multipath devices that the multipathd is monitoring,
 using a format string with multipath format wildcards.
+.
 .TP
 .B list|show maps|multipaths status
 Show the status of all multipath devices that the multipathd is monitoring.
+.
 .TP
 .B list|show maps|multipaths stats
 Show some statistics of all multipath devices that the multipathd is monitoring.
+.
 .TP
 .B list|show maps|multipaths topology
-Show the current multipath topology. Same as "multipath \-ll".
+Show the current multipath topology. Same as '\fImultipath \-ll\fR'.
+.
 .TP
 .B list|show topology
-Show the current multipath topology. Same as "multipath \-ll".
+Show the current multipath topology. Same as '\fImultipath \-ll\fR'.
+.
 .TP
 .B list|show map|multipath $map topology
-Show topology of a single multipath device specified by $map, e.g. 36005076303ffc56200000000000010aa.
-This map could be obtained from "list maps".
+Show topology of a single multipath device specified by $map, for example
+36005076303ffc56200000000000010aa. This map could be obtained from
+'\fIlist maps\fR'.
+.
 .TP
 .B list|show wildcards
-Show the format wildcards used in interactive commands taking $format
+Show the format wildcards used in interactive commands taking $format.
+.
 .TP
 .B list|show config
-Show the currently used configuration, derived from default values and values specified within the configuration file /etc/multipath.conf.
+Show the currently used configuration, derived from default values and values
+specified within the configuration file \fI/etc/multipath.conf\fR.
+.
 .TP
 .B list|show blacklist
-Show the currently used blacklist rules, derived from default values and values specified within the configuration file /etc/multipath.conf.
+Show the currently used blacklist rules, derived from default values and values
+specified within the configuration file \fI/etc/multipath.conf\fR.
+.
 .TP
 .B list|show devices
-Show all available block devices by name including the information if they are blacklisted or not.
+Show all available block devices by name including the information if they are
+blacklisted or not.
+.
 .TP
 .B list|show status
-Show the number of path checkers in each possible state, the number of monitored paths, and whether multipathd is currently handling a uevent.
+Show the number of path checkers in each possible state, the number of monitored
+paths, and whether multipathd is currently handling a uevent.
+.
 .TP
 .B list|show daemon
-Show the current state of the multipathd daemon
+Show the current state of the multipathd daemon.
+.
 .TP
 .B add path $path
 Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
+.
 .TP
 .B remove|del path $path
 Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
+.
 .TP
 .B add map|multipath $map
-Add a multipath device to the list of monitored devices. $map can either be a device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g. 36005076303ffc56200000000000010aa).
+Add a multipath device to the list of monitored devices. $map can either be a
+device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias
+for the multipath device (e.g. mpath1) or the uid of the multipath device
+(e.g. 36005076303ffc56200000000000010aa).
+.
 .TP
 .B remove|del map|multipath $map
 Stop monitoring a multipath device.
+.
 .TP
 .B resize map|multipath $map
-Resizes map $map to the given size
+Resizes map $map to the given size.
+.
 .TP
 .B switch|switchgroup map|multipath $map group $group
-Force a multipath device to switch to a specific path group. $group is the path group index, starting with 1.
+Force a multipath device to switch to a specific path group. $group is the path
+group index, starting with 1.
+.
 .TP
 .B reconfigure
-Reconfigures the multipaths. This should be triggered automatically after any hotplug event.
+Reconfigures the multipaths. This should be triggered automatically after anyi
+hotplug event.
+.
 .TP
 .B suspend map|multipath $map
 Sets map $map into suspend state.
+.
 .TP
 .B resume map|multipath $map
 Resumes map $map from suspend state.
+.
 .TP
 .B reset map|multipath $map
 Reassign existing device-mapper table(s) use use the multipath device, instead
 of its path devices.
+.
 .TP
 .B reload map|multipath $map
 Reload a multipath device.
+.
 .TP
 .B fail path $path
 Sets path $path into failed state.
+.
 .TP
 .B reinstate path $path
 Resumes path $path from failed state.
+.
 .TP
 .B disablequeueing maps|multipaths
 Disable queueing on all multipath devices.
+.
 .TP
 .B restorequeueing maps|multipaths
 Restore queueing on all multipath devices.
+.
 .TP
 .B disablequeueing map|multipath $map
-Disable queuing on multipathed map $map
+Disable queuing on multipathed map $map.
+.
 .TP
 .B restorequeueing map|multipath $map
-Restore queuing on multipahted map $map
+Restore queuing on multipahted map $map.
+.
 .TP
 .B forcequeueing daemon
 Forces multipathd into queue_without_daemon mode, so that no_path_retry queueing
-will not be disabled when the daemon stops
+will not be disabled when the daemon stops.
+.
 .TP
 .B restorequeueing daemon
-Restores configured queue_without_daemon mode
+Restores configured queue_without_daemon mode.
+.
 .TP
 .B map|multipath $map setprstatus
-Enable persistent reservation management on $map
+Enable persistent reservation management on $map.
+.
 .TP
 .B map|multipath $map unsetprstatus
-Disable persistent reservation management on $map
+Disable persistent reservation management on $map.
+.
 .TP
 .B map|multipath $map getprstatus
-Get the current persistent reservation management status of $map
+Get the current persistent reservation management status of $map.
+.
 .TP
 .B quit|exit
 End interactive session.
+.
 .TP
 .B shutdown
 Stop multipathd.
-
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SYSTEMD INTEGRATION"
-When compiled with systemd support two systemd service files are
-installed,
-.I multipathd.service
-and
-.I multipathd.socket
-The
-.I multipathd.socket
-service instructs systemd to intercept the CLI command socket, so
-that any call to the CLI interface will start-up the daemon if
-required.
-The
-.I multipathd.service
-file carries the definitions for controlling the multipath daemon.
-The daemon itself uses the
-.B sd_notify(3)
-interface to communicate with systemd. The following unit keywords are
-recognized:
-.TP
-.I WatchdogSec=
+.\" ----------------------------------------------------------------------------
+.
+When compiled with systemd support two systemd service files are installed,
+\fImultipathd.service\fR and \fImultipathd.socket\fR The \fImultipathd.socket\fR
+service instructs systemd to intercept the CLI command socket, so that any call
+to the CLI interface will start-up the daemon if required.
+The \fImultipathd.service\fR file carries the definitions for controlling the
+multipath daemon. The daemon itself uses the \fBsd_notify\fR(3) interface to
+communicate with systemd. The following unit keywords are recognized:
+.
+.TP
+.B WatchdogSec=
 Enables the internal watchdog from systemd. multipath will send a
-notification via
-.B sd_notify(3)
-to systemd to reset the watchdog. If specified the
-.I polling_interval
-and
-.I max_polling_interval
-settings will be overridden by the watchdog settings.
-
+notification via \fBsd_notify\fR(3) to systemd to reset the watchdog. If
+specified the \fIpolling_interval\fR and \fImax_polling_interval\fR settings
+will be overridden by the watchdog settings.
 Please note that systemd prior to version 207 has issues which prevent
 the systemd-provided watchdog from working correctly. So the watchdog
 is not enabled per default, but has to be enabled manually by updating
-the multipathd.service file.
-.TP
-.I OOMScoreAdjust=
-Overrides the internal OOM adjust mechanism
-.TP
-.I LimitNOFILE=
-Overrides the
-.I max_fds
-configuration setting.
-
+the \fImultipathd.service\fR file.
+.
+.TP
+.B OOMScoreAdjust=
+Overrides the internal OOM adjust mechanism.
+.
+.TP
+.B LimitNOFILE=
+Overrides the \fImax_fds\fR configuration setting.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
-.BR multipath (8)
-.BR kpartx (8)
-.BR sd_notify (3)
-.BR system.service (5)
-.SH "AUTHORS"
-.B multipathd
-was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
+.\" ----------------------------------------------------------------------------
+.
+.BR multipath (8),
+.BR kpartx (8),
+.BR sd_notify (3),
+.BR system.service (5).
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH AUTHORS
+.\" ----------------------------------------------------------------------------
+.
+\fImultipath-tools\fR was developed by Christophe Varoqui <christophe.varoqui@opensvc.com>
+and others.
+.\" EOF
-- 
2.10.1
