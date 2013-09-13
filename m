From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 1/3] dm: lower bio-based mempool reservation
Date: Fri, 13 Sep 2013 17:08:12 -0400
Message-ID: <1379106494-16366-2-git-send-email-snitzer@redhat.com>
References: <20130913203005.GA8635@redhat.com>
	<1379106494-16366-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379106494-16366-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Bio-based device mapper processing doesn't need larger mempools (like
request-based DM does), so lower the number of reserved entries for
bio-based operation.  16 was already used for bio-based DM's bioset
but mistakenly wasn't used for it's _io_cache.

Formalize difference between bio-based and request-based defaults by
introducing RESERVED_BIO_BASED_IOS and RESERVED_REQUEST_BASED_IOS.

(based on older code from Mikulas Patocka)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6a5e9ed..47bac14 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -211,7 +211,8 @@ struct dm_md_mempools {
 	struct bio_set *bs;
 };
 
-#define MIN_IOS 256
+#define RESERVED_BIO_BASED_IOS		16
+#define RESERVED_REQUEST_BASED_IOS	256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
 
@@ -2862,18 +2863,18 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 
 	if (type == DM_TYPE_BIO_BASED) {
 		cachep = _io_cache;
-		pool_size = 16;
+		pool_size = RESERVED_BIO_BASED_IOS;
 		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 	} else if (type == DM_TYPE_REQUEST_BASED) {
 		cachep = _rq_tio_cache;
-		pool_size = MIN_IOS;
+		pool_size = RESERVED_REQUEST_BASED_IOS;
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
 		/* per_bio_data_size is not used. See __bind_mempools(). */
 		WARN_ON(per_bio_data_size != 0);
 	} else
 		goto out;
 
-	pools->io_pool = mempool_create_slab_pool(MIN_IOS, cachep);
+	pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
 	if (!pools->io_pool)
 		goto out;
 
-- 
1.7.1
