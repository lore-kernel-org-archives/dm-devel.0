From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 2/4] Fix a race between reading a new block and
	having it recycled.
Date: Tue,  2 Aug 2011 15:36:46 +0100
Message-ID: <1312295808-4323-2-git-send-email-ejt@redhat.com>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
	<1312295808-4323-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1312295808-4323-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/persistent-data/dm-block-manager.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index c9fb132..b68be88 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -447,6 +447,7 @@ static int recycle_block(struct dm_block_manager *bm, dm_block_t where,
 	 * Wait for a block to appear on the empty or clean lists.
 	 */
 	spin_lock_irqsave(&bm->lock, flags);
+retry:
 	while (1) {
 		/*
 		 * Once we can lock and do io concurrently then we should
@@ -486,7 +487,11 @@ static int recycle_block(struct dm_block_manager *bm, dm_block_t where,
 		spin_lock_irqsave(&bm->lock, flags);
 		__wait_io(b, &flags);
 
-		/* FIXME: Can b have been recycled between io completion and here? */
+		/*
+		 * Has b been recycled whilst we were unlocked?
+		 */
+		if (b->where != where)
+			goto retry;
 
 		/*
 		 * Did the io succeed?
-- 
1.7.4.1
