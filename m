From: heinzm@redhat.com
Subject: [PATCH 26/26] dm raid: change logical functions to
	actually return bool
Date: Wed,  6 Jul 2016 19:24:57 +0200
Message-ID: <1467825897-26058-27-git-send-email-heinzm@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e4d0bc1..0aaf4ef 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -69,7 +69,7 @@ struct raid_dev {
 #define __CTR_FLAG_RAID10_COPIES	10 /* 2 */ /* Only with raid10 */
 #define __CTR_FLAG_RAID10_FORMAT	11 /* 2 */ /* Only with raid10 */
 /* New for v1.9.0 */
-#define __CTR_FLAG_DELTA_DISKS		12 /* 2 */ /* Only with reshapable raid4/5/6/10! */
+#define __CTR_FLAG_DELTA_DISKS		12 /* 2 */ /* Only with reshapable raid1/4/5/6/10! */
 #define __CTR_FLAG_DATA_OFFSET		13 /* 2 */ /* Only with reshapable raid4/5/6/10! */
 #define __CTR_FLAG_RAID10_USE_NEAR_SETS 14 /* 2 */ /* Only with raid10! */
 
@@ -193,7 +193,7 @@ struct raid_dev {
 #define RT_FLAG_RESHAPE_RS		4
 #define RT_FLAG_KEEP_RS_FROZEN		5
 
-/* Array elements of 64 bit needed for rebuild/write_mostly bits */
+/* Array elements of 64 bit needed for rebuild/failed disk bits */
 #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 - 1)) / sizeof(uint64_t) / 8)
 
 /*
@@ -328,8 +328,8 @@ static const char *dm_raid_arg_name_by_flag(const uint32_t flag)
 }
 
 /*
- * bool helpers to test for various raid levels of a raid set,
- * is. it's level as reported by the superblock rather than
+ * Bool helpers to test for various raid levels of a raid set.
+ * It's level as reported by the superblock rather than
  * the requested raid_type passed to the constructor.
  */
 /* Return true, if raid set in @rs is raid0 */
@@ -363,7 +363,7 @@ static bool rs_is_raid456(struct raid_set *rs)
 }
 
 /* Return true, if raid set in @rs is reshapable */
-static unsigned int __is_raid10_far(int layout);
+static bool __is_raid10_far(int layout);
 static bool rs_is_reshapable(struct raid_set *rs)
 {
 	return rs_is_raid456(rs) ||
@@ -383,7 +383,7 @@ static bool rs_is_reshaping(struct raid_set *rs)
 }
 
 /*
- * bool helpers to test for various raid levels of a raid type
+ * bool helpers to test for various raid levels of a raid type @rt
  */
 
 /* Return true, if raid type in @rt is raid0 */
@@ -437,7 +437,7 @@ static unsigned long __valid_flags(struct raid_set *rs)
 	else if (rt_is_raid6(rs->raid_type))
 		return RAID6_VALID_FLAGS;
 
-	return ~0;
+	return 0;
 }
 
 /*
@@ -474,19 +474,19 @@ static unsigned int __raid10_far_copies(int layout)
 }
 
 /* Return true if md raid10 offset for @layout */
-static unsigned int __is_raid10_offset(int layout)
+static bool __is_raid10_offset(int layout)
 {
-	return layout & RAID10_OFFSET;
+	return !!(layout & RAID10_OFFSET);
 }
 
 /* Return true if md raid10 near for @layout */
-static unsigned int __is_raid10_near(int layout)
+static bool __is_raid10_near(int layout)
 {
 	return !__is_raid10_offset(layout) && __raid10_near_copies(layout) > 1;
 }
 
 /* Return true if md raid10 far for @layout */
-static unsigned int __is_raid10_far(int layout)
+static bool __is_raid10_far(int layout)
 {
 	return !__is_raid10_offset(layout) && __raid10_far_copies(layout) > 1;
 }
@@ -527,8 +527,7 @@ static int raid10_name_to_format(const char *name)
 /* Return md raid10 copies for @layout */
 static unsigned int raid10_md_layout_to_copies(int layout)
 {
-	return __raid10_near_copies(layout) > 1 ?
-		__raid10_near_copies(layout) : __raid10_far_copies(layout);
+	return max(__raid10_near_copies(layout), __raid10_far_copies(layout));
 }
 
 /* Return md raid10 format id for @format string */
@@ -570,7 +569,7 @@ static int raid10_format_to_md_layout(struct raid_set *rs,
 /* END: MD raid10 bit definitions and helpers */
 
 /* Check for any of the raid10 algorithms */
-static int __got_raid10(struct raid_type *rtp, const int layout)
+static bool __got_raid10(struct raid_type *rtp, const int layout)
 {
 	if (rtp->level == 10) {
 		switch (rtp->algorithm) {
@@ -586,7 +585,7 @@ static int __got_raid10(struct raid_type *rtp, const int layout)
 		}
 	}
 
-	return 0;
+	return false;
 }
 
 /* Return raid_type for @name */
-- 
2.5.5
