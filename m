From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath devmapper.c
Date: 31 Jul 2007 22:19:56 -0000
Message-ID: <20070731221956.2267.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-07-31 22:19:56

Modified files:
	libmultipath   : devmapper.c 

Log message:
	Just added some condlog messages to check for dm problems.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.18&r2=1.18.2.1

--- multipath-tools/libmultipath/devmapper.c	2006/03/28 05:45:23	1.18
+++ multipath-tools/libmultipath/devmapper.c	2007/07/31 22:19:56	1.18.2.1
@@ -670,11 +670,15 @@
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		condlog(0, "can't get dm device list");
 		goto out;
+	}
 
-	if (!(names = dm_task_get_names(dmt)))
+	if (!(names = dm_task_get_names(dmt))){ 
+		condlog(0, "can't get dm device names\n");
 		goto out;
+	}
 
 	if (!names->dev) {
 		r = 0; /* this is perfectly valid */
@@ -689,8 +693,10 @@
 
 		mpp = alloc_multipath();
 
-		if (!mpp)
+		if (!mpp) {
+			condlog(0, "can't allocate multipath device\n");
 			goto out;
+		}
 
 		mpp->alias = STRDUP(names->name);
 
@@ -698,17 +704,21 @@
 			goto out1;
 
 		if (info > 0) {
-			if (dm_get_map(names->name, &mpp->size, mpp->params))
+			if (dm_get_map(names->name, &mpp->size, mpp->params)) {
+				condlog(0, "can't get multipath parameters\n");
 				goto out1;
-
-			if (dm_get_status(names->name, mpp->status))
+			}
+			if (dm_get_status(names->name, mpp->status)) {
+				condlog(0, "can't get multipath status\n");
 				goto out1;
-
+			}
 			dm_get_uuid(names->name, mpp->wwid);
 		}
 
-		if (!vector_alloc_slot(mp))
+		if (!vector_alloc_slot(mp)){
+			condlog(0, "can't allocate space for multipath device\n");
 			goto out1;
+		}
 
 		vector_set_slot(mp, mpp);
 		mpp = NULL;
