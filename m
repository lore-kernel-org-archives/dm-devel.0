From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: early return from blk_queue_split() if q->bio_split
 is NULL
Date: Mon, 20 Nov 2017 11:54:02 -0500
Message-ID: <20171120165401.GA10608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

DM appears to be the only block driver that doesn't lean on the block
core's bio splitting.  My hope is to fix that but in the meantime it
doesn't make sense for a device that doesn't need blk_queue_split() to
go through the associated work.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-merge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index f5dedd5..212004c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -186,6 +186,9 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
 	struct bio *split, *res;
 	unsigned nsegs;
 
+	if (!q->bio_split)
+		return;
+
 	switch (bio_op(*bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
-- 
2.10.1
