From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: update redhat multipathd init script
Date: Mon, 17 May 2010 14:02:47 -0500
Message-ID: <20100517190247.GN3295@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds the requested force-stop and force-restart to the init
script. It also keeps the init script for printing annoying error messages,
while checking the root device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.init.redhat |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

Index: multipath-tools-100510/multipathd/multipathd.init.redhat
===================================================================
--- multipath-tools-100510.orig/multipathd/multipathd.init.redhat
+++ multipath-tools-100510/multipathd/multipathd.init.redhat
@@ -7,6 +7,10 @@
 
 ### BEGIN INIT INFO
 # Provides: multipathd
+# Required-Start:
+# Required-Stop:
+# Default-Start:
+# Default-Stop:
 # Short-Description: Control multipathd
 # Description: This service monitors and manages
 #              device-mapper multipath devices
@@ -69,12 +73,7 @@ start() {
 	echo
 }
 
-stop() {
-        root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
-	dm_num=`dmsetup info -c --noheadings -o minor $root_dev`
-	root_dm_device="dm-$dm_num"
-	[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
-
+force_stop() {
 	echo -n $"Stopping $prog daemon: "
 	killproc $DAEMON
 	RETVAL=$?
@@ -82,10 +81,26 @@ stop() {
 	echo
 }
 
+stop() {
+        root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
+	dm_num=`dmsetup info -c --noheadings -o minor $root_dev 2> /dev/null`
+	if [ $? -eq 0 ]; then
+		root_dm_device="dm-$dm_num"
+		[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
+	fi
+
+	force_stop
+}
+
 restart() {
 	stop
 	start
-}	
+}
+
+force_restart() {
+	force_stop
+	start
+}
 
 reload() {
 	echo -n "Reloading $prog: "
@@ -102,12 +117,18 @@ start)
 stop)
 	stop
 	;;
+force-stop)
+	force_stop
+	;;
 force-reload|reload)
 	reload
 	;;
 restart)
 	restart
 	;;
+force-restart)
+	force_restart
+	;;
 condrestart|try-restart)
 	if [ -f $lockdir/$prog ]; then
 	    restart
@@ -118,7 +139,7 @@ status)
 	RETVAL=$?
 	;;
 *)
-	echo $"Usage: $0 {start|stop|status|restart|condrestart|reload}"
+	echo $"Usage: $0 {start|stop|force-stop|status|restart|force-restart|condrestart|reload}"
 	RETVAL=2
 esac
 
