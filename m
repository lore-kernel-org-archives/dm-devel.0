From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: remove useless init scripts
Date: Sat,  4 Jun 2016 01:54:38 +0200
Message-ID: <1464998078-20041-2-git-send-email-xose.vazquez@gmail.com>
References: <1464998078-20041-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464998078-20041-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>, Ritesh Raj Sarraf <rrs@debian.org>
List-Id: dm-devel.ids

Nobody uses them, relics.

Cc: Ritesh Raj Sarraf <rrs@debian.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathd.init.debian |  29 ------
 multipathd/multipathd.init.redhat | 152 -----------------------------
 multipathd/multipathd.init.suse   | 200 --------------------------------------
 3 files changed, 381 deletions(-)
 delete mode 100644 multipathd/multipathd.init.debian
 delete mode 100644 multipathd/multipathd.init.redhat
 delete mode 100644 multipathd/multipathd.init.suse

diff --git a/multipathd/multipathd.init.debian b/multipathd/multipathd.init.debian
deleted file mode 100644
index ed23b5b..0000000
--- a/multipathd/multipathd.init.debian
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/sh
-
-PATH=/bin:/usr/bin:/sbin:/usr/sbin
-DAEMON=/usr/bin/multipathd
-
-test -x $DAEMON || exit 0
-
-case "$1" in
-  start)
-	echo -n "Starting multipath daemon: multipathd"
-	$DAEMON
-	echo "."
-	;;
-  stop)
-	echo -n "Stopping multipath daemon: multipathd"
-	echo "."
-	$DAEMON shutdown
-	;;
-  force-reload|restart)
-	$0 stop
-	$0 start
-	;;
-  *)
-	echo "Usage: /etc/init.d/multipathd {start|stop|restart|force-reload}"
-	exit 1
-	;;
-esac
-
-exit 0
diff --git a/multipathd/multipathd.init.redhat b/multipathd/multipathd.init.redhat
deleted file mode 100644
index d46ef80..0000000
--- a/multipathd/multipathd.init.redhat
+++ /dev/null
@@ -1,152 +0,0 @@
-#!/bin/bash
-#
-# multipathd	Starts the multipath daemon
-#
-# chkconfig: - 06 87
-# description: Manages device-mapper multipath devices
-
-### BEGIN INIT INFO
-# Provides: multipathd
-# Required-Start:
-# Required-Stop:
-# Default-Start:
-# Default-Stop:
-# Short-Description: Control multipathd
-# Description: This service monitors and manages
-#              device-mapper multipath devices
-### END INIT INFO
-
-DAEMON=/sbin/multipathd
-prog=`basename $DAEMON`
-initdir=/etc/rc.d/init.d
-lockdir=/var/lock/subsys
-sysconfig=/etc/sysconfig
-syspath=/sys/block
-
- 
-. $initdir/functions
- 
-test -r $sysconfig/$prog && . $sysconfig/$prog
-
-RETVAL=0
-
-teardown_slaves()
-{
-pushd $1 > /dev/null
-if [ -d "slaves" ]; then
-for slave in slaves/*;
-do
-	if [ "$slave" = "slaves/*" ]; then
-		read dev <  $1/dev
-		tablename=`dmsetup table --target multipath | sed -n "s/\(.*\): .* $dev .*/\1/p"`
-		if ! [ -z $tablename ]; then
-			echo "Root is on a multipathed device, multipathd can not be stopped"
-			exit 1
-		fi
-	else
-		local_slave=`readlink -f $slave`;
-		teardown_slaves $local_slave;
-	fi
-	done
-
-else
-		read dev <  $1/dev
-		tablename=`dmsetup table --target multipath | sed -n "s/\(.*\): .* $dev .*/\1/p"`
-		if ! [ -z $tablename ]; then
-			echo "Root is on a multipathed device, multipathd can not be stopped"
-			exit 1
-		fi
-fi
-popd > /dev/null
-}
-
-#
-# See how we were called.
-#
-
-start() {
-	test -x $DAEMON || exit 5
-	echo -n $"Starting $prog daemon: "
-	daemon $DAEMON
-	RETVAL=$?
-	[ $RETVAL -eq 0 ] && touch $lockdir/$prog
-	echo
-}
-
-force_stop() {
-	echo -n $"Stopping $prog daemon: "
-	killproc $DAEMON
-	RETVAL=$?
-	[ $RETVAL -eq 0 ] && rm -f $lockdir/$prog
-	echo
-}
-
-check_root() {
-        root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
-	dm_num=`dmsetup info -c --noheadings -o minor $root_dev 2> /dev/null`
-	if [ $? -eq 0 ]; then
-		root_dm_device="dm-$dm_num"
-		[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
-	fi
-}
-
-force_queue_without_daemon() {
-	$DAEMON forcequeueing daemon
-}
-
-restart() {
-	force_queue_without_daemon
-	check_root
-	force_stop
-	start
-}
-
-force_restart() {
-	force_queue_without_daemon
-	force_stop
-	start
-}
-
-reload() {
-	echo -n "Reloading $prog: "
-	trap "" SIGHUP
-	killproc $DAEMON -HUP
-	RETVAL=$?
-	echo
-}	
-
-case "$1" in
-start)
-	start
-	;;
-stop)
-	check_root
-	force_stop
-	;;
-force-stop)
-	force_stop
-	;;
-force-reload|reload)
-	reload
-	;;
-restart)
-	restart
-	;;
-force-restart)
-	force_restart
-	;;
-condrestart|try-restart)
-	if [ -f $lockdir/$prog ]; then
-	    restart
-	fi
-	;;
-status)
-	status $prog
-	RETVAL=$?
-	;;
-*)
-	echo $"Usage: $0 {start|stop|force-stop|status|restart|force-restart|condrestart|reload}"
-	RETVAL=2
-esac
-
-exit $RETVAL
diff --git a/multipathd/multipathd.init.suse b/multipathd/multipathd.init.suse
deleted file mode 100644
index ed699fa..0000000
--- a/multipathd/multipathd.init.suse
+++ /dev/null
@@ -1,200 +0,0 @@
-#! /bin/sh
-# Copyright (c) 1995-2001 SuSE GmbH Nuernberg, Germany.
-#
-# Author: Hannes Reinecke <feedback@suse.de>
-#
-# init.d/multipathd
-#
-### BEGIN INIT INFO
-# Provides:          multipathd
-# Required-Start:    $syslog
-# Required-Stop:     $syslog
-# Default-Start:     3 5
-# Default-Stop:	     0 1 2 4 6
-# Short-Description: Starts multipath daemon
-# Description:       Starts the multipath daemon
-### END INIT INFO
-
-PATH=/bin:/usr/bin:/sbin:/usr/sbin
-DAEMON=/sbin/multipathd
-PIDFILE=/run/multipathd.pid
-MPATH_INIT_TIMEOUT=10
-ARGS=""
-
-# Set the maximum number of open files
-MAX_OPEN_FDS=4096
-
-# Set to enable asynchronous daemon startup
-DAEMON_ASYNC_STARTUP=
-
-test -x $DAEMON || exit 5
-
-. /etc/rc.status
-
-# First reset status of this service
-rc_reset
-
-case "$1" in
-    start)
-	echo -n "Starting multipathd"
-	ulimit -c unlimited
-	if $DAEMON -k"reconfigure" > /dev/null 2>&1 ; then
-	    echo -n " (multipathd running)"
-	    rc_status -v
-	    rc_exit
-	fi
-
-	modprobe dm-multipath
-
-	# Set the maximum number of open files
-	if [ -n "$MAX_OPEN_FDS" ] ; then
-	    ulimit -n $MAX_OPEN_FDS
-	fi
-
-	$DAEMON $ARGS
-
-	if [ -n "$DAEMON_ASYNC_STARTUP" ] ; then
-	    rc_status -v
-	    rc_exit
-	fi
-	# Wait for the daemon to start up
-	status=$($DAEMON -k'show daemon' 2> /dev/null)
-	timeout=$MPATH_INIT_TIMEOUT
-	while [ $timeout -gt 0 ] ; do
-	    if [ -n "$status" ] ; then
-		PID=${status##pid }
-		STATUS=${PID##* }
-		# Configuration might be taking some time,
-		# so don't increase the timeout here
-		[ "$STATUS" != "configure" ] && timeout=$(( $timeout - 1 ))
-
-		[ "$STATUS" == "running" ] && break
-	    else
-		timeout=$(( $timeout - 1 ))
-	    fi
-	    sleep 1
-	    status=$($DAEMON -k'show daemon' 2> /dev/null)
-	done
-	if [ -z "$status" ] ; then
-	    rc_failed 7
-	fi
-	if [ $timeout -le 0 ] ; then
-	    rc_failed 1
-	fi
-	# Remember status and be verbose
-	rc_status -v
-	;;
-    stop)
-	echo -n "Shutting down multipathd"
-	STATUS="unknown"
-	# Try to get PID from daemon
-	status=$($DAEMON -k'show daemon' 2> /dev/null)
-	if [ -n "$status" ] ; then
-	    PID=${status##pid }
-	    STATUS=${PID##* }
-	    PID=${PID%% *}
-	fi
-	# Fallback to PID file for older versions
-	if [ -z "$PID" ] || [ "$PID" == "multipath-tools" ] ; then
-	    if [ -f $PIDFILE ]; then
-		PID="$(cat $PIDFILE)"
-		STATUS="running"
-	    else
-		rc_failed 7
-		rc_status -v
-		rc_exit
-	    fi
-	fi
-	# Shutdown the daemon via CLI
-	if [ "$STATUS" = "running" ] ; then
-	    status=$($DAEMON -k'shutdown' 2> /dev/null)
-	    if [ "$status" = "ok" ] ; then
-		timeout=$MPATH_INIT_TIMEOUT
-		while [ $timeout -gt 0 ] ; do
-		    PROCNAME="$(ps -p $PID -o comm=)"
-		    if [ "$PROCNAME" != "multipathd" ] &&
-			[ "$PROCNAME" != "multipathd <defunct>" ] ; then
-			STATUS="shutdown"
-			break
-		    fi
-		    sleep 1
-		    timeout=$(( $timeout - 1 ))
-		done
-	    fi
-	fi
-	# Kill the daemon if the above failed
-	if [ -n "$PID" -a "$STATUS" != "shutdown" ] ; then
-	    kill -TERM $PID
-	    timeout=$MPATH_INIT_TIMEOUT
-	    while [ $timeout -gt 0 ] ; do
-		PROCNAME="$(ps -p $PID -o comm=)"
-		if [ "$PROCNAME" != "multipathd" ] &&
-		    [ "$PROCNAME" != "multipathd <defunct>" ] ; then
-		    STATUS="shutdown"
-		    break
-		fi
-		sleep 1
-		timeout=$(( $timeout - 1 ))
-	    done
-	fi
-	if [ $STATUS != "shutdown" ] ; then
-	    echo -n " (still running)"
-	    rc_failed 1
-	fi
-
-	# Remember status and be verbose
-	rc_status -v
-	;;
-    try-restart)
-	## Stop the service and if this succeeds (i.e. the 
-	## service was running before), start it again.
-        $0 status >/dev/null &&  $0 restart
-
-	# Remember status and be quiet
-	rc_status
-	;;
-    restart|force-reload)
-	## Stop the service and regardless of whether it was
-	## running or not, start it again.
-	$0 stop
-	$0 start
-
-	# Remember status and be quiet
-	rc_status
-	;;
-    reload)
-	## Like force-reload, but if daemon does not support
-	## signalling, do nothing (!)
-
-	$DAEMON -k"reconfigure" > /dev/null 2>&1
-
-	# Remember status and be quiet
-	rc_status
-	;;
-    status)
-	echo -n "Checking for multipathd: "
-
-	# Status has a slightly different for the status command:
-	# 0 - service running
-	# 1 - service dead, but /var/run/  pid  file exists
-	# 2 - service dead, but /var/lock/ lock file exists
-	# 3 - service not running
-
-	status=$($DAEMON -k'show daemon' 2> /dev/null)
-	if [ -n "$status" ]; then
-	        (exit 0)
-	else
-		(exit 3)
-	fi
-	rc_status -v
-	;;
-    probe)
-	## Optional: Probe for the necessity of a reload,
-	## give out the argument which is required for a reload.
-	;;
-    *)
-	echo "Usage: $0 {start|stop|status|try-restart|restart|force-reload|reload|probe}"
-	exit 1
-	;;
-esac
-rc_exit
-- 
2.5.5
