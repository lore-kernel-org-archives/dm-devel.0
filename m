From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/discovery.c libmu ...
Date: 1 Jun 2007 00:26:42 -0000
Message-ID: <20070601002642.15936.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-01 00:26:42

Modified files:
	libmultipath   : discovery.c switchgroup.c 
Added files:
	path_priority/pp_rdac: Makefile pp_rdac.c 

Log message:
	Reverting the earlier RDAC related path priority fixes, and addning the new
	priority callout.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.3&r2=1.32.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/switchgroup.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_rdac/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_rdac/pp_rdac.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1

--- multipath-tools/libmultipath/discovery.c	2007/05/02 00:16:36	1.32.2.3
+++ multipath-tools/libmultipath/discovery.c	2007/06/01 00:26:41	1.32.2.4
@@ -763,7 +763,7 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO && pp->state == PATH_UP)
+	if (mask & DI_PRIO && pp->state != PATH_DOWN)
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
--- multipath-tools/libmultipath/switchgroup.c	2007/04/24 18:49:16	1.5.2.1
+++ multipath-tools/libmultipath/switchgroup.c	2007/06/01 00:26:41	1.5.2.2
@@ -28,7 +28,7 @@
 		priority = 0;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_UP)
+			if (pp->state != PATH_DOWN)
 				priority += pp->priority;
 		}
 		pgp->priority = priority;
