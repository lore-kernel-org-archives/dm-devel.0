From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 7 Aug 2012 19:37:51 -0000
Message-ID: <20120807193751.21270.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2012-08-07 19:37:51

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bz #843626. Make sure multipathd doesn't remove the
	/var/cache/multipathd directory. Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.42&r2=1.69.2.43

--- multipath-tools/multipathd/main.c	2012/07/11 23:03:34	1.69.2.42
+++ multipath-tools/multipathd/main.c	2012/08/07 19:37:51	1.69.2.43
@@ -1427,6 +1427,7 @@
 		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
 		    strcmp(mnt, "/var") == 0 || strcmp(mnt, "/var/lib") == 0 ||
 		    strcmp(mnt, "/var/lib/multipath") == 0 ||
+		    strcmp(mnt, CALLOUT_DIR) == 0 ||
 		    strncmp(mnt, "/var/run", 8) == 0 || strncmp(mnt, "/lib", 4) == 0 ||
 		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0 ||
 		    strncmp(mnt, "/ram", 4) == 0)
