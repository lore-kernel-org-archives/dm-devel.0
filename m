From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] dm snapshot: fix memory leak
Date: Tue, 13 Oct 2015 13:33:08 +0530
Message-ID: <1444723388-1570-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: dm-devel.ids

If wrong option is given then we are returning but we missed releasing
the workqueue and pstore.
Add an error path and use it to correctly release resources on failure.

Fixes: b0d3cc011e53 ("dm snapshot: add new persistent store option to support overflow")
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/md/dm-snap-persistent.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 229be55..5ff7c23 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -847,6 +847,7 @@ static void persistent_drop_snapshot(struct dm_exception_store *store)
 static int persistent_ctr(struct dm_exception_store *store, char *options)
 {
 	struct pstore *ps;
+	int ret;
 
 	/* allocate the pstore */
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
@@ -868,9 +869,9 @@ static int persistent_ctr(struct dm_exception_store *store, char *options)
 
 	ps->metadata_wq = alloc_workqueue("ksnaphd", WQ_MEM_RECLAIM, 0);
 	if (!ps->metadata_wq) {
-		kfree(ps);
 		DMERR("couldn't start header metadata update thread");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_free_ps;
 	}
 
 	if (options) {
@@ -879,13 +880,20 @@ static int persistent_ctr(struct dm_exception_store *store, char *options)
 			store->userspace_supports_overflow = true;
 		else {
 			DMERR("Unsupported persistent store option: %s", options);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_option;
 		}
 	}
 
 	store->context = ps;
 
 	return 0;
+
+err_option:
+	destroy_workqueue(ps->metadata_wq);
+err_free_ps:
+	kfree(ps);
+	return ret;
 }
 
 static unsigned persistent_status(struct dm_exception_store *store,
-- 
1.9.1
