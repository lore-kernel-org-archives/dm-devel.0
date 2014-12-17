From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 1/8] block: require blk_rq_prep_clone() be
	given an initialized clone request
Date: Tue, 16 Dec 2014 22:59:57 -0500
Message-ID: <1418788804-1982-2-git-send-email-snitzer@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

From: Keith Busch <keith.busch@intel.com>

Prepare to allow blk_rq_prep_clone() to accept clone requests that were
allocated from blk-mq request queues.  As such the blk_rq_prep_clone()
caller must first initialize the clone request.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c | 2 --
 drivers/md/dm.c  | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93f9152..b794cd99 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2926,8 +2926,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	if (!bs)
 		bs = fs_bio_set;
 
-	blk_rq_init(NULL, rq);
-
 	__rq_for_each_bio(bio_src, rq_src) {
 		bio = bio_clone_fast(bio_src, gfp_mask, bs);
 		if (!bio)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4c06585..bef5070 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1719,6 +1719,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
+	blk_rq_init(NULL, rq);
 	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
 			      dm_rq_bio_constructor, tio);
 	if (r)
-- 
1.9.3
