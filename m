From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH v4 1/4] dm dust: report some message results back
	to user directly
Date: Fri, 19 Jun 2020 17:10:39 -0400
Message-ID: <1592601039-3868-1-git-send-email-bgurney@redhat.com>
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
Cc: yangerkun <yangerkun@huawei.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

From: yangerkun <yangerkun@huawei.com>

From: yangerkun <yangerkun@huawei.com>

Some type of message(queryblock/countbadblocks/removebadblock) may better
report results to user directly. Do it with DMEMIT.

[Bryan: maintain __func__ output in DMEMIT messages]

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index ff03b90072c5..f1f2dd6a4e84 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -138,20 +138,22 @@ static int dust_add_block(struct dust_device *dd, unsigned long long block,
 	return 0;
 }
 
-static int dust_query_block(struct dust_device *dd, unsigned long long block)
+static int dust_query_block(struct dust_device *dd, unsigned long long block, char *result,
+			    unsigned int maxlen, unsigned int *sz_ptr)
 {
 	struct badblock *bblock;
 	unsigned long flags;
+	unsigned int sz = *sz_ptr;
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
 	bblock = dust_rb_search(&dd->badblocklist, block);
 	if (bblock != NULL)
-		DMINFO("%s: block %llu found in badblocklist", __func__, block);
+		DMEMIT("%s: block %llu found in badblocklist", __func__, block);
 	else
-		DMINFO("%s: block %llu not found in badblocklist", __func__, block);
+		DMEMIT("%s: block %llu not found in badblocklist", __func__, block);
 	spin_unlock_irqrestore(&dd->dust_lock, flags);
 
-	return 0;
+	return 1;
 }
 
 static int __dust_map_read(struct dust_device *dd, sector_t thisblock)
@@ -259,11 +261,13 @@ static bool __dust_clear_badblocks(struct rb_root *tree,
 	return true;
 }
 
-static int dust_clear_badblocks(struct dust_device *dd)
+static int dust_clear_badblocks(struct dust_device *dd, char *result, unsigned int maxlen,
+				unsigned int *sz_ptr)
 {
 	unsigned long flags;
 	struct rb_root badblocklist;
 	unsigned long long badblock_count;
+	unsigned int sz = *sz_ptr;
 
 	spin_lock_irqsave(&dd->dust_lock, flags);
 	badblocklist = dd->badblocklist;
@@ -273,11 +277,11 @@ static int dust_clear_badblocks(struct dust_device *dd)
 	spin_unlock_irqrestore(&dd->dust_lock, flags);
 
 	if (!__dust_clear_badblocks(&badblocklist, badblock_count))
-		DMINFO("%s: no badblocks found", __func__);
+		DMEMIT("%s: no badblocks found", __func__);
 	else
-		DMINFO("%s: badblocks cleared", __func__);
+		DMEMIT("%s: badblocks cleared", __func__);
 
-	return 0;
+	return 1;
 }
 
 /*
@@ -383,7 +387,7 @@ static void dust_dtr(struct dm_target *ti)
 }
 
 static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
-			char *result_buf, unsigned int maxlen)
+			char *result, unsigned int maxlen)
 {
 	struct dust_device *dd = ti->private;
 	sector_t size = i_size_read(dd->dev->bdev->bd_inode) >> SECTOR_SHIFT;
@@ -393,6 +397,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 	unsigned char wr_fail_cnt;
 	unsigned int tmp_ui;
 	unsigned long flags;
+	unsigned int sz = 0;
 	char dummy;
 
 	if (argc == 1) {
@@ -410,12 +415,12 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			r = 0;
 		} else if (!strcasecmp(argv[0], "countbadblocks")) {
 			spin_lock_irqsave(&dd->dust_lock, flags);
-			DMINFO("countbadblocks: %llu badblock(s) found",
+			DMEMIT("countbadblocks: %llu badblock(s) found",
 			       dd->badblock_count);
 			spin_unlock_irqrestore(&dd->dust_lock, flags);
-			r = 0;
+			r = 1;
 		} else if (!strcasecmp(argv[0], "clearbadblocks")) {
-			r = dust_clear_badblocks(dd);
+			r = dust_clear_badblocks(dd, result, maxlen, &sz);
 		} else if (!strcasecmp(argv[0], "quiet")) {
 			if (!dd->quiet_mode)
 				dd->quiet_mode = true;
@@ -441,7 +446,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 		else if (!strcasecmp(argv[0], "removebadblock"))
 			r = dust_remove_block(dd, block);
 		else if (!strcasecmp(argv[0], "queryblock"))
-			r = dust_query_block(dd, block);
+			r = dust_query_block(dd, block, result, maxlen, &sz);
 		else
 			invalid_msg = true;
 
-- 
2.25.4
