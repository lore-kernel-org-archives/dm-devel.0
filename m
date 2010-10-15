From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 19/22] dm: use little endian bit operations
Date: Fri, 15 Oct 2010 18:46:18 +0900
Message-ID: <1287135981-17604-20-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, Akinobu Mita <akinobu.mita@gmail.com>
List-Id: dm-devel.ids

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 5a08be0..9a61fbc 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -251,20 +251,20 @@ struct log_c {
  */
 static inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return ext2_test_bit(bit, (unsigned long *) bs) ? 1 : 0;
+	return test_le_bit(bit, (unsigned long *) bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	ext2_set_bit(bit, (unsigned long *) bs);
+	__test_and_set_le_bit(bit, (unsigned long *) bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	ext2_clear_bit(bit, (unsigned long *) bs);
+	__test_and_clear_le_bit(bit, (unsigned long *) bs);
 	l->touched_dirtied = 1;
 }
 
@@ -740,7 +740,7 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 		return 0;
 
 	do {
-		*region = ext2_find_next_zero_bit(
+		*region = find_next_zero_le_bit(
 					     (unsigned long *) lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
-- 
1.7.1.231.gd0b16
