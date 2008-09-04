From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 4 Sep 2008 23:31:39 -0000
Message-ID: <20080904233139.816.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-09-04 23:31:39

Modified files:
	multipathd     : main.c 

Log message:
	Typo in my fix for 238421

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.10&r2=1.69.2.11

--- multipath-tools/multipathd/main.c	2008/09/04 20:09:48	1.69.2.10
+++ multipath-tools/multipathd/main.c	2008/09/04 23:31:39	1.69.2.11
@@ -516,7 +516,7 @@
 					condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
 					mpp->retry_tick = 0;
 					mpp->no_path_retry = NO_PATH_RETRY_FAIL;
-					mpp->flush_on_last_del == FLUSH_IN_PROGRESS;
+					mpp->flush_on_last_del = FLUSH_IN_PROGRESS;
 					dm_queue_if_no_path(mpp->alias, 0);
 				}
 				if (flush_map(mpp, vecs))
@@ -575,7 +575,7 @@
 				condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
 				mpp->retry_tick = 0;
 				mpp->no_path_retry = NO_PATH_RETRY_FAIL;
-				mpp->flush_on_last_del == FLUSH_IN_PROGRESS;
+				mpp->flush_on_last_del = FLUSH_IN_PROGRESS;
 				dm_queue_if_no_path(mpp->alias, 0);
 			}
 			if (flush_map(mpp, vecs))
