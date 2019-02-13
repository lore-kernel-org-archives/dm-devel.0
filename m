From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 1/3] dm: remove redundant unlikely annotation in
	dm-integrity.c
Date: Wed, 13 Feb 2019 13:46:56 +0800
Message-ID: <20190213054658.31598-1-cgxu519@gmx.com>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: Chengguang Xu <cgxu519@gmx.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

unlikely has already included in IS_ERR(),
so just remove redundant unlikely annotation.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 457200ca6287..f1ab81b19de9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1122,7 +1122,7 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 			return r;
 
 		data = dm_bufio_read(ic->bufio, *metadata_block, &b);
-		if (unlikely(IS_ERR(data)))
+		if (IS_ERR(data))
 			return PTR_ERR(data);
 
 		to_copy = min((1U << SECTOR_SHIFT << ic->log2_buffer_sectors) - *metadata_offset, total_size);
-- 
2.20.1
