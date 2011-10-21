From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 2/2] [thin] in thin_iterate_devices(),
	get the pool dev size a non-blocking way.
Date: Fri, 21 Oct 2011 11:19:35 +0100
Message-ID: <1319192375-5048-2-git-send-email-ejt@redhat.com>
References: <20111021092800.GB4393@ubuntu>
	<1319192375-5048-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1319192375-5048-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

---
 drivers/md/dm-thin.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index cd48cd8..1976a30 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2359,10 +2359,14 @@ static int thin_iterate_devices(struct dm_target *ti,
 	dm_block_t blocks;
 	struct thin_c *tc = ti->private;
 
-	r = dm_pool_get_data_dev_size(tc->pool->pmd, &blocks);
-	if (r)
-		return r;
+	/*
+	 * We can't call dm_pool_get_data_dev_size() since that blocks.  So
+	 * we follow a more convoluted path through to the pool's target.
+	 */
+	if (!tc->pool->ti)
+		return 0;	/* nothing is bound */
 
+	blocks = tc->pool->ti->len >> tc->pool->block_shift;
 	if (blocks)
 		return fn(ti, tc->pool_dev, 0, tc->pool->sectors_per_block * blocks, data);
 
-- 
1.7.5.4
