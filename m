From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix random block limits io_opt for raid0
Date: Tue, 19 Jul 2016 13:16:03 +0200
Message-ID: <1468926963-2266-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

raid_io_hints() was retrieving the number of data stripes
used for the calculation of io_opt from struct r5conf,
which is not defined for raid0 mappings.

Base the calculation on the in-core raid_set structure instead.

Adjust to use to_bytes() for the sector -> bytes conversion
throughout the module.

- resolves rhbz1356244

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0aaf4ef..b53c097 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -904,7 +904,7 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 	/*
 	 * Convert sectors to bytes.
 	 */
-	rs->md.bitmap_info.chunksize = (region_size << 9);
+	rs->md.bitmap_info.chunksize = to_bytes(region_size);
 
 	return 0;
 }
@@ -3368,11 +3368,10 @@ static int raid_iterate_devices(struct dm_target *ti,
 static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct raid_set *rs = ti->private;
-	unsigned chunk_size = rs->md.chunk_sectors << 9;
-	struct r5conf *conf = rs->md.private;
+	unsigned int chunk_size = to_bytes(rs->md.chunk_sectors);
 
 	blk_limits_io_min(limits, chunk_size);
-	blk_limits_io_opt(limits, chunk_size * (conf->raid_disks - conf->max_degraded));
+	blk_limits_io_opt(limits, chunk_size * mddev_data_stripes(rs));
 }
 
 static void raid_presuspend(struct dm_target *ti)
-- 
2.5.5
