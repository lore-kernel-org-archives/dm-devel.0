From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] dm-thin: fix discard_granularity
Date: Mon, 16 Jul 2012 14:35:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207161435230.3859@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434300.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434550.3859@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1207161434550.3859@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

dm-thin: fix discard_granularity

The kernel expects that limits->discard_granularity is a power of two.
Set this limit only if we use a power of two block size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.5-rc6-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.5-rc6-fast.orig/drivers/md/dm-thin.c	2012-07-16 20:07:49.000000000 +0200
+++ linux-3.5-rc6-fast/drivers/md/dm-thin.c	2012-07-16 20:08:01.000000000 +0200
@@ -2502,7 +2502,8 @@ static void set_discard_limits(struct po
 	 * bios cover a block partially.  A discard that spans a block boundary
 	 * is not sent to this target.
 	 */
-	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
+	if (pool->sectors_per_block_shift >= 0)
+		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
 }
 
