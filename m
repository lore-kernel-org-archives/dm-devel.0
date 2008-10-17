From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 17 Oct 2008 18:37:54 -0000
Message-ID: <20081017183754.20630.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2008-10-17 18:37:54

Modified files:
	multipathd     : main.c 

Log message:
	Don't check the map flags for an orphaned path.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.4&r2=1.66.2.5

--- multipath-tools/multipathd/main.c	2008/04/14 22:40:09	1.66.2.4
+++ multipath-tools/multipathd/main.c	2008/10/17 18:37:53	1.66.2.5
@@ -863,7 +863,7 @@
 			break;
 		}
 	}
-	if (!found && mpp->flush_on_last_del == FLUSH_ENABLED) {	
+	if (mpp && !found && mpp->flush_on_last_del == FLUSH_ENABLED) {	
 		condlog(1, "%s: Last path deleted, disabling queueing",
 		        mpp->alias);
 		mpp->retry_tick = 0;
