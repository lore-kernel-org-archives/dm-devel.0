From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm thin: log errors using DMERR_LIMIT
	instead of DMERR
Date: Fri, 30 Nov 2012 09:45:27 -0500
Message-ID: <1354286727-31933-3-git-send-email-snitzer@redhat.com>
References: <1354286727-31933-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1354286727-31933-1-git-send-email-snitzer@redhat.com>
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

Throttle all errors logged from the IO path.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 058acf3..ceb17be 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -561,7 +561,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 */
 	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
 	if (r) {
-		DMERR("dm_thin_insert_block() failed");
+		DMERR_LIMIT("dm_thin_insert_block() failed");
 		dm_cell_error(m->cell);
 		goto out;
 	}
@@ -614,7 +614,7 @@ static void process_prepared_discard(struct dm_thin_new_mapping *m)
 
 	r = dm_thin_remove_block(tc->td, m->virt_block);
 	if (r)
-		DMERR("dm_thin_remove_block() failed");
+		DMERR_LIMIT("dm_thin_remove_block() failed");
 
 	process_prepared_discard_passdown(m);
 }
@@ -727,7 +727,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 				   0, copy_complete, m);
 		if (r < 0) {
 			mempool_free(m, pool->mapping_pool);
-			DMERR("dm_kcopyd_copy() failed");
+			DMERR_LIMIT("dm_kcopyd_copy() failed");
 			dm_cell_error(cell);
 		}
 	}
@@ -792,7 +792,7 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 		r = dm_kcopyd_zero(pool->copier, 1, &to, 0, copy_complete, m);
 		if (r < 0) {
 			mempool_free(m, pool->mapping_pool);
-			DMERR("dm_kcopyd_zero() failed");
+			DMERR_LIMIT("dm_kcopyd_zero() failed");
 			dm_cell_error(cell);
 		}
 	}
@@ -804,7 +804,7 @@ static int commit(struct pool *pool)
 
 	r = dm_pool_commit_metadata(pool->pmd);
 	if (r)
-		DMERR("commit failed, error = %d", r);
+		DMERR_LIMIT("commit failed, error = %d", r);
 
 	return r;
 }
@@ -985,7 +985,8 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		break;
 
 	default:
-		DMERR("discard: find block unexpectedly returned %d", r);
+		DMERR_LIMIT("%s: dm_thin_find_block() failed, error = %d",
+			    __func__, r);
 		dm_cell_release_singleton(cell, bio);
 		bio_io_error(bio);
 		break;
@@ -1012,7 +1013,8 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 		break;
 
 	default:
-		DMERR("%s: alloc_data_block() failed, error = %d", __func__, r);
+		DMERR_LIMIT("%s: alloc_data_block() failed, error = %d",
+			    __func__, r);
 		dm_cell_error(cell);
 		break;
 	}
@@ -1085,7 +1087,8 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 		break;
 
 	default:
-		DMERR("%s: alloc_data_block() failed, error = %d", __func__, r);
+		DMERR_LIMIT("%s: alloc_data_block() failed, error = %d",
+			    __func__, r);
 		set_pool_mode(tc->pool, PM_READ_ONLY);
 		dm_cell_error(cell);
 		break;
@@ -1137,7 +1140,8 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 		break;
 
 	default:
-		DMERR("dm_thin_find_block() failed, error = %d", r);
+		DMERR_LIMIT("%s: dm_thin_find_block() failed, error = %d",
+			    __func__, r);
 		dm_cell_release_singleton(cell, bio);
 		bio_io_error(bio);
 		break;
@@ -1176,7 +1180,8 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
 		break;
 
 	default:
-		DMERR("dm_thin_find_block() failed, error = %d", r);
+		DMERR_LIMIT("%s: dm_thin_find_block() failed, error = %d",
+			    __func__, r);
 		bio_io_error(bio);
 		break;
 	}
-- 
1.7.4.4
