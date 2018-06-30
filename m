From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 1/5] dm: Avoid namespace collision with bitmap API
Date: Sat, 30 Jun 2018 23:17:46 +0300
Message-ID: <20180630201750.2588-2-andriy.shevchenko@linux.intel.com>
References: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: dm-devel.ids

bitmap API (include/linux/bitmap.h) has 'bitmap' prefix for its methods.

On the other hand DM bitmap API is special case.
Adding 'dm' prefix to it to avoid potential name space collision.

No functional changes intended.

Suggested-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../md/persistent-data/dm-space-map-common.c  | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 829b4ce057d8..0a3b8ae4a29c 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -69,9 +69,9 @@ static struct dm_block_validator index_validator = {
  */
 #define BITMAP_CSUM_XOR 240779
 
-static void bitmap_prepare_for_write(struct dm_block_validator *v,
-				     struct dm_block *b,
-				     size_t block_size)
+static void dm_bitmap_prepare_for_write(struct dm_block_validator *v,
+					struct dm_block *b,
+					size_t block_size)
 {
 	struct disk_bitmap_header *disk_header = dm_block_data(b);
 
@@ -81,9 +81,9 @@ static void bitmap_prepare_for_write(struct dm_block_validator *v,
 						       BITMAP_CSUM_XOR));
 }
 
-static int bitmap_check(struct dm_block_validator *v,
-			struct dm_block *b,
-			size_t block_size)
+static int dm_bitmap_check(struct dm_block_validator *v,
+			   struct dm_block *b,
+			   size_t block_size)
 {
 	struct disk_bitmap_header *disk_header = dm_block_data(b);
 	__le32 csum_disk;
@@ -108,8 +108,8 @@ static int bitmap_check(struct dm_block_validator *v,
 
 static struct dm_block_validator dm_sm_bitmap_validator = {
 	.name = "sm_bitmap",
-	.prepare_for_write = bitmap_prepare_for_write,
-	.check = bitmap_check
+	.prepare_for_write = dm_bitmap_prepare_for_write,
+	.check = dm_bitmap_check,
 };
 
 /*----------------------------------------------------------------*/
@@ -124,7 +124,7 @@ static void *dm_bitmap_data(struct dm_block *b)
 
 #define WORD_MASK_HIGH 0xAAAAAAAAAAAAAAAAULL
 
-static unsigned bitmap_word_used(void *addr, unsigned b)
+static unsigned dm_bitmap_word_used(void *addr, unsigned b)
 {
 	__le64 *words_le = addr;
 	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
@@ -170,7 +170,7 @@ static int sm_find_free(void *addr, unsigned begin, unsigned end,
 {
 	while (begin < end) {
 		if (!(begin & (ENTRIES_PER_WORD - 1)) &&
-		    bitmap_word_used(addr, begin)) {
+		    dm_bitmap_word_used(addr, begin)) {
 			begin += ENTRIES_PER_WORD;
 			continue;
 		}
-- 
2.18.0
