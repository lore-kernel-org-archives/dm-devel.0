From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.rules
Date: 27 Nov 2006 21:51:26 -0000
Message-ID: <20061127215126.23731.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-11-27 21:51:26

Modified files:
	multipath      : multipath.rules 

Log message:
	Fix for 199924. kpartx uses the p delimiter by default. To change it, you must
	edit /etc/rc.sysinit and /etc/udev/rules.d/40-multipath.rules

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&r1=1.10&r2=1.11

--- multipath-tools/multipath/multipath.rules	2006/10/06 16:38:01	1.10
+++ multipath-tools/multipath/multipath.rules	2006/11/27 21:51:25	1.11
@@ -4,7 +4,7 @@
 KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
 KERNEL!="dm-[0-9]*", GOTO="end_mpath"
 PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
-ACTION=="add", RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a' -j %M -m %m"
+ACTION=="add", RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a -p p' -j %M -m %m"
 PROGRAM=="/sbin/dmsetup ls --target multipath --exec /bin/basename -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", OPTIONS="last_rule"
 PROGRAM!="/bin/bash -c '/sbin/dmsetup info -c --noheadings -j %M -m %m | /bin/grep -q .*:.*:.*:.*:.*:.*:.*:part[0-9]*-mpath-'", GOTO="end_mpath"
 PROGRAM=="/sbin/dmsetup ls --target linear --exec /bin/basename -j %M -m %m", NAME="%k", RESULT=="?*", SYMLINK="mpath/%c", OPTIONS="last_rule"
