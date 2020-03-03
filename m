From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] dm: fix congested_fn for request-based device
Date: Tue, 3 Mar 2020 16:45:01 +0800
Message-ID: <20200303084501.8912-1-houtao1@huawei.com>
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
To: dm-devel@redhat.com
Cc: tj@kernel.org, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

We neither assign congested_fn for requested-based blk-mq device
nor implement it correctly. So fix both.

Fixes: 4aa9c692e052 ("bdi: separate out congested state into a separate struct")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b89f07ee2eff..80b95e21db43 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1784,11 +1784,13 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 
 	if (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
 		if (dm_request_based(md)) {
+			struct backing_dev_info *bdi =
+				md->queue->backing_dev_info;
 			/*
 			 * With request-based DM we only need to check the
 			 * top-level queue for congestion.
 			 */
-			r = md->queue->backing_dev_info->wb.state & bdi_bits;
+			r = bdi->wb.congested->state & bdi_bits;
 		} else {
 			map = dm_get_live_table_fast(md);
 			if (map)
@@ -2265,6 +2267,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 			DMERR("Cannot initialize queue for request-based dm-mq mapped device");
 			return r;
 		}
+		dm_init_normal_md_queue(md);
 		break;
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-- 
2.25.0.4.g0ad7144999
