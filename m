From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/4] dm: fix clone_bio() to trigger
	blk_recount_segments()
Date: Sat, 19 Jan 2019 13:05:03 -0500
Message-ID: <20190119180506.1300-2-snitzer@redhat.com>
References: <20190119180506.1300-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190119180506.1300-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, NeilBrown <neilb@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

DM's clone_bio() now benefits from using bio_trim() by fixing the fact
that clone_bio() wasn't clearing BIO_SEG_VALID like bio_trim() does;
which triggers blk_recount_segments() via bio_phys_segments().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d67c95ef8d7e..fcb97b0a5743 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1320,7 +1320,7 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 
 	__bio_clone_fast(clone, bio);
 
-	if (unlikely(bio_integrity(bio) != NULL)) {
+	if (bio_integrity(bio)) {
 		int r;
 
 		if (unlikely(!dm_target_has_integrity(tio->ti->type) &&
@@ -1336,11 +1336,7 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 			return r;
 	}
 
-	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
-	clone->bi_iter.bi_size = to_bytes(len);
-
-	if (unlikely(bio_integrity(bio) != NULL))
-		bio_integrity_trim(clone);
+	bio_trim(clone, sector - clone->bi_iter.bi_sector, len);
 
 	return 0;
 }
-- 
2.15.0
