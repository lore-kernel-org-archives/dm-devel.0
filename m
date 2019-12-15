From: xianrong_zhou@163.com
Subject: dm: shrink data blocks using bitmap for hash reading
Date: Sun, 15 Dec 2019 12:58:40 +0800
Message-ID: <20191215045840.9834-1-xianrong_zhou@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, haizhou.song@transsion.com, xianrong.zhou@transsion.com, xianrong_zhou <xianrong_zhou@163.com>, "yuanjiong . gao" <yuanjiong.gao@transsion.com>, "ruxian . feng" <ruxian.feng@transsion.com>
List-Id: dm-devel.ids

From: xianrong_zhou <xianrong_zhou@163.com>

If check_at_most_once enabled, just like verity work,
the prefetching work should check for data block bitmap
firstly before reading hash block as well.This can reduce
99.28% data blocks which need not to read hash blocks.

The reduced data blocks would be enlarged again by cluster
reading later.

Signed-off-by: xianrong_zhou <xianrong_zhou@163.com>
Signed-off-by: yuanjiong.gao <yuanjiong.gao@transsion.com>
Signed-off-by: ruxian.feng <ruxian.feng@transsion.com>
---
 drivers/md/dm-verity-target.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4fb33e7562c5..fe4c15a0723c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -581,6 +581,23 @@ static void verity_prefetch_io(struct work_struct *work)
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
+
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
 		sector_t hash_block_end;
-- 
2.17.2
