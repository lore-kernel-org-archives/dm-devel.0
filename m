From: bmarzins@sourceware.org
Subject: multipath-tools/multipath kpartx_get_name mpat ...
Date: 25 May 2010 22:51:48 -0000
Message-ID: <20100525225148.27224.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2010-05-25 22:51:43

Modified files:
	multipath      : kpartx_get_name mpath_get_name multipath.dev 

Log message:
	Mark Goodwin's patch to avoid running dm ls --exec <program>, to avoid the
	race between multipath and dmsetup creating the device nodes.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/kpartx_get_name.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/mpath_get_name.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.dev.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.13.2.1&r2=1.13.2.2

--- multipath-tools/multipath/Attic/kpartx_get_name	2006/05/12 22:17:13	1.1
+++ multipath-tools/multipath/Attic/kpartx_get_name	2010/05/25 22:51:42	1.1.2.1
@@ -25,7 +25,8 @@
 	exit 1
 fi
 
-i=`/sbin/dmsetup ls --target linear --exec basename -j $1 -m $2 2> /dev/null`
+dev=`/sbin/dmsetup ls --target linear -j $1 -m $2 | sed -e 's/([ 0-9]*,[ 0-9]*)//g' 2>/dev/null`
+i=`basename $dev 2>/dev/null`
 
 if [ -n "$i" ] ; then
 	echo $i
--- multipath-tools/multipath/Attic/mpath_get_name	2006/05/12 22:17:13	1.1
+++ multipath-tools/multipath/Attic/mpath_get_name	2010/05/25 22:51:42	1.1.2.1
@@ -19,7 +19,8 @@
 	exit 1
 fi
 
-i=`/sbin/dmsetup ls --target multipath --exec basename -j $1 -m $2 2> /dev/null`
+dev=`/sbin/dmsetup ls --target multipath -j $1 -m $2 | sed -e 's/([ 0-9]*,[ 0-9]*)//g' 2>/dev/null`
+i=`basename $dev 2>/dev/null`
 
 if [ -n "$i" ] ; then
 	echo $i
--- multipath-tools/multipath/Attic/multipath.dev	2006/06/28 19:29:10	1.13.2.1
+++ multipath-tools/multipath/Attic/multipath.dev	2010/05/25 22:51:42	1.13.2.2
@@ -29,5 +29,8 @@
 
 if [ "${DEVPATH:7:3}" = "dm-" -a "${ACTION}" = "add" ]; then
 	majmin=`awk -F ':' '{ print "-j",$1,"-m",$2 }' /sys/${DEVPATH}/dev`
-	/sbin/dmsetup ls ${majmin} --target multipath --exec "/sbin/kpartx -a"
+	devnames=`/sbin/dmsetup ls ${majmin} --target multipath | sed -e 's/([ 0-9]*,[ 0-9]*)//g'`
+	for dev in $devnames; do
+		[ -n "$dev" ] && /sbin/kpartx -a /dev/mapper/$dev
+	done
 fi
