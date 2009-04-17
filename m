From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/4] multipath-tools: update
	multipathd.init.redhat
Date: Fri, 17 Apr 2009 18:07:59 -0400
Message-ID: <1240006080-27892-4-git-send-email-snitzer@redhat.com>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Various small improvements to Red Hat's multipathd initscript.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 multipathd/multipathd.init.redhat |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/multipathd/multipathd.init.redhat b/multipathd/multipathd.init.redhat
index 4664212..ee776f0 100644
--- a/multipathd/multipathd.init.redhat
+++ b/multipathd/multipathd.init.redhat
@@ -1,13 +1,16 @@
 #!/bin/bash
-
-#
-#	/etc/rc.d/init.d/multipathd
 #
-# Starts the multipath daemon
+# multipathd	Starts the multipath daemon
 #
 # chkconfig: - 13 87
-# description: Manage device-mapper multipath devices
-# processname: multipathd
+# description: Manages device-mapper multipath devices
+
+### BEGIN INIT INFO
+# Provides: multipathd
+# Short-Description: Control multipathd
+# Description: This service monitors and manages
+#              device-mapper multipath devices
+### END INIT INFO
 
 DAEMON=/sbin/multipathd
 prog=`basename $DAEMON`
@@ -16,14 +19,8 @@ lockdir=/var/lock/subsys
 sysconfig=/etc/sysconfig
 
  
-system=redhat
- 
-if [ $system = redhat ]; then
-	# Source function library.
-	. $initdir/functions
-fi
+. $initdir/functions
  
-test -x $DAEMON || exit 0
 test -r $sysconfig/$prog && . $sysconfig/$prog
 
 RETVAL=0
@@ -33,6 +30,7 @@ RETVAL=0
 #
 
 start() {
+	test -x $DAEMON || exit 5
 	echo -n $"Starting $prog daemon: "
 	daemon $DAEMON
 	RETVAL=$?
@@ -68,13 +66,13 @@ start)
 stop)
 	stop
 	;;
-reload)
+force-reload|reload)
 	reload
 	;;
 restart)
 	restart
 	;;
-condrestart)
+condrestart|try-restart)
 	if [ -f $lockdir/$prog ]; then
 	    restart
 	fi
@@ -85,7 +83,7 @@ status)
 	;;
 *)
 	echo $"Usage: $0 {start|stop|status|restart|condrestart|reload}"
-	RETVAL=1
+	RETVAL=2
 esac
 
 exit $RETVAL
-- 
1.6.0.6
