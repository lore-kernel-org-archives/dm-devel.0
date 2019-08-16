From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH] dm dust: use dust blksz for badblocklist index
Date: Fri, 16 Aug 2019 10:09:53 -0400
Message-ID: <1565964593-13195-1-git-send-email-bgurney@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Change the "frontend" dust_remove_block, dust_add_block, and
dust_query_block functions to store the "dust block number", instead
of the sector number corresponding to the "dust block number"

For the "backend" functions dust_map_read and dust_map_write,
right-shift by sect_per_block_shift.  This fixes the inability
to emulate failure beyond the first sector of each "dust block",
for devices with a "dust block size" larger than 512 bytes.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 845f376a72d9..8288887b7f94 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -25,6 +25,7 @@ struct dust_device {
 	unsigned long long badblock_count;
 	spinlock_t dust_lock;
 	unsigned int blksz;
+	int sect_per_block_shift;
 	unsigned int sect_per_block;
 	sector_t start;
 	bool fail_read_on_bb:1;
@@ -79,7 +80,7 @@ static int dust_remove_block(struct dust_device *dd, unsigned long long block)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
-	bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
+	bblock = dust_rb_search(&dd->badblocklist, block);
 
 	if (bblock == NULL) {
 		if (!dd->quiet_mode) {
@@ -113,7 +114,7 @@ static int dust_add_block(struct dust_device *dd, unsigned long long block)
 	}
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
-	bblock->bb = block * dd->sect_per_block;
+	bblock->bb = block;
 	if (!dust_rb_insert(&dd->badblocklist, bblock)) {
 		if (!dd->quiet_mode) {
 			DMERR("%s: block %llu already in badblocklist",
@@ -138,7 +139,7 @@ static int dust_query_block(struct dust_device *dd, unsigned long long block)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
-	bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
+	bblock = dust_rb_search(&dd->badblocklist, block);
 	if (bblock != NULL)
 		DMINFO("%s: block %llu found in badblocklist", __func__, block);
 	else
@@ -165,6 +166,7 @@ static int dust_map_read(struct dust_device *dd, sector_t thisblock,
 	int ret = DM_MAPIO_REMAPPED;
 
 	if (fail_read_on_bb) {
+		thisblock >>= dd->sect_per_block_shift;
 		spin_lock_irqsave(&dd->dust_lock, flags);
 		ret = __dust_map_read(dd, thisblock);
 		spin_unlock_irqrestore(&dd->dust_lock, flags);
@@ -195,6 +197,7 @@ static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 	unsigned long flags;
 
 	if (fail_read_on_bb) {
+		thisblock >>= dd->sect_per_block_shift;
 		spin_lock_irqsave(&dd->dust_lock, flags);
 		__dust_map_write(dd, thisblock);
 		spin_unlock_irqrestore(&dd->dust_lock, flags);
@@ -331,6 +334,8 @@ static int dust_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	dd->blksz = blksz;
 	dd->start = tmp;
 
+	dd->sect_per_block_shift = __ffs(sect_per_block);
+
 	/*
 	 * Whether to fail a read on a "bad" block.
 	 * Defaults to false; enabled later by message.
-- 
2.21.0
