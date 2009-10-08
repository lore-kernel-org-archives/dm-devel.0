From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 10] LVM: mirrored log remove prevention
	checks
Date: Thu, 8 Oct 2009 16:18:25 -0500
Message-ID: <200910082118.n98LIPqF014214@hydrogen.msp.redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: lvm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: lvm-mirrored-log-remove-prevention-checks.patch

In preparation for redundant (mirrored) mirror logs, remove the
checks that prevent this sort of processing.

RFC: Jonathan Brassow <jbrassow@redhat.com>

Index: LVM2/lib/metadata/mirror.c
===================================================================
--- LVM2.orig/lib/metadata/mirror.c
+++ LVM2/lib/metadata/mirror.c
@@ -1301,11 +1301,6 @@ static struct logical_volume *_set_up_mi
 
 	init_mirror_in_sync(in_sync);
 
-	if (log_count != 1) {
-		log_error("log_count != 1 is not supported.");
-		return NULL;
-	}
-
 	/* Mirror log name is lv_name + suffix, determined as the following:
 	 *   1. suffix is:
 	 *        o "_mlog" for the original mirror LV.
@@ -1368,12 +1363,6 @@ int add_mirror_log(struct cmd_context *c
 	struct lvinfo info;
 	int r = 0;
 
-	/* Unimplemented features */
-	if (log_count > 1) {
-		log_error("log_count > 1 is not supported");
-		return 0;
-	}
-
 	if (dm_list_size(&lv->segments) != 1) {
 		log_error("Multiple-segment mirror is not supported");
 		return 0;

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
