From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c structs.c
Date: 2 May 2007 00:16:37 -0000
Message-ID: <20070502001637.22340.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-05-02 00:16:36

Modified files:
	libmultipath   : discovery.c structs.c 

Log message:
	Fix for 223762. Multipath no longer silently fails on paths in can't get
	information for.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.2&r2=1.32.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14&r2=1.14.2.1

--- multipath-tools/libmultipath/discovery.c	2007/04/24 18:49:16	1.32.2.2
+++ multipath-tools/libmultipath/discovery.c	2007/05/02 00:16:36	1.32.2.3
@@ -116,8 +116,11 @@
 	if (!filepresent(path)){
 		unsigned int val;
 		int ret;
-		if (sscanf(devname, "gnbd%u", &val) != 1)
-			return 1;
+		if (sscanf(devname, "gnbd%u", &val) != 1){
+			condlog(3, "%s doesn't exit, not adding %s", path,
+				devname);
+			return 0;
+		}
 		ret = device_ok_to_add(devname);
 		if (ret == -1)
 			return 1;
@@ -760,8 +763,7 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO &&
-	    (pp->state == PATH_UP || pp->priority == PRIO_UNDEF))
+	if (mask & DI_PRIO && pp->state == PATH_UP)
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
--- multipath-tools/libmultipath/structs.c	2006/06/06 18:32:43	1.14
+++ multipath-tools/libmultipath/structs.c	2007/05/02 00:16:36	1.14.2.1
@@ -218,8 +218,10 @@
 int
 store_path (vector pathvec, struct path * pp)
 {
-	if (!vector_alloc_slot(pathvec))
+	if (!vector_alloc_slot(pathvec)){
+		condlog(0, "unable to allocate space for path");
 		return 1;
+	}
 
 	vector_set_slot(pathvec, pp);
 
