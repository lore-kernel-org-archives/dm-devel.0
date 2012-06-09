From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 3/9] dm: use memweight()
Date: Sat,  9 Jun 2012 09:50:32 +0900
Message-ID: <1339203038-13069-3-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dm-devel@redhat.com, Akinobu Mita <akinobu.mita@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
v3: no changes from v2
v2: change patch title s/dm-log:/dm:/

 drivers/md/dm-log.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 65ebaeb..627d191 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -571,16 +571,6 @@ static void disk_dtr(struct dm_dirty_log *log)
 	destroy_log_context(lc);
 }
 
-static int count_bits32(uint32_t *addr, unsigned size)
-{
-	int count = 0, i;
-
-	for (i = 0; i < size; i++) {
-		count += hweight32(*(addr+i));
-	}
-	return count;
-}
-
 static void fail_log_device(struct log_c *lc)
 {
 	if (lc->log_dev_failed)
@@ -629,7 +619,8 @@ static int disk_resume(struct dm_dirty_log *log)
 
 	/* copy clean across to sync */
 	memcpy(lc->sync_bits, lc->clean_bits, size);
-	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
+	lc->sync_count = memweight(lc->clean_bits,
+				lc->bitset_uint32_count * sizeof(uint32_t));
 	lc->sync_search = 0;
 
 	/* set the correct number of regions in the header */
-- 
1.7.7.6
