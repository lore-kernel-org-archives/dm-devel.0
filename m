From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 2 Nov 2009 19:11:47 -0000
Message-ID: <20091102191147.15277.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-11-02 19:11:46

Modified files:
	multipathd     : main.c 

Log message:
	Fixed typo in unmounting unnecessary devices from multipathd's private
	namespace. Related to bz #532424. Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.24&r2=1.69.2.25

--- multipath-tools/multipathd/main.c	2009/09/10 16:27:24	1.69.2.24
+++ multipath-tools/multipathd/main.c	2009/11/02 19:11:46	1.69.2.25
@@ -1289,7 +1289,7 @@
 		    strcmp(mnt, "/etc") == 0 || strncmp(mnt, "/proc", 5) == 0 ||
 		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
 		    strcmp(mnt, "/var") == 0 || strncmp(mnt, "/var/lib", 8) == 0 ||
-		    strncmp(mnt, "/var/run", 8) || strncmp(mnt, "/lib", 4) == 0 ||
+		    strncmp(mnt, "/var/run", 8) == 0 || strncmp(mnt, "/lib", 4) == 0 ||
 		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0)
 			continue;
 		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT) {
