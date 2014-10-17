From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 1/4] dm: prep initialized requests
Date: Fri, 17 Oct 2014 17:46:35 -0600
Message-ID: <1413589598-17631-2-git-send-email-keith.busch@intel.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Require blk_rq_prep_clone use requests that have already been
initialized. This patch is preping to allow this path to accept requests
allocated from blk-mq request queues.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 block/blk-core.c |    2 --
 drivers/md/dm.c  |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf930f4..3abbc04 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2928,8 +2928,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	if (!bs)
 		bs = fs_bio_set;
 
-	blk_rq_init(NULL, rq);
-
 	__rq_for_each_bio(bio_src, rq_src) {
 		bio = bio_clone_bioset(bio_src, gfp_mask, bs);
 		if (!bio)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..809f83f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1605,6 +1605,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
+	blk_rq_init(NULL, rq);
 	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
 			      dm_rq_bio_constructor, tio);
 	if (r)
-- 
1.7.10.4
