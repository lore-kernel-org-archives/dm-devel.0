From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.rules
Date: 6 Oct 2006 02:44:12 -0000
Message-ID: <20061006024412.30559.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-10-06 02:44:12

Modified files:
	multipath      : multipath.rules 

Log message:
	Partial fix for bz 207772. udev will now not ignore multipath and kpartx
	devices, like it ignores other dm devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&r1=1.8&r2=1.9

--- multipath-tools/multipath/multipath.rules	2006/06/27 18:19:49	1.8
+++ multipath-tools/multipath/multipath.rules	2006/10/06 02:44:12	1.9
@@ -4,7 +4,7 @@
 KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
 KERNEL!="dm-[0-9]*", GOTO="end_mpath"
 ACTION=="add", RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a' -j %M -m %m"
-PROGRAM=="/sbin/dmsetup ls --target multipath --exec /bin/basename -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c"
+PROGRAM=="/sbin/dmsetup ls --target multipath --exec /bin/basename -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", OPTIONS="last_rule"
 PROGRAM!="/bin/bash -c '/sbin/dmsetup info -c --noheadings -j %M -m %m | /bin/grep -q .*:.*:.*:.*:.*:.*:.*:part[0-9]*-mpath-'", GOTO="end_mpath"
-PROGRAM=="/sbin/dmsetup ls --target linear --exec /bin/basename -j %M -m %m", NAME="%k", RESULT=="?*", SYMLINK="mpath/%c"
+PROGRAM=="/sbin/dmsetup ls --target linear --exec /bin/basename -j %M -m %m", NAME="%k", RESULT=="?*", SYMLINK="mpath/%c", OPTIONS="last_rule"
 LABEL="end_mpath"
