From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Add SuSE init scripts for multipath-tools
Date: Tue, 31 Jul 2007 11:32:08 +0200
Message-ID: <46AF0198.5@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060704000000090904000705"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060704000000090904000705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

here are the init scripts for SuSE for multipath and multipathd.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------060704000000090904000705
Content-Type: text/plain;
 name="suse-fixes"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="suse-fixes"

multipath init scripts for SuSE

This patch adds the SuSE initscripts for multipath and multipathd.

Signed-off-by: Hannes Reinecke <hare@suse.de>
diff --git a/multipath/multipath.init.suse b/multipath/multipath.init.suse
new file mode 100755
index 0000000..ff31dba
--- /dev/null
+++ b/multipath/multipath.init.suse
@@ -0,0 +1,125 @@
+#! /bin/sh
+# Copyright (c) 2005 SuSE GmbH Nuernberg, Germany.
+#
+# Author: Hannes Reinecke <feedback@suse.de>
+#
+# init.d/boot.multipath
+#
+### BEGIN INIT INFO
+# Provides:          boot.multipath
+# Required-Start:    boot.device-mapper boot.udev
+# Required-Stop:
+# Default-Start:     B
+# Default-Stop:
+# Description:       Create multipath device targets
+### END INIT INFO
+
+PATH=/bin:/usr/bin:/sbin:/usr/sbin
+PROGRAM=/sbin/multipath
+
+# Set the maximum number of open files
+MAX_OPEN_FDS=4096
+
+test -x $PROGRAM || exit 5
+
+# Shell functions sourced from /etc/rc.status:
+#      rc_check         check and set local and overall rc status
+#      rc_status        check and set local and overall rc status
+#      rc_status -v     ditto but be verbose in local rc status
+#      rc_status -v -r  ditto and clear the local rc status
+#      rc_failed        set local and overall rc status to failed
+#      rc_reset         clear local rc status (overall remains)
+#      rc_exit          exit appropriate to overall rc status
+. /etc/rc.status
+
+# First reset status of this service
+rc_reset
+
+# Return values acc. to LSB for all commands but status:
+# 0 - success
+# 1 - misc error
+# 2 - invalid or excess args
+# 3 - unimplemented feature (e.g. reload)
+# 4 - insufficient privilege
+# 5 - program not installed
+# 6 - program not configured
+# 7 - program is not running
+# 
+# Note that starting an already running service, stopping
+# or restarting a not-running service as well as the restart
+# with force-reload (in case signalling is not supported) are
+# considered a success.
+
+maplist=$(/sbin/dmsetup ls --target multipath | sed '/No devices/d' | cut -f 1)
+
+case "$1" in
+    start)
+	echo -n "Creating multipath targets:"
+	# Check whether multipath daemon is already running
+	if /sbin/multipathd -k"list paths" > /dev/null 2>&1 ; then
+	    echo -n " (multipathd running)"
+	    rc_status -v
+	    rc_exit
+	fi
+
+	# Load prerequisite module
+	modprobe dm-multipath
+	
+	# Be a chicken and flush all existing maps
+	for map in  $maplist ; do
+	    $PROGRAM -f $map
+	done
+
+	# Clear /dev/disk/by-name/ prior to start-up; multipath will
+	# recreate them.
+	rm -f /dev/disk/by-name/* 2>&1 >/dev/null
+
+	# Set the maximum number of open files
+	if [ -n "$MAX_OPEN_FDS" ] ; then
+	    ulimit -n $MAX_OPEN_FDS
+	fi
+
+	# Start the program directly as checkproc doesn't work here
+	$PROGRAM -v 0
+
+	# Create all partitions which might have been missing
+	/sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p -part"
+
+	# Remember status and be verbose
+	rc_status -v
+	sleep 1
+	;;
+    stop)
+	echo -n "Removing multipath targets:"
+
+	# Remove all partition mappings
+	if /sbin/dmsetup ls | sed '/No devices/d' | grep -q -- -part; then
+	    /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -d -p -part" 2> /dev/null
+	fi
+
+	# Flush all existing maps
+	for map in $maplist ; do
+	    $PROGRAM -f $map
+	done
+
+	rc_failed 0
+	rc_status -v
+	;;
+    status)
+	echo -n "Checking multipath targets: "
+	# Display active multipath tables
+	tblnum=$(/sbin/dmsetup ls --target multipath | sed '/No devices/d' | wc --lines)
+	if [ "$tblnum" ] && [ $tblnum -gt 0 ] ; then
+	    echo -n "($tblnum multipath devices) "
+	    rc_failed 0
+	else
+	    rc_failed 3
+	fi
+	rc_status -v
+	;;
+    *)
+	echo "Usage: $0 {start|stop|status}"
+	exit 1
+	;;
+esac
+rc_exit
diff --git a/multipathd/multipathd.init.suse b/multipathd/multipathd.init.suse
new file mode 100755
index 0000000..d851354
--- /dev/null
+++ b/multipathd/multipathd.init.suse
@@ -0,0 +1,132 @@
+#! /bin/sh
+# Copyright (c) 1995-2001 SuSE GmbH Nuernberg, Germany.
+#
+# Author: Hannes Reinecke <feedback@suse.de>
+#
+# init.d/routed
+#
+#   and symbolic its link
+#
+# /usr/sbin/rcrouted
+#
+### BEGIN INIT INFO
+# Provides:          multipathd
+# Required-Start:    $syslog
+# Required-Stop:
+# Default-Start:     3 5
+# Default-Stop:	     0 1 2 4 6
+# Description:       Starts multipath daemon
+### END INIT INFO
+
+PATH=/bin:/usr/bin:/sbin:/usr/sbin
+DAEMON=/sbin/multipathd
+PIDFILE=/var/run/multipathd.pid
+
+# Set the maximum number of open files
+MAX_OPEN_FDS=4096
+
+test -x $DAEMON || exit 5
+
+. /etc/rc.status
+
+# First reset status of this service
+rc_reset
+
+case "$1" in
+    start)
+	echo -n "Starting multipathd"
+
+	modprobe dm-multipath
+
+	# Set the maximum number of open files
+	if [ -n "$MAX_OPEN_FDS" ] ; then
+	    ulimit -n $MAX_OPEN_FDS
+	fi
+
+	if [ -f $PIDFILE ]; then
+		PID="$(cat $PIDFILE)"
+		PROCNAME="$(ps -o cmd --no-headers $PID)"
+	fi
+
+	if [ "$PROCNAME" != "$DAEMON" ]; then
+		$DAEMON
+	fi
+	
+	# Remember status and be verbose
+	rc_status -v
+	sleep 1
+	;;
+    stop)
+	echo -n "Shutting down multipathd"
+	# Because of the way how multipathd sets up its own namespace
+	# and chroots to it, killproc cannot be used with this process.
+	# So implement a cruder version:
+	if [ -f $PIDFILE ]; then
+		PID="$(cat $PIDFILE)"
+		PROCNAME="$(ps -o cmd --no-headers $PID)"
+	fi
+
+	if [ "$PROCNAME" == "$DAEMON" ]; then
+		kill -TERM $PID
+	fi
+
+	# Remember status and be verbose
+	rc_status -v
+	;;
+    try-restart)
+	## Stop the service and if this succeeds (i.e. the 
+	## service was running before), start it again.
+        $0 status >/dev/null &&  $0 restart
+
+	# Remember status and be quiet
+	rc_status
+	;;
+    restart|force-reload)
+	## Stop the service and regardless of whether it was
+	## running or not, start it again.
+	$0 stop
+	$0 start
+
+	# Remember status and be quiet
+	rc_status
+	;;
+    reload)
+	## Like force-reload, but if daemon does not support
+	## signalling, do nothing (!)
+
+	# If it does not support reload:
+	exit 3
+	;;
+    status)
+	echo -n "Checking for multipathd: "
+
+	# Status has a slightly different for the status command:
+	# 0 - service running
+	# 1 - service dead, but /var/run/  pid  file exists
+	# 2 - service dead, but /var/lock/ lock file exists
+	# 3 - service not running
+
+	if [ -f $PIDFILE ]; then
+		PID="$(cat $PIDFILE)"
+		PROCNAME="$(ps -o cmd --no-headers $PID)"
+		if [ "$PROCNAME" == "$DAEMON" ]; then
+			(exit 0)
+		else
+			(exit 1)
+		fi
+	else
+		(exit 3)
+	fi
+
+	rc_status -v
+	;;
+    probe)
+	## Optional: Probe for the necessity of a reload,
+	## give out the argument which is required for a reload.
+	;;
+    *)
+	echo "Usage: $0 {start|stop|status|try-restart|restart|force-reload|reload|probe}"
+	exit 1
+	;;
+esac
+rc_exit

--------------060704000000090904000705
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060704000000090904000705--
