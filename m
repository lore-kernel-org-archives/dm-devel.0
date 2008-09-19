From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd cli_handlers.c
Date: 19 Sep 2008 04:00:22 -0000
Message-ID: <20080919040022.3121.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-09-19 04:00:22

Modified files:
	multipathd     : cli_handlers.c 

Log message:
	Update to the 455692 fix. With the most recent RHEL 5.3 kernels, it's not
	necesary to remove and re-add the devices, so some of the warts just magically
	disappeared.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.3&r2=1.6.2.4

--- multipath-tools/multipathd/cli_handlers.c	2008/09/19 03:27:08	1.6.2.3
+++ multipath-tools/multipathd/cli_handlers.c	2008/09/19 04:00:21	1.6.2.4
@@ -427,7 +427,7 @@
 	return 0;
 }
 
-
+/*
 int
 reload_paths(struct multipath *mpp, struct vectors * vecs)
 {
@@ -477,7 +477,7 @@
 	vector_free(path_names);
 	return err;
 }
-
+*/
 int resize_map(struct multipath *mpp, unsigned long long size, struct vectors * vecs)
 {
 	mpp->size = size;
@@ -528,6 +528,7 @@
 	}
 	condlog(3, "%s old size is %llu, new size is %llu", mapname, mpp->size,
 		size);
+/*
 	if (size > mpp->size) {
 		if (reload_paths(mpp, vecs) != 0) {
 			condlog(0, "%s: failed to reload paths", mapname);
@@ -544,6 +545,9 @@
 			return 1;
 		}
 	}
+*/
+	if (resize_map(mpp, size, vecs) != 0)
+		return 1;
 	dm_lib_release();
 	setup_multipath(vecs, mpp);
 	sync_map_state(mpp);
