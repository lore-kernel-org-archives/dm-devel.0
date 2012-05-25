From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 09/16] block: Add bio_clone_kmalloc()
Date: Fri, 25 May 2012 13:25:32 -0700
Message-ID: <1337977539-16977-10-git-send-email-koverstreet@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337977539-16977-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk, yehuda@hq.newdream.net, Kent Overstreet <koverstreet@google.com>, mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com, tj@kernel.org, sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Change-Id: I4aad3ae23640e847056f9de54d6cb75b0ddaa85b
---
 drivers/block/osdblk.c |    3 +--
 fs/bio.c               |   13 +++++++++++++
 fs/exofs/ore.c         |    5 ++---
 include/linux/bio.h    |    1 +
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 87311eb..1bbc681 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -266,11 +266,10 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
 	struct bio *tmp, *new_chain = NULL, *tail = NULL;
 
 	while (old_chain) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_clone_kmalloc(old_chain, gfpmask);
 		if (!tmp)
 			goto err_out;
 
-		__bio_clone(tmp, old_chain);
 		tmp->bi_bdev = NULL;
 		gfpmask &= ~__GFP_WAIT;
 		tmp->bi_next = NULL;
diff --git a/fs/bio.c b/fs/bio.c
index 62c4af81..d212ee2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -489,6 +489,19 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(bio_clone);
 
+struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
+{
+	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
+
+	if (!b)
+		return NULL;
+
+	__bio_clone(b, bio);
+
+	return b;
+}
+EXPORT_SYMBOL(bio_clone_kmalloc);
+
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
  *	@bdev:  I/O target
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 49cf230..95c7264 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -820,8 +820,8 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 			struct bio *bio;
 
 			if (per_dev != master_dev) {
-				bio = bio_kmalloc(GFP_KERNEL,
-						  master_dev->bio->bi_max_vecs);
+				bio = bio_clone_kmalloc(master_dev->bio,
+							GFP_KERNEL);
 				if (unlikely(!bio)) {
 					ORE_DBGMSG(
 					      "Failed to allocate BIO size=%u\n",
@@ -830,7 +830,6 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 					goto out;
 				}
 
-				__bio_clone(bio, master_dev->bio);
 				bio->bi_bdev = NULL;
 				bio->bi_next = NULL;
 				per_dev->offset = master_dev->offset;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 486233c..8f280f7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -220,6 +220,7 @@ extern int bio_phys_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone(struct bio *, gfp_t);
+struct bio *bio_clone_kmalloc(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
-- 
1.7.9.3.327.g2980b
