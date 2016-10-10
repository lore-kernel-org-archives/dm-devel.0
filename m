From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] dm: free io_barrier after blk_cleanup_queue call
Date: Mon, 10 Oct 2016 05:35:19 -0700
Message-ID: <1476102919-25112-1-git-send-email-tahsin@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
List-Id: dm-devel.ids

dm_old_request_fn() has paths that access md->io_barrier. The party
destroying io_barrier should ensure that no future execution
of dm_old_request_fn() is possible. Move destruction to below
blk_cleanup_queue() to ensure this.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index be35258324c1..ec513ee864f2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1423,8 +1423,6 @@ static void cleanup_mapped_device(struct mapped_device *md)
 	if (md->bs)
 		bioset_free(md->bs);
 
-	cleanup_srcu_struct(&md->io_barrier);
-
 	if (md->disk) {
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
@@ -1436,6 +1434,8 @@ static void cleanup_mapped_device(struct mapped_device *md)
 	if (md->queue)
 		blk_cleanup_queue(md->queue);
 
+	cleanup_srcu_struct(&md->io_barrier);
+
 	if (md->bdev) {
 		bdput(md->bdev);
 		md->bdev = NULL;
-- 
2.8.0.rc3.226.g39d4020

