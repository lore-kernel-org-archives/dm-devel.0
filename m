From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 5/5] dm mpath: Use blk_path_error
Date: Tue,  9 Jan 2018 12:04:18 -0700
Message-ID: <20180109190418.7123-6-keith.busch@intel.com>
References: <20180109190418.7123-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180109190418.7123-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

Uses common code for determining if an error should be retried on
alternate path.

Acked-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/md/dm-mpath.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f7810cc869ac..ef57c6d1c887 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1475,21 +1475,6 @@ static void activate_path_work(struct work_struct *work)
 	activate_or_offline_path(pgpath);
 }
 
-static int noretry_error(blk_status_t error)
-{
-	switch (error) {
-	case BLK_STS_NOTSUPP:
-	case BLK_STS_NOSPC:
-	case BLK_STS_TARGET:
-	case BLK_STS_NEXUS:
-	case BLK_STS_MEDIUM:
-		return 1;
-	}
-
-	/* Anything else could be a path failure, so should be retried */
-	return 0;
-}
-
 static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			    blk_status_t error, union map_info *map_context)
 {
@@ -1508,7 +1493,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	 * request into dm core, which will remake a clone request and
 	 * clone bios for it and resubmit it later.
 	 */
-	if (error && !noretry_error(error)) {
+	if (error && blk_path_error(error)) {
 		struct multipath *m = ti->private;
 
 		r = DM_ENDIO_REQUEUE;
@@ -1544,7 +1529,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
 
-	if (!*error || noretry_error(*error))
+	if (!*error || !blk_path_error(*error))
 		goto done;
 
 	if (pgpath)
-- 
2.13.6
