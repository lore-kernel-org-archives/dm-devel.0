From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 3/3] dm: remove redundant unlikely annotation in
	dm-block-manager.c
Date: Wed, 13 Feb 2019 13:46:58 +0800
Message-ID: <20190213054658.31598-3-cgxu519@gmx.com>
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
 drivers/md/persistent-data/dm-block-manager.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 492a3f8ac119..3972232b8037 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -462,7 +462,7 @@ int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
 	int r;
 
 	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 
 	aux = dm_bufio_get_aux_data(to_buffer(*result));
@@ -498,7 +498,7 @@ int dm_bm_write_lock(struct dm_block_manager *bm,
 		return -EPERM;
 
 	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 
 	aux = dm_bufio_get_aux_data(to_buffer(*result));
@@ -531,7 +531,7 @@ int dm_bm_read_try_lock(struct dm_block_manager *bm,
 	int r;
 
 	p = dm_bufio_get(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 	if (unlikely(!p))
 		return -EWOULDBLOCK;
@@ -567,7 +567,7 @@ int dm_bm_write_lock_zero(struct dm_block_manager *bm,
 		return -EPERM;
 
 	p = dm_bufio_new(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 
 	memset(p, 0, dm_bm_block_size(bm));
-- 
2.20.1
