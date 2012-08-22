From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 09/13] block: Rename bio_split() -> bio_pair_split()
Date: Wed, 22 Aug 2012 10:04:06 -0700
Message-ID: <1345655050-28199-10-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
List-Id: dm-devel.ids

This is prep work for introducing a more general bio_split()

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
CC: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
CC: Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>
CC: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
---
 drivers/block/drbd/drbd_req.c | 2 +-
 drivers/block/pktcdvd.c       | 2 +-
 drivers/block/rbd.c           | 3 ++-
 drivers/md/linear.c           | 2 +-
 drivers/md/raid0.c            | 6 +++---
 drivers/md/raid10.c           | 4 ++--
 fs/bio.c                      | 4 ++--
 include/linux/bio.h           | 2 +-
 8 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 910335c..fbb0471 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1149,7 +1149,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 		const int sps = 1 << HT_SHIFT; /* sectors per slot */
 		const int mask = sps - 1;
 		const sector_t first_sectors = sps - (sect & mask);
-		bp = bio_split(bio, first_sectors);
+		bp = bio_pair_split(bio, first_sectors);
 
 		/* we need to get a "reference count" (ap_bio_cnt)
 		 * to avoid races with the disconnect/reconnect/suspend code.
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ae55f08..18393a1 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2469,7 +2469,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
-			bp = bio_split(bio, first_sectors);
+			bp = bio_pair_split(bio, first_sectors);
 			BUG_ON(!bp);
 			pkt_make_request(q, &bp->bio1);
 			pkt_make_request(q, &bp->bio2);
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 9917943..1f5b483 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -751,7 +751,8 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 
 			/* split the bio. We'll release it either in the next
 			   call, or it will have to be released outside */
-			bp = bio_split(old_chain, (len - total) / SECTOR_SIZE);
+			bp = bio_pair_split(old_chain,
+					    (len - total) / SECTOR_SIZE);
 			if (!bp)
 				goto err_out;
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fa211d8..e860cb9 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -314,7 +314,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 
 		rcu_read_unlock();
 
-		bp = bio_split(bio, end_sector - bio->bi_sector);
+		bp = bio_pair_split(bio, end_sector - bio->bi_sector);
 
 		linear_make_request(mddev, &bp->bio1);
 		linear_make_request(mddev, &bp->bio2);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index de63a1f..c89c8aa 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -516,11 +516,11 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		 * refuse to split for us, so we need to split it.
 		 */
 		if (likely(is_power_of_2(chunk_sects)))
-			bp = bio_split(bio, chunk_sects - (sector &
+			bp = bio_pair_split(bio, chunk_sects - (sector &
 							   (chunk_sects-1)));
 		else
-			bp = bio_split(bio, chunk_sects -
-				       sector_div(sector, chunk_sects));
+			bp = bio_pair_split(bio, chunk_sects -
+					    sector_div(sector, chunk_sects));
 		raid0_make_request(mddev, &bp->bio1);
 		raid0_make_request(mddev, &bp->bio2);
 		bio_pair_release(bp);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1c2eb38..0f31ec4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1087,8 +1087,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio,
-			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+		bp = bio_pair_split(bio,
+				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
 
 		/* Each of these 'make_request' calls will call 'wait_barrier'.
 		 * If the first succeeds but the second blocks due to the resync
diff --git a/fs/bio.c b/fs/bio.c
index b9c022c..2f2cf19 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1495,7 +1495,7 @@ static void bio_pair_end_2(struct bio *bi, int err)
 /*
  * split a bio - only worry about a bio with a single page in its iovec
  */
-struct bio_pair *bio_split(struct bio *bi, int first_sectors)
+struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
 {
 	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
 
@@ -1538,7 +1538,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 
 	return bp;
 }
-EXPORT_SYMBOL(bio_split);
+EXPORT_SYMBOL(bio_pair_split);
 
 /**
  *      bio_sector_offset - Find hardware sector offset in bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 427d05a..13f4188 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -201,7 +201,7 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
-extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
+extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
-- 
1.7.12
