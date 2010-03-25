From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: don't let init script stop multipathd
	for root	devices
Date: Thu, 25 Mar 2010 12:52:06 -0500
Message-ID: <20100325175205.GG23952@ether.msp.redhat.com>
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

This patch modifies the redhat init script, so that it doesn't allow
multipathd to be stopped when the root device is on it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
:100644 100644 ee776f0... e46b1b8... M	multipathd/multipathd.init.redhat
 multipathd/multipathd.init.redhat |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

Index: multipath-tools-100322/multipathd/multipathd.init.redhat
===================================================================
--- multipath-tools-100322.orig/multipathd/multipathd.init.redhat
+++ multipath-tools-100322/multipathd/multipathd.init.redhat
@@ -2,7 +2,7 @@
 #
 # multipathd	Starts the multipath daemon
 #
-# chkconfig: - 13 87
+# chkconfig: - 06 87
 # description: Manages device-mapper multipath devices
 
 ### BEGIN INIT INFO
@@ -17,6 +17,7 @@ prog=`basename $DAEMON`
 initdir=/etc/rc.d/init.d
 lockdir=/var/lock/subsys
 sysconfig=/etc/sysconfig
+syspath=/sys/block
 
  
 . $initdir/functions
@@ -25,6 +26,36 @@ test -r $sysconfig/$prog && . $sysconfig
 
 RETVAL=0
 
+teardown_slaves()
+{
+pushd $1 > /dev/null
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
+popd > /dev/null
+}
+
 #
 # See how we were called.
 #
@@ -39,6 +70,11 @@ start() {
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
