From: bmarzins@sourceware.org
Subject: multipath-tools kpartx/devmapper.c kpartx/devm ...
Date: 10 Oct 2011 03:11:34 -0000
Message-ID: <20111010031134.17101.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-10-10 03:11:32

Modified files:
	kpartx         : devmapper.c devmapper.h kpartx.c 
	libmultipath   : devmapper.c 
	multipath      : multipath.rules 

Log message:
	Fix for BZ #655203. When multipath tries to delete a multipath device, but
	fails, it does not restore the already deleted kpartx path devices.  Multipath
	now suspends and resumes the device if it fail to delete it, in order to send
	a change event, which will cause udev to rerun kpartx.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.8.2.2&r2=1.8.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.5&r2=1.9.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.9&r2=1.22.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.rules.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.3&r2=1.11.2.4

--- multipath-tools/kpartx/devmapper.c	2009/10/01 22:53:11	1.8.2.2
+++ multipath-tools/kpartx/devmapper.c	2011/10/10 03:11:32	1.8.2.3
@@ -52,7 +52,7 @@
 }
 
 extern int
-dm_simplecmd (int task, const char *name) {
+dm_simplecmd (int task, const char *name, int no_flush) {
 	int r = 0;
 	struct dm_task *dmt;
 
@@ -63,6 +63,9 @@
 		goto out;
 
 	dm_task_no_open_count(dmt);
+	dm_task_skip_lockfs(dmt);       /* for DM_DEVICE_RESUME */
+	if (no_flush)
+		dm_task_no_flush(dmt);       /* for DM_DEVICE_SUSPEND/RESUME */
 
 	r = dm_task_run(dmt);
 
--- multipath-tools/kpartx/devmapper.h	2009/10/01 22:53:11	1.5.2.2
+++ multipath-tools/kpartx/devmapper.h	2011/10/10 03:11:32	1.5.2.3
@@ -5,7 +5,7 @@
 #define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
 
 int dm_prereq (char *, int, int, int);
-int dm_simplecmd (int, const char *);
+int dm_simplecmd (int, const char *, int);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
 	       const char *, int, mode_t, uid_t, gid_t);
 int dm_map_present (char *);
--- multipath-tools/kpartx/kpartx.c	2011/04/08 05:34:33	1.9.2.5
+++ multipath-tools/kpartx/kpartx.c	2011/10/10 03:11:32	1.9.2.6
@@ -388,7 +388,8 @@
 				if (!slices[j].size || !dm_map_present(partname))
 					continue;
 
-				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname))
+				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
+						  0))
 					continue;
 
 				if (verbose)
@@ -434,7 +435,7 @@
 
 				if (op == DM_DEVICE_RELOAD)
 					dm_simplecmd(DM_DEVICE_RESUME,
-							partname);
+							partname, 1);
 
 				if (verbose)
 					printf("add map %s : 0 %" PRIu64
--- multipath-tools/libmultipath/devmapper.c	2010/04/16 22:08:02	1.22.2.9
+++ multipath-tools/libmultipath/devmapper.c	2011/10/10 03:11:32	1.22.2.10
@@ -503,6 +503,8 @@
 
 	if (dm_get_opencount(mapname)) {
 		condlog(2, "%s: map in use", mapname);
+		r = dm_simplecmd(DM_DEVICE_SUSPEND, mapname, 1);
+		r = dm_simplecmd(DM_DEVICE_RESUME, mapname, 1);
 		return 1;
 	}	
 
@@ -512,6 +514,8 @@
 		condlog(4, "multipath map %s removed", mapname);
 		return 0;
 	}
+	dm_simplecmd(DM_DEVICE_SUSPEND, mapname, 1);
+	dm_simplecmd(DM_DEVICE_RESUME, mapname, 1);
 	return 1;
 }
 
--- multipath-tools/multipath/multipath.rules	2010/08/23 22:06:58	1.11.2.3
+++ multipath-tools/multipath/multipath.rules	2011/10/10 03:11:32	1.11.2.4
@@ -1,12 +1,16 @@
 # multipath wants the devmaps presented as meaninglful device names
 # so name them after their devmap name
 SUBSYSTEM!="block", GOTO="end_mpath"
-# KERNEL!="dm-[0-9]*", ACTION=="add", PROGRAM=="/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath'", RUN+="/sbin/multipath -v0 %M:%m"
 KERNEL!="dm-[0-9]*", GOTO="end_mpath"
 PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
 PROGRAM!="/sbin/dmsetup info -c --noheadings -j %M -m %m", GOTO="end_mpath"
 RESULT!="*:*:*:*:*:*:*:mpath-*", GOTO="kpartx_check"
-PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m", RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c'"
+PROGRAM!="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m", GOTO="end_mpath"
+RESULT!="?*", GOTO="end_mpath"
+NAME="%k", SYMLINK="mpath/%c"
+ACTION!="change", GOTO="skip_kpartx"
+RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c'"
+LABEL="skip_kpartx"
 OPTIONS="last_rule"
 LABEL="kpartx_check"
 RESULT!="*:*:*:*:*:*:*:part*-mpath-*", GOTO="end_mpath"
