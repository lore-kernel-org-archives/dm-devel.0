From: bmarzins@sourceware.org
Subject: multipath-tools/multipath main.c
Date: 17 Dec 2007 23:15:29 -0000
Message-ID: <20071217231529.28826.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-12-17 23:15:24

Modified files:
	multipath      : main.c 

Log message:
	Applied patch from bz #425995.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.41.2.5&r2=1.41.2.6

--- multipath-tools/multipath/main.c	2007/07/24 20:35:24	1.41.2.5
+++ multipath-tools/multipath/main.c	2007/12/17 23:15:22	1.41.2.6
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.41.2.5 2007/07/24 20:35:24 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.41.2.6 2007/12/17 23:15:22 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -496,7 +496,7 @@
 
 	if (!find_mp_by_wwid(curmp, mpp->wwid)) {
 		condlog(2, "remove: %s (wwid changed)", cmpp->alias);
-		dm_flush_map(mpp->alias, NULL);
+		dm_flush_map(mpp->alias, DEFAULT_TARGET);
 		strncat(cmpp->wwid, mpp->wwid, WWID_SIZE);
 		drop_multipath(curmp, cmpp->wwid, KEEP_PATHS);
 		mpp->action = ACT_CREATE;
@@ -681,7 +681,7 @@
 			condlog(3, "%s: failed to load map "
 				   "(a path might be in use)",
 				   mpp->alias);
-			dm_flush_map(mpp->alias, NULL);
+			dm_flush_map(mpp->alias, DEFAULT_TARGET);
 		}
 
 		lock_multipath(mpp, 0);
