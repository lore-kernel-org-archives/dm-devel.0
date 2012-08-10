From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 10 Aug 2012 18:49:10 -0000
Message-ID: <20120810184910.6771.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2012-08-10 18:49:10

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bz #833193. Make sure multipathd removes directories named /dev<foo>
	Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.43&r2=1.69.2.44

--- multipath-tools/multipathd/main.c	2012/08/07 19:37:51	1.69.2.43
+++ multipath-tools/multipathd/main.c	2012/08/10 18:49:09	1.69.2.44
@@ -1424,10 +1424,10 @@
 		    strcmp(mnt, "/bin") == 0 || strcmp(mnt, "/tmp") == 0 ||
 		    strcmp(mnt, "/usr") == 0 || strncmp(mnt, "/usr/lib", 8) == 0 ||
 		    strcmp(mnt, "/etc") == 0 || strncmp(mnt, "/proc", 5) == 0 ||
-		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
+		    strcmp(mnt, "/dev") == 0 || strncmp(mnt, "/sys", 4) == 0 ||
 		    strcmp(mnt, "/var") == 0 || strcmp(mnt, "/var/lib") == 0 ||
 		    strcmp(mnt, "/var/lib/multipath") == 0 ||
-		    strcmp(mnt, CALLOUT_DIR) == 0 ||
+		    strncmp(mnt, "/dev/", 5) == 0 || strcmp(mnt, CALLOUT_DIR) == 0 ||
 		    strncmp(mnt, "/var/run", 8) == 0 || strncmp(mnt, "/lib", 4) == 0 ||
 		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0 ||
 		    strncmp(mnt, "/ram", 4) == 0)
