From: Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] dm bufio: simplify the return expression of skip_metadata()
Date: Mon, 21 Sep 2020 21:10:10 +0800
Message-ID: <20200921131010.91236-1-miaoqinglang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>
List-Id: dm-devel.ids

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/md/dm-snap-persistent.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 63fab7c76..74b483fed 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -284,16 +284,11 @@ static void skip_metadata(struct pstore *ps)
  */
 static int area_io(struct pstore *ps, int op, int op_flags)
 {
-	int r;
 	chunk_t chunk;
 
 	chunk = area_location(ps, ps->current_area);
 
-	r = chunk_io(ps, ps->area, chunk, op, op_flags, 0);
-	if (r)
-		return r;
-
-	return 0;
+	return chunk_io(ps, ps->area, chunk, op, op_flags, 0);
 }
 
 static void zero_memory_area(struct pstore *ps)
-- 
2.23.0
