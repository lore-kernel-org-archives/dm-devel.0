From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 05/25] dm raid1: fix leakage
Date: Fri, 12 Oct 2007 18:07:08 +0100
Message-ID: <20071012170708.GP24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932931AbXJLRIR@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: dm-devel.ids

From: Dmitry Monakhov <dmonakhov@openvz.org>

Add missing 'dm_io_client_destroy' to alloc_context error path.
Reorganize mirror constructor error path in order to prevent
workqueue leakage.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-raid1.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 13:15:18.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 13:15:32.000000000 +0100
@@ -974,6 +974,7 @@ static struct mirror_set *alloc_context(
 
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
 		ti->error = "Error creating dirty region hash";
+		dm_io_client_destroy(ms->io_client);
 		kfree(ms);
 		return NULL;
 	}
@@ -1163,16 +1164,14 @@ static int mirror_ctr(struct dm_target *
 	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
-		free_context(ms, ti, m);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto err_free_context;
 	}
 	INIT_WORK(&ms->kmirrord_work, do_mirror);
 
 	r = parse_features(ms, argc, argv, &args_used);
-	if (r) {
-		free_context(ms, ti, ms->nr_mirrors);
-		return r;
-	}
+	if (r)
+		goto err_destroy_wq;
 
 	argv += args_used;
 	argc -= args_used;
@@ -1188,19 +1187,22 @@ static int mirror_ctr(struct dm_target *
 
 	if (argc) {
 		ti->error = "Too many mirror arguments";
-		free_context(ms, ti, ms->nr_mirrors);
-		return -EINVAL;
+		r = -EINVAL;
+		goto err_destroy_wq;
 	}
 
 	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
-	if (r) {
-		destroy_workqueue(ms->kmirrord_wq);
-		free_context(ms, ti, ms->nr_mirrors);
-		return r;
-	}
+	if (r)
+		goto err_destroy_wq;
 
 	wake(ms);
 	return 0;
+
+err_destroy_wq:
+	destroy_workqueue(ms->kmirrord_wq);
+err_free_context:
+	free_context(ms, ti, ms->nr_mirrors);
+	return r;
 }
 
 static void mirror_dtr(struct dm_target *ti)
