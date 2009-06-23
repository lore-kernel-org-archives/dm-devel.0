From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.rules
Date: 23 Jun 2009 18:49:13 -0000
Message-ID: <20090623184913.906.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-06-23 18:49:12

Modified files:
	multipath      : multipath.rules 

Log message:
	Remove udev rule to make multipath run on device addition.
	Fix for bz #506715. Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11&r2=1.11.2.1

--- multipath-tools/multipath/multipath.rules	2006/11/27 21:51:25	1.11
+++ multipath-tools/multipath/multipath.rules	2009/06/23 18:49:12	1.11.2.1
@@ -1,7 +1,7 @@
 # multipath wants the devmaps presented as meaninglful device names
 # so name them after their devmap name
 SUBSYSTEM!="block", GOTO="end_mpath"
-KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
+# KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
 KERNEL!="dm-[0-9]*", GOTO="end_mpath"
 PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
 ACTION=="add", RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a -p p' -j %M -m %m"
