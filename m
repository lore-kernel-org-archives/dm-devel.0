From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm thin: return ENOSPC instead of EIO when
 error_if_no_space enabled
Date: Thu, 22 May 2014 14:32:51 -0400
Message-ID: <20140522183250.GA7799@redhat.com>
References: <1400782364-6537-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1400782364-6537-1-git-send-email-snitzer@redhat.com>
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
Cc: sandeen@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Update the DM thin provisioning target's allocation failure error to be
consistent with commit a9d6ceb8 ("[SCSI] return ENOSPC on thin
provisioning failure").

The DM thin target now returns -ENOSPC rather than -EIO when
block allocation fails due to the pool being out of data space (and
the 'error_if_no_space' thin-pool feature is enabled).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bio-prison.c |    4 ++--
 drivers/md/dm-bio-prison.h |    2 +-
 drivers/md/dm-thin.c       |   35 +++++++++++++++++++++++------------
 3 files changed, 26 insertions(+), 15 deletions(-)

v2: update other should_error_unserviceable_bio() callers and dm_cell_error()

diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
index 85f0b70..7143438 100644
--- a/drivers/md/dm-bio-prison.c
+++ b/drivers/md/dm-bio-prison.c
@@ -238,7 +238,7 @@ void dm_cell_release_no_holder(struct dm_bio_prison *prison,
 EXPORT_SYMBOL_GPL(dm_cell_release_no_holder);
 
 void dm_cell_error(struct dm_bio_prison *prison,
-		   struct dm_bio_prison_cell *cell)
+		   struct dm_bio_prison_cell *cell, int error)
 {
 	struct bio_list bios;
 	struct bio *bio;
@@ -251,7 +251,7 @@ void dm_cell_error(struct dm_bio_prison *prison,
 	spin_unlock_irqrestore(&prison->lock, flags);
 
 	while ((bio = bio_list_pop(&bios)))
-		bio_io_error(bio);
+		bio_endio(bio, error);
 }
 EXPORT_SYMBOL_GPL(dm_cell_error);
 
diff --git a/drivers/md/dm-bio-prison.h b/drivers/md/dm-bio-prison.h
index 3f83319..6805a14 100644
--- a/drivers/md/dm-bio-prison.h
+++ b/drivers/md/dm-bio-prison.h
@@ -85,7 +85,7 @@ void dm_cell_release_no_holder(struct dm_bio_prison *prison,
 			       struct dm_bio_prison_cell *cell,
 			       struct bio_list *inmates);
 void dm_cell_error(struct dm_bio_prison *prison,
-		   struct dm_bio_prison_cell *cell);
+		   struct dm_bio_prison_cell *cell, int error);
 
 /*----------------------------------------------------------------*/
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c31f5f1..87c59e5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -310,10 +310,16 @@ static void cell_defer_no_holder_no_free(struct thin_c *tc,
 	wake_worker(pool);
 }
 
+static void __cell_error(struct pool *pool,
+			 struct dm_bio_prison_cell *cell, int error)
+{
+	dm_cell_error(pool->prison, cell, error);
+}
+
 static void cell_error(struct pool *pool,
 		       struct dm_bio_prison_cell *cell)
 {
-	dm_cell_error(pool->prison, cell);
+	__cell_error(pool, cell, -EIO);
 	dm_bio_prison_free_cell(pool->prison, cell);
 }
 
@@ -1021,7 +1027,7 @@ static void retry_on_resume(struct bio *bio)
 	spin_unlock_irqrestore(&tc->lock, flags);
 }
 
-static bool should_error_unserviceable_bio(struct pool *pool)
+static int should_error_unserviceable_bio(struct pool *pool)
 {
 	enum pool_mode m = get_pool_mode(pool);
 
@@ -1029,25 +1035,27 @@ static bool should_error_unserviceable_bio(struct pool *pool)
 	case PM_WRITE:
 		/* Shouldn't get here */
 		DMERR_LIMIT("bio unserviceable, yet pool is in PM_WRITE mode");
-		return true;
+		return -EIO;
 
 	case PM_OUT_OF_DATA_SPACE:
-		return pool->pf.error_if_no_space;
+		return pool->pf.error_if_no_space ? -ENOSPC : 0;
 
 	case PM_READ_ONLY:
 	case PM_FAIL:
-		return true;
+		return -EIO;
 	default:
 		/* Shouldn't get here */
 		DMERR_LIMIT("bio unserviceable, yet pool has an unknown mode");
-		return true;
+		return -EIO;
 	}
 }
 
 static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
 {
-	if (should_error_unserviceable_bio(pool))
-		bio_io_error(bio);
+	int error = should_error_unserviceable_bio(pool);
+
+	if (error)
+		bio_endio(bio, error);
 	else
 		retry_on_resume(bio);
 }
@@ -1056,18 +1064,21 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 {
 	struct bio *bio;
 	struct bio_list bios;
+	int error;
 
-	if (should_error_unserviceable_bio(pool)) {
-		cell_error(pool, cell);
+	error = should_error_unserviceable_bio(pool);
+	if (error) {
+		__cell_error(pool, cell, error);
 		return;
 	}
 
 	bio_list_init(&bios);
 	cell_release(pool, cell, &bios);
 
-	if (should_error_unserviceable_bio(pool))
+	error = should_error_unserviceable_bio(pool);
+	if (error)
 		while ((bio = bio_list_pop(&bios)))
-			bio_io_error(bio);
+			bio_endio(bio, error);
 	else
 		while ((bio = bio_list_pop(&bios)))
 			retry_on_resume(bio);
-- 
1.7.4.4
