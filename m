From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH resend 2/6] dm: use use proper little-endian bitops
Date: Sun, 26 Jun 2011 14:57:52 +0900
Message-ID: <1309067876-3537-3-git-send-email-akinobu.mita@gmail.com>
References: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

This also removes unnecessary casts.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 948e3f4..2ef7e6e 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -251,20 +251,20 @@ struct log_c {
  */
 static inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return test_bit_le(bit, (unsigned long *) bs) ? 1 : 0;
+	return test_bit_le(bit, bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	__test_and_set_bit_le(bit, (unsigned long *) bs);
+	__set_bit_le(bit, bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	__test_and_clear_bit_le(bit, (unsigned long *) bs);
+	__clear_bit_le(bit, bs);
 	l->touched_dirtied = 1;
 }
 
@@ -739,8 +739,7 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 		return 0;
 
 	do {
-		*region = find_next_zero_bit_le(
-					     (unsigned long *) lc->sync_bits,
+		*region = find_next_zero_bit_le(lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
 		lc->sync_search = *region + 1;
-- 
1.7.4.4
