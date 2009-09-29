From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.rules
Date: 29 Sep 2009 17:52:28 -0000
Message-ID: <20090929175228.32761.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-09-29 17:52:28

Modified files:
	multipath      : multipath.rules 

Log message:
	Fix for bz #518575.  running "dmsetup ls --exec" creates devnodes for dm devices
	that don't have them, if you run this in a udev rule, it can race with removing
	a dm-device, and end up creating a device node for it, even though the device is
	removed. This was causing devices created with specific UIDs, GIDs, and modes to
	occassionally get created with the default UID, GID, mode.  This removes all
	'dmsetup ls --exec' calls from the multipath udev rules.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.1&r2=1.11.2.2

--- multipath-tools/multipath/multipath.rules	2009/06/23 18:49:12	1.11.2.1
+++ multipath-tools/multipath/multipath.rules	2009/09/29 17:52:27	1.11.2.2
@@ -4,8 +4,12 @@
 # KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
 KERNEL!="dm-[0-9]*", GOTO="end_mpath"
 PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
-ACTION=="add", RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a -p p' -j %M -m %m"
-PROGRAM=="/sbin/dmsetup ls --target multipath --exec /bin/basename -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", OPTIONS="last_rule"
-PROGRAM!="/bin/bash -c '/sbin/dmsetup info -c --noheadings -j %M -m %m | /bin/grep -q .*:.*:.*:.*:.*:.*:.*:part[0-9]*-mpath-'", GOTO="end_mpath"
-PROGRAM=="/sbin/dmsetup ls --target linear --exec /bin/basename -j %M -m %m", NAME="%k", RESULT=="?*", SYMLINK="mpath/%c", OPTIONS="last_rule"
+PROGRAM!="/sbin/dmsetup info -c --noheadings -j %M -m %m", GOTO="end_mpath"
+RESULT!="*:*:*:*:*:*:*:mpath-*", GOTO="kpartx_check"
+PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", RUN+="/sbin/kpartx -a -p p /dev/mapper/%c"
+OPTIONS="last_rule"
+LABEL="kpartx_check"
+RESULT!="*:*:*:*:*:*:*:part*-mpath-*", GOTO="end_mpath"
+PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c"
+OPTIONS="last_rule"
 LABEL="end_mpath"
