From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: do not expose non-zero discard limits
 if discards are disabled
Date: Thu, 19 Sep 2013 18:49:11 -0400
Message-ID: <20130919224911.GA5477@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Fix issue where the block layer would stack the discard limits of the
pool's data device even if the "ignore_discard" pool feature was
specified.

The pool and thin device(s) still had discards disabled because the
QUEUE_FLAG_DISCARD request_queue flag wasn't set.  But to avoid user
confusion when "ignore_discard" is used: both the pool device and the
thin device(s) have zeroes for all discard limits.

Also, always set discard_zeroes_data_unsupported in targets because they
should never advertise the 'discard_zeroes_data' capability (even if the
pool's data device supports it).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ed06342..2c0cf51 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2095,6 +2095,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 * them down to the data device.  The thin device's discard
 	 * processing will cause mappings to be removed from the btree.
 	 */
+	ti->discard_zeroes_data_unsupported = true;
 	if (pf.discard_enabled && pf.discard_passdown) {
 		ti->num_discard_bios = 1;
 
@@ -2104,7 +2105,6 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		 * thin devices' discard limits consistent).
 		 */
 		ti->discards_supported = true;
-		ti->discard_zeroes_data_unsupported = true;
 	}
 	ti->private = pt;
 
@@ -2689,8 +2689,16 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * They get transferred to the live pool in bind_control_target()
 	 * called from pool_preresume().
 	 */
-	if (!pt->adjusted_pf.discard_enabled)
+	if (!pt->adjusted_pf.discard_enabled) {
+		/*
+		 * Must explicitly disallow stacking discard limits otherwise the
+		 * block layer will stack them if pool's data device has support.
+		 * QUEUE_FLAG_DISCARD wouldn't be set but there is no way for the
+		 * user to see that, so make sure to set all discard limits to 0.
+		 */
+		limits->discard_granularity = 0;
 		return;
+	}
 
 	disable_passdown_if_not_supported(pt);
 
@@ -2826,10 +2834,10 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->per_bio_data_size = sizeof(struct dm_thin_endio_hook);
 
 	/* In case the pool supports discards, pass them on. */
+	ti->discard_zeroes_data_unsupported = true;
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = true;
 		ti->num_discard_bios = 1;
-		ti->discard_zeroes_data_unsupported = true;
 		/* Discard bios must be split on a block boundary */
 		ti->split_discard_bios = true;
 	}
