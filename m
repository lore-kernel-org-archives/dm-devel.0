From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 2/3] dm: remove redundant unlikely annotation in
	dm-verity-fec.c
Date: Wed, 13 Feb 2019 13:46:57 +0800
Message-ID: <20190213054658.31598-2-cgxu519@gmx.com>
References: <20190213054658.31598-1-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190213054658.31598-1-cgxu519@gmx.com>
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
 drivers/md/dm-verity-fec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 0ce04e5b4afb..b634fa23f4c4 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -73,7 +73,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
 
 	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
-	if (unlikely(IS_ERR(res))) {
+	if (IS_ERR(res)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
 		      (unsigned long long)(v->fec->start + block),
@@ -163,7 +163,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
-			if (unlikely(IS_ERR(par)))
+			if (IS_ERR(par))
 				return PTR_ERR(par);
 		}
 	}
@@ -253,7 +253,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		}
 
 		bbuf = dm_bufio_read(bufio, block, &buf);
-		if (unlikely(IS_ERR(bbuf))) {
+		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
 				     v->data_dev->name,
 				     (unsigned long long)rsb,
-- 
2.20.1
