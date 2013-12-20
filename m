From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 13/20] dm thin: cleanup and improve no
	space handling
Date: Fri, 20 Dec 2013 18:37:26 -0500
Message-ID: <1387582653-13647-14-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Factor out_of_data_space() out of alloc_data_block().  Eliminate the use
of 'no_free_space' as a latch in alloc_data_block() -- this is no longer
needed now that we switch to read-only mode when we run out of data or
metadata space.  In a later patch, the 'no_free_space' flag will be
eliminated entirely (in favor of checking metadata rather than relying
on a transient flag).

Move no metdata space handling into metdata_operation_failed().  Set
no_free_space when metadata space is exhausted too.  This is useful,
because it offers consistency, for the following patch that will requeue
data IOs if no_free_space.

Also, rename no_space() to retry_bios_on_resume().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 61 +++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3a80c00..f19b9e3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -198,6 +198,7 @@ struct pool {
 };
 
 static enum pool_mode get_pool_mode(struct pool *pool);
+static void out_of_data_space(struct pool *pool);
 static void metadata_operation_failed(struct pool *pool, const char *op, int r);
 
 /*
@@ -926,16 +927,8 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 {
 	int r;
 	dm_block_t free_blocks;
-	unsigned long flags;
 	struct pool *pool = tc->pool;
 
-	/*
-	 * Once no_free_space is set we must not allow allocation to succeed.
-	 * Otherwise it is difficult to explain, debug, test and support.
-	 */
-	if (pool->no_free_space)
-		return -ENOSPC;
-
 	if (get_pool_mode(pool) != PM_WRITE)
 		return -EINVAL;
 
@@ -962,31 +955,14 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 			return r;
 		}
 
-		/*
-		 * If we still have no space we set a flag to avoid
-		 * doing all this checking and return -ENOSPC.  This
-		 * flag serves as a latch that disallows allocations from
-		 * this pool until the admin takes action (e.g. resize or
-		 * table reload).
-		 */
 		if (!free_blocks) {
-			DMWARN("%s: no free data space available.",
-			       dm_device_name(pool->pool_md));
-			spin_lock_irqsave(&pool->lock, flags);
-			pool->no_free_space = true;
-			spin_unlock_irqrestore(&pool->lock, flags);
+			out_of_data_space(pool);
 			return -ENOSPC;
 		}
 	}
 
 	r = dm_pool_alloc_data_block(pool->pmd, result);
 	if (r) {
-		if (r == -ENOSPC &&
-		    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
-		    !free_blocks)
-			DMWARN("%s: no free metadata space available.",
-			       dm_device_name(pool->pool_md));
-
 		metadata_operation_failed(pool, "dm_pool_alloc_data_block", r);
 		return r;
 	}
@@ -1010,7 +986,7 @@ static void retry_on_resume(struct bio *bio)
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
-static void no_space(struct pool *pool, struct dm_bio_prison_cell *cell)
+static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *cell)
 {
 	struct bio *bio;
 	struct bio_list bios;
@@ -1123,7 +1099,7 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 		break;
 
 	case -ENOSPC:
-		no_space(pool, cell);
+		retry_bios_on_resume(pool, cell);
 		break;
 
 	default:
@@ -1201,7 +1177,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 		break;
 
 	case -ENOSPC:
-		no_space(pool, cell);
+		retry_bios_on_resume(pool, cell);
 		break;
 
 	default:
@@ -1450,15 +1426,42 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 	}
 }
 
+static void set_no_free_space(struct pool *pool)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->no_free_space = true;
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
 /*
  * Rather than calling set_pool_mode directly, use these which describe the
  * reason for mode degradation.
  */
+static void out_of_data_space(struct pool *pool)
+{
+	DMERR_LIMIT("%s: no free data space available.",
+		    dm_device_name(pool->pool_md));
+	set_no_free_space(pool);
+	set_pool_mode(pool, PM_READ_ONLY);
+}
+
 static void metadata_operation_failed(struct pool *pool, const char *op, int r)
 {
+	dm_block_t free_blocks;
+
 	DMERR_LIMIT("%s: metadata operation '%s' failed: error = %d",
 		    dm_device_name(pool->pool_md), op, r);
 
+	if (r == -ENOSPC &&
+	    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
+	    !free_blocks) {
+		DMERR_LIMIT("%s: no free metadata space available.",
+			    dm_device_name(pool->pool_md));
+		set_no_free_space(pool);
+	}
+
 	set_pool_mode(pool, PM_READ_ONLY);
 }
 
-- 
1.8.1.4
