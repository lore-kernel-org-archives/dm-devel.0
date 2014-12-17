From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/8] block: initialize bio member of blk-mq
	request to NULL
Date: Tue, 16 Dec 2014 22:59:58 -0500
Message-ID: <1418788804-1982-3-git-send-email-snitzer@redhat.com>
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

Otherwise blk_rq_prep_clone() will crash when cloning a blk-mq request,
with: BUG: unable to handle kernel paging request at 00001dfa0d00005e

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6cd94ba..ff09337 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -183,6 +183,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	rq->nr_integrity_segments = 0;
 #endif
+	rq->bio = NULL;
 	rq->special = NULL;
 	/* tag was already set */
 	rq->errors = 0;
-- 
1.9.3
