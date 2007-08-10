From: Jan Blunck <jblunck@suse.de>
Subject: [patch 01/11] dm-snap: Replace special round_down()
Date: Fri, 10 Aug 2007 22:02:05 +0200
Message-ID: <25205.2138712772$1186776751@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-snap-remove-round_down.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch removes the special round_down() to next power of 2 implementation
used only at one place in the snapshot target. It is replaced by an equivalent
1 << fls() which might use an architecture specific implementation.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -333,16 +333,6 @@ static int calc_max_buckets(void)
 }
 
 /*
- * Rounds a number down to a power of 2.
- */
-static uint32_t round_down(uint32_t n)
-{
-	while (n & (n - 1))
-		n &= (n - 1);
-	return n;
-}
-
-/*
  * Allocate room for a suitable hash table.
  */
 static int init_hash_tables(struct dm_snapshot *s)
@@ -361,7 +351,7 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	/* Round it down to a power of 2 */
-	hash_size = round_down(hash_size);
+	hash_size = 1 << fls(hash_size);
 	if (init_exception_table(&s->complete, hash_size))
 		return -ENOMEM;
 

-- 
