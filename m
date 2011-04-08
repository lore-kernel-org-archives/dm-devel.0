From: bmarzins@sourceware.org
Subject: multipath-tools/kpartx kpartx.c
Date: 8 Apr 2011 05:34:35 -0000
Message-ID: <20110408053435.1818.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-04-08 05:34:34

Modified files:
	kpartx         : kpartx.c 

Log message:
	more work for 578109.  The previous loop deleting fix didn't work if there were
	no partitions on the loop device. Now it handles that case as well.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.4&r2=1.9.2.5

--- multipath-tools/kpartx/kpartx.c	2011/03/07 05:19:37	1.9.2.4
+++ multipath-tools/kpartx/kpartx.c	2011/04/08 05:34:33	1.9.2.5
@@ -182,7 +182,8 @@
 
 int
 main(int argc, char **argv){
-        int fd, i, j, k, n, op, off, arg;
+        int i, j, k, n, op, off, arg;
+	int fd = -1;
 	struct slice all;
 	struct pt *ptp;
 	enum action what = LIST;
@@ -342,8 +343,10 @@
 			printf("%s: %d slices\n", ptp->type, n);
 #endif
 
-		if (n > 0)
+		if (n > 0) {
 			close(fd);
+			fd = -1;
+		}
 		else
 			continue;
 
@@ -371,15 +374,6 @@
 					slices[j].size, device,
 				        slices[j].start);
 			}
-			if (loopcreated && S_ISREG (buf.st_mode)) {
-				if (del_loop(device)) {
-					if (verbose)
-						printf("can't del loop : %s\n",
-						       device);
-					exit(1);
-				}
-				printf("loop deleted : %s\n", device);
-			}
 			break;
 
 		case DELETE:
@@ -457,6 +451,17 @@
 		if (n > 0)
 			break;
 	}
+	if (what == LIST && loopcreated && S_ISREG (buf.st_mode)) {
+		if (fd != -1)
+			close(fd);
+		if (del_loop(device)) {
+			if (verbose)
+				printf("can't del loop : %s\n",
+				       device);
+			exit(1);
+		}
+		printf("loop deleted : %s\n", device);
+	}
 	dm_lib_release();
 	dm_lib_exit();
 
