From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd multipathd.init.redhat
Date: 23 Jul 2007 22:15:11 -0000
Message-ID: <20070723221511.15628.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-07-23 22:15:11

Modified files:
	multipathd     : multipathd.init.redhat 

Log message:
	Fix for bz #242724. init script now meets guidelines, and cannot exit early
	on status cmd.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2.2.1&r2=1.2.2.2

--- multipath-tools/multipathd/multipathd.init.redhat	2007/04/30 18:07:26	1.2.2.1
+++ multipath-tools/multipathd/multipathd.init.redhat	2007/07/23 22:15:11	1.2.2.2
@@ -22,7 +22,6 @@
 	. $initdir/functions
 fi
  
-test -x $DAEMON || exit 0
 test -r $sysconfig/$prog && . $sysconfig/$prog
 
 RETVAL=0
@@ -32,6 +31,7 @@
 #
 
 start() {
+	test -x $DAEMON || exit 5
 	echo -n $"Starting $prog daemon: "
 	daemon $DAEMON
 	RETVAL=$?
@@ -84,7 +84,7 @@
 	;;
 *)
 	echo $"Usage: $0 {start|stop|status|restart|condrestart|reload}"
-	RETVAL=1
+	RETVAL=3
 esac
 
 exit $RETVAL
