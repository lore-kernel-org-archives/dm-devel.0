From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 19 Jan 2007 18:08:37 -0000
Message-ID: <20070119180837.25196.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-19 18:08:37

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	fix exit status; always print message on child failure

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.41&r2=1.42

--- device-mapper/dmeventd/dmeventd.c	2007/01/19 17:22:17	1.41
+++ device-mapper/dmeventd/dmeventd.c	2007/01/19 18:08:36	1.42
@@ -1558,22 +1558,19 @@
 		/* Problem with child.  Determine what it is by exit code */
 		switch (WEXITSTATUS(child_status)) {
 		case EXIT_LOCKFILE_INUSE:
+			fprintf(stderr, "Another dmeventd daemon is already running\n");
 			break;
 		case EXIT_DESC_CLOSE_FAILURE:
-			break;
 		case EXIT_DESC_OPEN_FAILURE:
-			break;
 		case EXIT_OPEN_PID_FAILURE:
-			break;
 		case EXIT_FIFO_FAILURE:
-			break;
 		case EXIT_CHDIR_FAILURE:
-			break;
 		default:
+			fprintf(stderr, "Child exited with code %d\n", WEXITSTATUS(child_status));
 			break;
 		}
 
-		exit(child_status);
+		exit(WEXITSTATUS(child_status));
 	}
 
 	if (chdir("/"))
