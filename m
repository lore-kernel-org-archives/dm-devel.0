From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH 2/2] dm dust: change ret to r in dust_map_read
	and dust_map
Date: Fri,  4 Oct 2019 11:42:09 -0400
Message-ID: <1570203729-22034-3-git-send-email-bgurney@redhat.com>
References: <1570203729-22034-1-git-send-email-bgurney@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1570203729-22034-1-git-send-email-bgurney@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

In the dust_map_read() and dust_map() functions, change the
return code variable "ret" to "r", to match the convention of the
other device-mapper targets.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 29626ff8b8e8..9a926a799fb4 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -163,16 +163,16 @@ static int dust_map_read(struct dust_device *dd, sector_t thisblock,
 			 bool fail_read_on_bb)
 {
 	unsigned long flags;
-	int ret = DM_MAPIO_REMAPPED;
+	int r = DM_MAPIO_REMAPPED;
 
 	if (fail_read_on_bb) {
 		thisblock >>= dd->sect_per_block_shift;
 		spin_lock_irqsave(&dd->dust_lock, flags);
-		ret = __dust_map_read(dd, thisblock);
+		r = __dust_map_read(dd, thisblock);
 		spin_unlock_irqrestore(&dd->dust_lock, flags);
 	}
 
-	return ret;
+	return r;
 }
 
 static void __dust_map_write(struct dust_device *dd, sector_t thisblock)
@@ -209,17 +209,17 @@ static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 static int dust_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dust_device *dd = ti->private;
-	int ret;
+	int r;
 
 	bio_set_dev(bio, dd->dev->bdev);
 	bio->bi_iter.bi_sector = dd->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
 
 	if (bio_data_dir(bio) == READ)
-		ret = dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
+		r = dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
 	else
-		ret = dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
+		r = dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
 
-	return ret;
+	return r;
 }
 
 static bool __dust_clear_badblocks(struct rb_root *tree,
-- 
2.21.0
