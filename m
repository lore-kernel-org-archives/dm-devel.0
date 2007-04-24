From: mornfall@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 24 Apr 2007 13:29:03 -0000
Message-ID: <20070424132903.2471.qmail@sourceware.org>
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
Changes by:	mornfall@sourceware.org	2007-04-24 14:29:02

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	Fix the regression introduced by dmeventd leak fixes.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.48&r2=1.49

--- device-mapper/dmeventd/dmeventd.c	2007/04/23 15:06:03	1.48
+++ device-mapper/dmeventd/dmeventd.c	2007/04/24 13:29:02	1.49
@@ -623,6 +623,8 @@
 	} else if (thread->events & DM_EVENT_TIMEOUT && errno == EINTR) {
 		thread->current_events |= DM_EVENT_TIMEOUT;
 		ret = DM_WAIT_INTR;
+	} else if (thread->status == DM_THREAD_SHUTDOWN && errno == EINTR) {
+		ret = DM_WAIT_FATAL;
 	} else {
 		syslog(LOG_NOTICE, "dm_task_run failed, errno = %d, %s",
 		       errno, strerror(errno));
