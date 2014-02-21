From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-dm-3.14-fixes 4/8] dm thin: error out I/O if
	inappropriate for it to be retried
Date: Thu, 20 Feb 2014 21:56:01 -0500
Message-ID: <1392951365-9829-5-git-send-email-snitzer@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
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

If the pool is in fail mode, error_if_no_space is enabled or the
metadata space is exhausted do _not_ allow IO to be retried.  This
change complements commit 8c0f0e8c9f0 ("dm thin: requeue bios to DM core
if no_free_space and in read-only mode").

Also, update Documentation to include information about when the thin
provisioning target commits metadata and how it deals with running out
of space.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/cache.txt             | 11 +++++------
 Documentation/device-mapper/thin-provisioning.txt | 23 +++++++++++++++++++++++
 drivers/md/dm-thin.c                              | 14 +++++++++++++-
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index e6b72d3..68c0f51 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -124,12 +124,11 @@ the default being 204800 sectors (or 100MB).
 Updating on-disk metadata
 -------------------------
 
-On-disk metadata is committed every time a REQ_SYNC or REQ_FUA bio is
-written.  If no such requests are made then commits will occur every
-second.  This means the cache behaves like a physical disk that has a
-write cache (the same is true of the thin-provisioning target).  If
-power is lost you may lose some recent writes.  The metadata should
-always be consistent in spite of any crash.
+On-disk metadata is committed every time a FLUSH or FUA bio is written.
+If no such requests are made then commits will occur every second.  This
+means the cache behaves like a physical disk that has a volatile write
+cache.  If power is lost you may lose some recent writes.  The metadata
+should always be consistent in spite of any crash.
 
 The 'dirty' state for a cache block changes far too frequently for us
 to keep updating it on the fly.  So we treat it as a hint.  In normal
diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 8a7a3d4..3989dd6 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -116,6 +116,29 @@ Resuming a device with a new table itself triggers an event so the
 userspace daemon can use this to detect a situation where a new table
 already exceeds the threshold.
 
+A low water mark for the metadata device is maintained in the kernel and
+will trigger a dm event if free space on the metadata device drops below
+it.
+
+Updating on-disk metadata
+-------------------------
+
+On-disk metadata is committed every time a FLUSH or FUA bio is written.
+If no such requests are made then commits will occur every second.  This
+means the thin-provisioning target behaves like a physical disk that has
+a volatile write cache.  If power is lost you may lose some recent
+writes.  The metadata should always be consistent in spite of any crash.
+
+If data space is exhausted the pool will either error or queue IO
+according to the configuration (see: error_if_no_space).  When metadata
+space is exhausted the pool will error IO, that requires new pool block
+allocation, until the pool's metadata device is resized.  When either the
+data or metadata space is exhausted the current metadata transaction
+must be aborted.  Given that the pool will cache IO whose completion may
+have already been acknowledged to the upper IO layers (e.g. filesystem)
+it is strongly suggested that those layers perform consistency checks
+before the data or metadata space is resized after having been exhausted.
+
 Thin provisioning
 -----------------
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8e68831..bc52b3b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -989,6 +989,13 @@ static void retry_on_resume(struct bio *bio)
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
+static bool should_error_unserviceable_bio(struct pool *pool)
+{
+	return (unlikely(get_pool_mode(pool) == PM_FAIL) ||
+		pool->pf.error_if_no_space ||
+		dm_pool_is_metadata_out_of_space(pool->pmd));
+}
+
 static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
 {
 	/*
@@ -997,7 +1004,7 @@ static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
 	 */
 	WARN_ON_ONCE(get_pool_mode(pool) != PM_READ_ONLY);
 
-	if (pool->pf.error_if_no_space)
+	if (should_error_unserviceable_bio(pool))
 		bio_io_error(bio);
 	else
 		retry_on_resume(bio);
@@ -1008,6 +1015,11 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 	struct bio *bio;
 	struct bio_list bios;
 
+	if (should_error_unserviceable_bio(pool)) {
+		cell_error(pool, cell);
+		return;
+	}
+
 	bio_list_init(&bios);
 	cell_release(pool, cell, &bios);
 
-- 
1.8.3.1
