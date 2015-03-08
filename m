From: David Rientjes <rientjes@google.com>
Subject: [patch] dm log userspace: use mempool_create_kmalloc_pool()
Date: Sat, 7 Mar 2015 16:43:55 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1503071642540.2772@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Mempools created for kmalloc caches should use
mempool_create_kmalloc_pool().

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/md/dm-log-userspace-base.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -74,18 +74,6 @@ struct log_c {
 	uint32_t integrated_flush;
 };
 
-static mempool_t *flush_entry_pool;
-
-static void *flush_entry_alloc(gfp_t gfp_mask, void *pool_data)
-{
-	return kmalloc(sizeof(struct flush_entry), gfp_mask);
-}
-
-static void flush_entry_free(void *element, void *pool_data)
-{
-	kfree(element);
-}
-
 static int userspace_do_request(struct log_c *lc, const char *uuid,
 				int request_type, char *data, size_t data_size,
 				char *rdata, size_t *rdata_size)
@@ -537,6 +525,8 @@ static int flush_by_group(struct log_c *lc, struct list_head *flush_list,
 	return r;
 }
 
+static mempool_t *flush_entry_pool;
+
 /*
  * userspace_flush
  *
@@ -886,9 +876,8 @@ static int __init userspace_dirty_log_init(void)
 {
 	int r = 0;
 
-	flush_entry_pool = mempool_create(100, flush_entry_alloc,
-					  flush_entry_free, NULL);
-
+	flush_entry_pool = mempool_create_kmalloc_pool(100,
+						sizeof(struct flush_entry));
 	if (!flush_entry_pool) {
 		DMWARN("Unable to create flush_entry_pool:  No memory.");
 		return -ENOMEM;
