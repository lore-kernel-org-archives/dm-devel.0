From: zhou xianrong <zhou_xianrong@yeah.net>
Subject: [PATCH] dm-verity: unnecessary data blocks that need not
	read hash blocks
Date: Wed, 11 Dec 2019 11:32:40 +0800
Message-ID: <20191211033240.169-1-zhou_xianrong@yeah.net>
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
Cc: weimin.mao@transsion.com, haizhou.song@transsion.com, snitzer@redhat.com, wanbin.wang@transsion.com, xianrong.zhou@transsion.com, linux-kernel@vger.kernel.org, yuanjiong.gao@transsion.com, ruxian.feng@transsion.com, agk@redhat.com
List-Id: dm-devel.ids

From: "xianrong.zhou" <xianrong.zhou@transsion.com>

If check_at_most_once enabled, just like verity work the prefetching work
should check for data block bitmap firstly before reading hash block
as well. Skip bit-set data blocks from both ends of data block range
by testing the validated bitmap. This can reduce the amounts of data 
blocks which need to read hash blocks.

Launching 91 apps every 15s and repeat 21 rounds on Android Q.
In prefetching work we can let only 2602/360312 = 0.72% data blocks
really need to read hash blocks.

But the reduced data blocks range would be enlarged again by
dm_verity_prefetch_cluster later.

Signed-off-by: xianrong.zhou <xianrong.zhou@transsion.com>
Signed-off-by: yuanjiong.gao <yuanjiong.gao@transsion.com>
Tested-by: ruxian.feng <ruxian.feng@transsion.com>
---
 drivers/md/dm-verity-target.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4fb33e7562c5..7b8eb754c0b6 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -581,6 +581,22 @@ static void verity_prefetch_io(struct work_struct *work)
 	struct dm_verity *v = pw->v;
 	int i;
 
+	if (v->validated_blocks) {
+		while (pw->n_blocks) {
+			if (unlikely(!test_bit(pw->block, v->validated_blocks)))
+				break;
+			pw->block++;
+			pw->n_blocks--;
+		}
+		while (pw->n_blocks) {
+			if (unlikely(!test_bit(pw->block + pw->n_blocks - 1,
+				v->validated_blocks)))
+				break;
+			pw->n_blocks--;
+		}
+		if (!pw->n_blocks)
+			return;
+	}
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
 		sector_t hash_block_end;
-- 
2.17.0
