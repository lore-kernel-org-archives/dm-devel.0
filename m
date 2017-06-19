From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] pktcdvd: remove the call to blk_queue_bounce
Date: Mon, 19 Jun 2017 09:26:19 +0200
Message-ID: <20170619072628.12894-2-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

pktcdvd is a make_request based stacking driver and thus doesn't have any
addressing limits on it's own.  It also doesn't use bio_data() or
page_address(), so it doesn't need a lowmem bounce either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 26c04baae967..7f2eca31eb6a 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2413,8 +2413,6 @@ static blk_qc_t pkt_make_request(struct request_queue *q, struct bio *bio)
 	char b[BDEVNAME_SIZE];
 	struct bio *split;
 
-	blk_queue_bounce(q, &bio);
-
 	blk_queue_split(q, &bio);
 
 	pd = q->queuedata;
-- 
2.11.0
