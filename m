From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PARCH] dm-bufio: avoid division
Date: Sun, 30 Apr 2017 17:32:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1704301731240.25063@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Division is slow, we can change it to shift because we have precalculated the
log2 of block size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -1599,7 +1599,7 @@ static bool __try_evict_buffer(struct dm
 static unsigned get_retain_buffers(struct dm_bufio_client *c)
 {
         unsigned retain_bytes = ACCESS_ONCE(dm_bufio_retain_bytes);
-        return retain_bytes / c->block_size;
+        return retain_bytes >> (c->sectors_per_block_bits + SECTOR_SHIFT);
 }
 
 static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
