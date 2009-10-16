From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/9] rqdm core: alloc_rq_tio() takes gfp_mask
Date: Fri, 16 Oct 2009 13:58:34 +0900
Message-ID: <4AD7FD7A.2060304@ct.jp.nec.com>
References: <4AD7FC11.7030009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD7FC11.7030009@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds the gfp_mask argument to alloc_rq_tio().
No functional change.

This patch is a preparation for PATCH 9, which needs to allocate
tio (for barrier I/O) with different allocation flag (GFP_NOIO) from
the one in the normal I/O code path.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -430,9 +430,10 @@ static void free_tio(struct mapped_devic
 	mempool_free(tio, md->tio_pool);
 }
 
-static struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md)
+static struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md,
+					    gfp_t gfp_mask)
 {
-	return mempool_alloc(md->tio_pool, GFP_ATOMIC);
+	return mempool_alloc(md->tio_pool, gfp_mask);
 }
 
 static void free_rq_tio(struct dm_rq_target_io *tio)
@@ -1469,7 +1470,7 @@ static int dm_prep_fn(struct request_que
 		return BLKPREP_KILL;
 	}
 
-	tio = alloc_rq_tio(md); /* Only one for each original request */
+	tio = alloc_rq_tio(md, GFP_ATOMIC);
 	if (!tio)
 		/* -ENOMEM */
 		return BLKPREP_DEFER;
