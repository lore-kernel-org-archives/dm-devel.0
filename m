From: agk@sourceware.org
Subject: device-mapper/dmeventd libdevmapper-event.c
Date: 15 Jan 2007 19:11:59 -0000
Message-ID: <20070115191159.11619.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 19:11:58

Modified files:
	dmeventd       : libdevmapper-event.c 

Log message:
	use DMEVENTD_PATH

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.13&r2=1.14

--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/15 18:21:01	1.13
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/15 19:11:58	1.14
@@ -341,8 +341,7 @@
 		log_error("Unable to fork.");
 
 	else if (!pid) {
-		/* FIXME configure path (cf. lvm2 modprobe) */
-		execvp("dmeventd", NULL);
+		execvp(DMEVENTD_PATH, NULL);
 		exit(EXIT_FAILURE);
 	} else {
 		if (waitpid(pid, &status, 0) < 0)
