From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 27 Apr 2009 21:19:41 -0000
Message-ID: <20090427211941.7840.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-04-27 21:19:41

Modified files:
	multipathd     : main.c 

Log message:
	Fix bz #496682. Multipathd not unmounting any device mounted anywhere under
	/etc from its private namespace.  It only needs /etc itself, so it should allow
	any device mounted on a subdirectory to be unmounted.  This is not applicable
	upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.19&r2=1.69.2.20

--- multipath-tools/multipathd/main.c	2009/04/21 00:05:23	1.69.2.19
+++ multipath-tools/multipathd/main.c	2009/04/27 21:19:41	1.69.2.20
@@ -1286,9 +1286,11 @@
 		if (strcmp(mnt, "/") == 0 || strcmp(mnt, "/sbin") == 0 ||
 		    strcmp(mnt, "/bin") == 0 || strcmp(mnt, "/tmp") == 0 ||
 		    strcmp(mnt, "/usr") == 0 || strncmp(mnt, "/usr/lib", 8) == 0 ||
-		    strncmp(mnt, "/etc", 4) == 0 || strncmp(mnt, "/proc", 5) == 0 ||
+		    strcmp(mnt, "/etc") == 0 || strncmp(mnt, "/proc", 5) == 0 ||
 		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
-		    strncmp(mnt, "/var", 4) == 0 || strncmp(mnt, "/lib", 4) == 0)
+		    strncmp(mnt, "/var", 4) == 0 || strncmp(mnt, "/lib", 4) == 0 ||
+		    strncmp(mnt, "/lib64", 6) == 0 ||
+		    strncmp(mnt, "/usr/lib64", 10) == 0)
 			continue;
 		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT) {
 			condlog(0, "failed to umount '%s' (%s). skipping", mnt, strerror(errno));
