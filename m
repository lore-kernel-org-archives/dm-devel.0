From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] use i_size_read() instead of i_size
Date: Mon, 18 May 2009 11:35:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0905181134570.22422@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
	<4A093417.6050007@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A093417.6050007@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Use i_size_read() instead of reading i_size.

If someone changes the size of the device simultaneously, i_size_read
is guaranteed to return a valid value (either the old one or the new one).

i_size can return some intermediate invalid value (on 32-bit computers
with 64-bit i_size, the reads to both halves of i_size can be interleaved
with updates to i_size, resulting in garbage being returned).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.h |    2 +-
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-table.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc5-fast/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.30-rc5-fast.orig/drivers/md/dm-exception-store.h	2009-05-18 17:29:01.000000000 +0200
+++ linux-2.6.30-rc5-fast/drivers/md/dm-exception-store.h	2009-05-18 17:29:24.000000000 +0200
@@ -156,7 +156,7 @@ static inline void dm_consecutive_chunk_
  */
 static inline sector_t get_dev_size(struct block_device *bdev)
 {
-	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
 }
 
 static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
Index: linux-2.6.30-rc5-fast/drivers/md/dm-log.c
===================================================================
--- linux-2.6.30-rc5-fast.orig/drivers/md/dm-log.c	2009-05-18 17:29:32.000000000 +0200
+++ linux-2.6.30-rc5-fast/drivers/md/dm-log.c	2009-05-18 17:29:42.000000000 +0200
@@ -431,7 +431,7 @@ static int create_log_context(struct dm_
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size, ti->limits.hardsect_size);
 
-		if (buf_size > dev->bdev->bd_inode->i_size) {
+		if (buf_size > i_size_read(dev->bdev->bd_inode)) {
 			DMWARN("log device %s too small: need %llu bytes",
 				dev->name, (unsigned long long)buf_size);
 			kfree(lc);
Index: linux-2.6.30-rc5-fast/drivers/md/dm-table.c
===================================================================
--- linux-2.6.30-rc5-fast.orig/drivers/md/dm-table.c	2009-05-18 17:29:46.000000000 +0200
+++ linux-2.6.30-rc5-fast/drivers/md/dm-table.c	2009-05-18 17:29:57.000000000 +0200
@@ -387,7 +387,7 @@ static void close_dev(struct dm_dev_inte
 static int device_area_is_valid(struct dm_target *ti, struct block_device *bdev,
 			     sector_t start, sector_t len)
 {
-	sector_t dev_size = bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
 	unsigned short hardsect_size_sectors = ti->limits.hardsect_size >>
 					       SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
