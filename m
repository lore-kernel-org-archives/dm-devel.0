From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd multipathd.init.redhat
Date: 31 Aug 2009 21:58:53 -0000
Message-ID: <20090831215853.8873.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-08-31 21:58:52

Modified files:
	multipathd     : multipathd.init.redhat 

Log message:
	Fix for bz#502128.  multipathd.init only checks if the root device is multipathed, if the
	root device is a device-mapper device.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.4.5&r2=1.2.4.6

--- multipath-tools/multipathd/multipathd.init.redhat	2009/05/15 21:01:27	1.2.4.5
+++ multipath-tools/multipathd/multipathd.init.redhat	2009/08/31 21:58:52	1.2.4.6
@@ -72,9 +72,11 @@
 
 stop() {
         root_dev=$(awk '{ if ($1 !~ /^[ \t]*#/ && $2 == "/") { print $1; }}' /etc/mtab)
-	dm_num=`dmsetup info -c --noheadings -o minor $root_dev`
-	root_dm_device="dm-$dm_num"
-	[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
+	dm_num=`dmsetup info -c --noheadings -o minor $root_dev 2> /dev/null`
+	if [ $? -eq 0 ]; then
+		root_dm_device="dm-$dm_num"
+		[ -d $syspath/$root_dm_device ] && teardown_slaves $syspath/$root_dm_device
+	fi
 
 	echo -n $"Stopping $prog daemon: "
 	killproc $DAEMON
