From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] dm: use bio_split() when splitting out the already processed bio
Date: Tue, 19 Jun 2018 06:52:11 +0200
Message-ID: <20180619045216.21130-2-hch@lst.de>
References: <20180619045216.21130-1-hch@lst.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180619045216.21130-1-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Boaz Harrosh <ooo@electrozaur.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer@redhat.com>

Use of bio_clone_bioset() is inefficient if there is no need to clone
the original bio's bio_vec array.  Best to use the bio_clone_fast()
variant.  Also, just using bio_advance() is only part of what is needed
to properly setup the clone -- it doesn't account for the various
bio_integrity() related work that also needs to be performed (see
bio_split).

Address both of these issues by switching from bio_clone_bioset() to
bio_split().

Fixes: 18a25da8 ("dm: ensure bio submission follows a depth-first tree walk")
Cc: stable@vger.kernel.org # 4.15+, requires removal of '&' before md->queue->bio_split
Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e65429a29c06..a3b103e8e3ce 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1606,10 +1606,9 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				 * the usage of io->orig_bio in dm_remap_zone_report()
 				 * won't be affected by this reassignment.
 				 */
-				struct bio *b = bio_clone_bioset(bio, GFP_NOIO,
-								 &md->queue->bio_split);
+				struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
+							  GFP_NOIO, &md->queue->bio_split);
 				ci.io->orig_bio = b;
-				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
 				bio_chain(b, bio);
 				ret = generic_make_request(bio);
 				break;
-- 
2.17.1
