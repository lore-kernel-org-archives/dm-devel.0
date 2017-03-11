From: Colin King <colin.king@canonical.com>
Subject: [PATCH] dm cache: handle kmalloc failure allocating background_tracker struct
Date: Sat, 11 Mar 2017 19:09:45 +0000
Message-ID: <20170311190945.5930-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Colin Ian King <colin.king@canonical.com>

currently there is no kmalloc failure check on the allocation of
the background_tracker struct variable b, and so a null return
will lead to a null pointer deference error. Add null check and move
the failure debug message and NULL return so that the two allocation
errors can share the same error exit path.

Detected by CoverityScan, CID#1416587 ("Dereference null return value")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/dm-cache-background-tracker.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-background-tracker.c b/drivers/md/dm-cache-background-tracker.c
index 9b1afdf..d27edbcc 100644
--- a/drivers/md/dm-cache-background-tracker.c
+++ b/drivers/md/dm-cache-background-tracker.c
@@ -33,6 +33,8 @@ struct background_tracker *btracker_create(unsigned max_work)
 {
 	struct background_tracker *b = kmalloc(sizeof(*b), GFP_KERNEL);
 
+	if (!b)
+		goto err;
 	b->max_work = max_work;
 	atomic_set(&b->pending_promotes, 0);
 	atomic_set(&b->pending_writebacks, 0);
@@ -44,12 +46,15 @@ struct background_tracker *btracker_create(unsigned max_work)
 	b->pending = RB_ROOT;
 	b->work_cache = KMEM_CACHE(bt_work, 0);
 	if (!b->work_cache) {
-		DMERR("couldn't create mempool for background work items");
 		kfree(b);
-		b = NULL;
+		goto err;
 	}
 
 	return b;
+err:
+	DMERR("couldn't create mempool for background work items");
+	return NULL;
+
 }
 EXPORT_SYMBOL_GPL(btracker_create);
 
-- 
2.10.2
