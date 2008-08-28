From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd multipathd.init.redhat
Date: 28 Aug 2008 19:22:33 -0000
Message-ID: <20080828192233.17351.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2008-08-28 19:22:33

Modified files:
	multipathd     : multipathd.init.redhat 

Log message:
	Fix for bz #456228. Patch applied from bugzilla. The multipath init script now
	refuses to stop multipathd when the root device is a multipath device.  This
	was causing problems with shutdown on iSCSI devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.4.2&r2=1.2.4.3

--- multipath-tools/multipathd/multipathd.init.redhat	2007/06/18 21:12:54	1.2.4.2
+++ multipath-tools/multipathd/multipathd.init.redhat	2008/08/28 19:22:33	1.2.4.3
@@ -4,7 +4,7 @@
 #
 # Starts the multipath daemon
 #
-# chkconfig: - 13 87
+# chkconfig: - 06 87
 # description: Manage device-mapper multipath devices
 # processname: multipathd
 
@@ -13,6 +13,7 @@
 initdir=/etc/rc.d/init.d
 lockdir=/var/lock/subsys
 sysconfig=/etc/sysconfig
+syspath=/sys/block
 
  
 system=redhat
@@ -26,6 +27,35 @@
 
 RETVAL=0
 
+teardown_slaves()
+{
+cd $1; 
+if [ -d "slaves" ]; then
+for slave in slaves/*;
+do
+	if [ "$slave" = "slaves/*" ]; then
+		read dev <  $1/dev
+		tablename=`dmsetup table --target multipath | sed -n "s/\(.*\): .* $dev .*/\1/p"`
+		if ! [ -z $tablename ]; then
+			echo "Root is on a multipathed device, multipathd can not be stopped"
+			exit 1
+		fi
+	else
+		local_slave=`readlink -f $slave`;
+		teardown_slaves $local_slave;
+	fi
+	done
+		
+else
+		read dev <  $1/dev
+		tablename=`dmsetup table --target multipath | sed -n "s/\(.*\): .* $dev .*/\1/p"`
+		if ! [ -z $tablename ]; then
+			echo "Root is on a multipathed device, multipathd can not be stopped"
+			exit 1
+		fi
+fi
+}
+
 #
 # See how we were called.
 #
@@ -40,6 +70,11 @@
 }
 
 stop() {
+        root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
+	dm_num=`dmsetup info -c --noheadings -o minor $root_dev`
+	root_dm_device="dm-$dm_num"
+	[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
+
 	echo -n $"Stopping $prog daemon: "
 	killproc $DAEMON
 	RETVAL=$?
