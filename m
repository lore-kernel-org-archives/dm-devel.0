From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH 2/4] block: use bio_clone_fast() in
	blk_rq_prep_clone()
Date: Fri, 3 Oct 2014 11:55:20 +0000
Message-ID: <542E8EA8.6070004@ce.jp.nec.com>
References: <542E8CF9.6000609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <542E8CF9.6000609@ce.jp.nec.com>
Content-Language: ja-JP
Content-ID: <308017FD40294F42B5A732246462F5D4@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

Request cloning clones bios in the request to track the completion
of each bio.
For that purpose, we can use bio_clone_fast() instead of bio_clone()
to avoid unnecessary allocation and copy of bvecs.

This patch reduces memory footprint of request-based device-mapper
(about 1-4KB for each request) and is a preparation for further
reduction of memory usage by removing unused bvec mempool.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf930f4..a92f720 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2931,7 +2931,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	blk_rq_init(NULL, rq);
 
 	__rq_for_each_bio(bio_src, rq_src) {
-		bio = bio_clone_bioset(bio_src, gfp_mask, bs);
+		bio = bio_clone_fast(bio_src, gfp_mask, bs);
 		if (!bio)
 			goto free_and_out;
 
-- 
1.9.3
